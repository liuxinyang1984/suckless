#!/bin/sh
# 编译安装 suckless 组件
# 默认：root 安装（doas/sudo make install → config.mk PREFIX，通常 /usr/local）
# --user：个人 ~/.local，不提权
# 可指定组件名单独安装
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
MODE=system
INSTALL_POLKIT=0
RELOAD_DWM=1
POLKIT_PROMPT="${POLKIT_PROMPT:-dmenu}"
ALL_COMPONENTS="dwm st dmenu dwmblocks tabbed surf slock"
# 未在命令行点名组件时，装全部
SELECTED=""
INSTALLED_DWM=0

usage() {
    cat <<'EOF'
用法: ./install.sh [选项] [组件...]

选项:
  （默认）     doas/sudo make install → config.mk 的 PREFIX（通常 /usr/local）
  --user       make PREFIX=$HOME/.local install（个人，不提权）
  --polkit     额外安装 mini-polkit（需要提权；也可把 mini-polkit 写在组件列表里）
  --prompt=dmenu|rofi
               mini-polkit 密码框后端（默认 dmenu；rofi 需先 x11:rofi）
  --prompt dmenu|rofi
               同上
  --no-reload  装完 dwm 后不自动 SIGHUP 重载（默认：有 DISPLAY 且 dwm 在跑则重载）
  -h, --help   显示本说明

组件（可多选；省略则全部）:
  dwm  st  dmenu  dwmblocks  tabbed  surf  slock  mini-polkit

重载依赖 dwm 的 restartsig 补丁：kill -HUP → exec 新二进制（同 argv[0]）。
Super+Ctrl+Shift+q 等效。

mini-polkit 也可单独装（更多说明见该目录）:
  ./mini-polkit/install.sh --help
  ./mini-polkit/install.sh --prompt=rofi

示例:
  ./install.sh                    # 系统 PREFIX，六个主程序
  ./install.sh --user             # 全部 → ~/.local
  ./install.sh dwm st             # 只装 dwm、st（系统）并尝试重载 dwm
  ./install.sh --user dmenu       # 只装 dmenu → ~/.local
  ./install.sh dwmblocks          # 状态栏 + shell_script/status 脚本
  ./install.sh mini-polkit        # 只装 polkit（默认 dmenu 提示）
  ./install.sh mini-polkit --prompt=rofi
  ./install.sh --polkit --prompt=rofi dwm
  ./install.sh --no-reload dwm    # 只编装，不重载会话中的 dwm

嵌套 submodule：git submodule update --init --recursive
EOF
}

# restartsig：SIGHUP → quit(restart=1) → execvp。XNextEvent 可能需一次 X 事件才能醒。
reload_dwm_if_running() {
    [ "$RELOAD_DWM" = 1 ] || return 0
    [ "$INSTALLED_DWM" = 1 ] || return 0
    if [ -z "${DISPLAY:-}" ]; then
        echo "（无 DISPLAY，跳过 dwm 重载；登录后或 Super+Ctrl+Shift+q）"
        return 0
    fi
    dwmpid=$(pidof dwm 2>/dev/null || true)
    if [ -z "$dwmpid" ]; then
        echo "（当前无 dwm 进程，跳过重载）"
        return 0
    fi
    old=$dwmpid
    echo "重载 dwm（SIGHUP pid $old，restartsig）…"
    kill -HUP $old 2>/dev/null || true
    # 唤醒可能堵在 XNextEvent 上的事件循环
    if command -v xsetroot >/dev/null 2>&1; then
        xsetroot -name "dwm-reload-$(date +%s)" 2>/dev/null || true
    fi
    i=0
    while [ "$i" -lt 20 ]; do
        sleep 0.1
        new=$(pidof dwm 2>/dev/null || true)
        # 进程已换，或短暂消失后起来
        if [ -n "$new" ] && [ "$new" != "$old" ]; then
            echo "dwm 已重载 → pid $new"
            return 0
        fi
        if [ -z "$new" ] && [ "$i" -gt 5 ]; then
            # 正在 exec 的空窗
            :
        fi
        i=$((i + 1))
    done
    new=$(pidof dwm 2>/dev/null || true)
    if [ -n "$new" ] && [ "$new" != "$old" ]; then
        echo "dwm 已重载 → pid $new"
    elif [ "$new" = "$old" ]; then
        echo "警告: dwm pid 未变（$old）。可再试 Super+Ctrl+Shift+q，或检查是否卡住。" >&2
    else
        echo "警告: 重载后未看到 dwm 进程。" >&2
    fi
}

is_component() {
    case "$1" in
        dwm|st|dmenu|dwmblocks|tabbed|surf|slock|mini-polkit) return 0 ;;
        *) return 1 ;;
    esac
}

while [ $# -gt 0 ]; do
    arg=$1
    case "$arg" in
        --user) MODE=user ;;
        --polkit) INSTALL_POLKIT=1 ;;
        --prompt=*)
            POLKIT_PROMPT="${arg#--prompt=}"
            INSTALL_POLKIT=1
            ;;
        --prompt)
            shift
            POLKIT_PROMPT="${1:-}"
            [ -n "$POLKIT_PROMPT" ] || { echo "缺少 --prompt 值" >&2; usage >&2; exit 1; }
            INSTALL_POLKIT=1
            ;;
        --no-reload) RELOAD_DWM=0 ;;
        -h|--help) usage; exit 0 ;;
        -*)
            echo "未知选项: $arg（见 ./install.sh --help）" >&2
            exit 1
            ;;
        *)
            if ! is_component "$arg"; then
                echo "未知组件: $arg（见 ./install.sh --help）" >&2
                exit 1
            fi
            SELECTED="$SELECTED $arg"
            ;;
    esac
    shift
done

case "$POLKIT_PROMPT" in
    dmenu|rofi) ;;
    *)
        echo "无效 --prompt=$POLKIT_PROMPT（仅 dmenu|rofi）" >&2
        usage >&2
        exit 1
        ;;
esac

# 规范化列表
SELECTED=$(echo "$SELECTED" | xargs)
if [ -z "$SELECTED" ]; then
    SELECTED="$ALL_COMPONENTS"
fi

# 列表里写了 mini-polkit 也算要装
case " $SELECTED " in
    *" mini-polkit "*) INSTALL_POLKIT=1 ;;
esac

# 主程序列表（去掉 mini-polkit）
MAIN=""
for c in $SELECTED; do
    [ "$c" = mini-polkit ] && continue
    MAIN="$MAIN $c"
done
MAIN=$(echo "$MAIN" | xargs)

run_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v doas >/dev/null 2>&1; then
        doas "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "需要 root（请安装 doas/sudo，或以 root 运行）" >&2
        exit 1
    fi
}

need_root() {
    if [ "$(id -u)" -eq 0 ]; then
        return 0
    fi
    if command -v doas >/dev/null 2>&1; then
        if doas -n true 2>/dev/null || doas true; then
            return 0
        fi
    fi
    if command -v sudo >/dev/null 2>&1; then
        if sudo -n true 2>/dev/null || sudo true; then
            return 0
        fi
    fi
    echo "无法提权：系统安装需要可交互的 doas/sudo 或 root" >&2
    exit 1
}

# 默认系统装、或装 polkit，都要提权
if [ "$MODE" = system ] || [ "$INSTALL_POLKIT" = 1 ]; then
    need_root
fi

install_status_scripts() {
    # shell_script/status/sb-* → $1/bin（须在 PATH 里，供 dwmblocks 调用）
    scripts="$ROOT/shell_script/status"
    if [ ! -d "$scripts" ]; then
        echo "缺少 $scripts（git submodule update --init --recursive）" >&2
        exit 1
    fi
    destbin="$1/bin"
    if [ "$MODE" = user ]; then
        mkdir -p "$destbin"
        for s in "$scripts"/sb-*; do
            [ -f "$s" ] || continue
            install -m 755 "$s" "$destbin/$(basename "$s")"
        done
    else
        run_root mkdir -p "$destbin"
        for s in "$scripts"/sb-*; do
            [ -f "$s" ] || continue
            run_root install -m 755 "$s" "$destbin/$(basename "$s")"
        done
    fi
}

for c in $MAIN; do
    src="$ROOT/$c"
    if [ ! -d "$src" ]; then
        echo "缺少 $src（git submodule update --init --recursive）" >&2
        exit 1
    fi
    echo "==== $c ===="
    # 保留本地 config.h（已 gitignore）。无：无则 make 从 config.def.h 生成；
    # 有则沿用。要吃 def 变更请自行 rm -f config.h 再跑本脚本。
    (
        cd "$src"
        make
        if [ "$MODE" = user ]; then
            echo "安装 → $HOME/.local"
            make PREFIX="$HOME/.local" install
            if [ "$c" = dwmblocks ]; then
                install_status_scripts "$HOME/.local"
            fi
        else
            echo "安装 → config.mk PREFIX（doas/sudo make install）"
            run_root make install
            if [ "$c" = dwmblocks ]; then
                install_status_scripts /usr/local
            fi
        fi
        if [ "$c" = dwm ]; then
            INSTALLED_DWM=1
        fi
        make clean
    )
done

if [ "$INSTALL_POLKIT" = 1 ]; then
    if [ ! -x "$ROOT/mini-polkit/install.sh" ]; then
        echo "缺少 $ROOT/mini-polkit/install.sh" >&2
        exit 1
    fi
    # 委托子脚本：编装 + prompt 配置 + mini-polkit-agent
    "$ROOT/mini-polkit/install.sh" --prompt="$POLKIT_PROMPT"
fi

reload_dwm_if_running

if [ "$MODE" = user ]; then
    echo "完成（个人 PREFIX=$HOME/.local）。组件:$MAIN${INSTALL_POLKIT:+ mini-polkit}"
else
    echo "完成（系统 PREFIX）。组件:$MAIN${INSTALL_POLKIT:+ mini-polkit}"
fi
