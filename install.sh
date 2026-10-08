#!/bin/sh
# 编译安装 suckless 组件
# 默认：root 安装（doas/sudo make install → config.mk PREFIX，通常 /usr/local）
# --user：个人 ~/.local，不提权
# 可指定组件名单独安装
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
MODE=system
INSTALL_POLKIT=0
ALL_COMPONENTS="dwm st dmenu slstatus tabbed surf"
# 未在命令行点名组件时，装全部
SELECTED=""

usage() {
    cat <<'EOF'
用法: ./install.sh [选项] [组件...]

选项:
  （默认）     doas/sudo make install → config.mk 的 PREFIX（通常 /usr/local）
  --user       make PREFIX=$HOME/.local install（个人，不提权）
  --polkit     额外安装 mini-polkit（需要提权；也可把 mini-polkit 写在组件列表里）
  -h, --help   显示本说明

组件（可多选；省略则全部）:
  dwm  st  dmenu  slstatus  tabbed  surf  mini-polkit

示例:
  ./install.sh                    # 系统 PREFIX，六个主程序
  ./install.sh --user             # 全部 → ~/.local
  ./install.sh dwm st             # 只装 dwm、st（系统）
  ./install.sh --user dmenu       # 只装 dmenu → ~/.local
  ./install.sh mini-polkit        # 只装 polkit（需提权）
  ./install.sh --polkit dwm       # dwm + mini-polkit

嵌套 submodule：git submodule update --init --recursive
EOF
}

is_component() {
    case "$1" in
        dwm|st|dmenu|slstatus|tabbed|surf|mini-polkit) return 0 ;;
        *) return 1 ;;
    esac
}

for arg in "$@"; do
    case "$arg" in
        --user) MODE=user ;;
        --polkit) INSTALL_POLKIT=1 ;;
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
done

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

for c in $MAIN; do
    src="$ROOT/$c"
    if [ ! -d "$src" ]; then
        echo "缺少 $src（git submodule update --init --recursive）" >&2
        exit 1
    fi
    echo "==== $c ===="
    (
        cd "$src"
        rm -f config.h
        make
        if [ "$MODE" = user ]; then
            echo "安装 → $HOME/.local"
            make PREFIX="$HOME/.local" install
        else
            echo "安装 → config.mk PREFIX（doas/sudo make install）"
            run_root make install
        fi
        make clean
        rm -f config.h
    )
done

if [ "$INSTALL_POLKIT" = 1 ]; then
    echo "==== mini-polkit ===="
    if [ ! -d "$ROOT/mini-polkit" ]; then
        echo "缺少 $ROOT/mini-polkit" >&2
        exit 1
    fi
    (
        cd "$ROOT/mini-polkit"
        make
        run_root make install
        make clean 2>/dev/null || true
    )
fi

if [ "$MODE" = user ]; then
    echo "完成（个人 PREFIX=$HOME/.local）。组件:$MAIN${INSTALL_POLKIT:+ mini-polkit}"
else
    echo "完成（系统 PREFIX）。组件:$MAIN${INSTALL_POLKIT:+ mini-polkit}"
fi
