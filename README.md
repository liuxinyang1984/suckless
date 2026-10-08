# suckless

个人 fork 的 dwm / st / dmenu / tabbed / surf / slstatus，外加 [mini-polkit](https://github.com/liuxinyang1984/mini-polkit)。父仓库只放说明和子模块指针；补丁历史在各子仓里。

日常桌面是 Hyprland。这套给 X11 / dwm 用。当前 dwm 的 **Mod 是 Alt**（Hyprland 占 Super；切到 dwm 桌面再改 `Mod4Mask`）。键位以各仓 `config.def.h` 为准（dmenu 的 Ctrl 键在 `dmenu.c`）。改 `config.def.h` 后删 `config.h` 再编译。

GitHub：`git@github.com:liuxinyang1984/<仓名>.git`（`suckless`、`dwm`、`st`、`dmenu`、`tabbed`、`surf`、`slstatus`、`mini-polkit`）。surf 跟踪上游分支 `surf-webkit2`。

## 克隆

```bash
git clone --recursive git@github.com:liuxinyang1984/suckless.git
cd suckless
```

已有目录补子模块：

```bash
git submodule update --init --recursive
```

各子仓另有上游 `origin`（suckless.org 或 mini-polkit 原作者），GitHub 在 remote `github`。推自己的补丁：`cd dwm && git push github`。

## 依赖

Arch：

```bash
sudo pacman -S base-devel libx11 libxft libxext libxinerama fontconfig freetype2 \
  libx11-xcb xcb-util libxcb \
  gtk3 gcr webkit2gtk-4.1
```

Alpine：

```bash
doas apk add build-base libx11-dev libxft-dev libxext-dev libxinerama-dev \
  fontconfig-dev freetype-dev libxcb-dev xcb-util-dev \
  gtk+3.0-dev gcr-dev webkit2gtk-4.1-dev pkgconf
```

dwm swallow 需要 xcb。surf 需要 GTK3 / GCR / WebKitGTK（`pkg-config` 名见 `surf/config.mk`）。拉 GitHub 不稳时终端 `proxyon`。

也可用 [dotfiles](https://github.com/liuxinyang1984/dotfiles) 的安装脚本（同样这六个，并装 fontconfig）：

```bash
~/git/dotfiles/install.sh desktop:suckless
# 个人：SUCKLESS_USER=1 ./install.sh desktop:suckless
# 部分组件：SUCKLESS_COMPONENTS="dwm st" ./install.sh desktop:suckless
```

mini-polkit：`INSTALL_POLKIT=1 ~/git/dotfiles/install.sh desktop:suckless`（或 `./install.sh --polkit` / `./install.sh mini-polkit`）。

## 安装 dwm / st / dmenu / tabbed / surf / slstatus

默认：`make` 后 **`doas`/`sudo make install`**（各仓 `config.mk` PREFIX，一般为 `/usr/local`）。`--user` 则装到 `~/.local` 且不提权。可指定组件单独安装。

```bash
~/git/suckless/install.sh                 # 系统 PREFIX，六个主程序
~/git/suckless/install.sh --user          # 全部 → ~/.local
~/git/suckless/install.sh dwm st          # 只装 dwm、st（系统）
~/git/suckless/install.sh --user dmenu    # 只装 dmenu → ~/.local
~/git/suckless/install.sh mini-polkit     # 只装 polkit（需提权）
~/git/suckless/install.sh --help
```

改配置后对该目录：`rm -f config.h && make && doas make install`（或 `--user` 时 `PREFIX=$HOME/.local`）。dwm 要重启才吃新键位。

常用启动：

```bash
tabbed -c st -e
tabbed -c surf -e https://example.com
# 或用仓内脚本（会复用已有 tabbed）
surf-open.sh https://example.com
```

Xephyr 嵌套 X11 调试见 [doc/xephyr.md](doc/xephyr.md)。从 Hyprland 往里送程序：`DISPLAY=:2 …`。

## 安装 mini-polkit

Hyprland **不要**用（继续 hyprpolkitagent）。只给 dwm 的 X 会话。

```bash
~/git/suckless/install.sh --polkit
# 或：~/git/suckless/install.sh mini-polkit
```

dmenu 已有 `-P`。在 dwm 的 xinitrc 里、`exec dwm` 之前：

```sh
slstatus &
mini-polkit "dmenu -P -c -bw 2 -p Password:" &
exec dwm
```

Hyprland **不要**起 slstatus。栏右显示 CPU%、内存%、星期日期时间（`slstatus/config.def.h`）。Xephyr 里同一 `DISPLAY` 再开 slstatus。

同一会话不要再起其它 polkit agent。`polkit.service` 不用改。测：`pkexec echo ok`。

## dwm 快捷键

| 键 | 作用 |
|----|------|
| Mod+Space | dmenu_run（居中、2px 边框） |
| Mod+Return | st |
| Mod+` | scratchpad |
| Mod+b | 显隐状态栏 |
| Mod+j / k | 焦点下 / 上 |
| Mod+Shift+j / k | 窗口在栈里下移 / 上移 |
| Mod+h / l | 主区域变窄 / 变宽 |
| Mod+i / d | master 窗口数 +1 / −1 |
| Mod+Ctrl+Return | 当前窗与 master 交换 |
| Mod+Tab | 回到上次 tag |
| Mod+t | 当前窗浮动切换 |
| Mod+m | 单窗布局（monocle）开关 |
| Mod+Shift+m | 真全屏 |
| Mod+Shift+f | 假全屏 |
| Mod+q | 关当前窗 |
| Mod+Shift+q | xkill |
| Mod+Shift+e | 退出 dwm |
| Mod+Ctrl+Shift+q | 重启 dwm |
| Mod+1…9 | 看 tag |
| Mod+Shift+1…9 | 把窗打到 tag |
| Mod+Ctrl+1…9 | 额外显示该 tag |
| Mod+Ctrl+Shift+1…9 | 窗是否属于该 tag |
| Mod+0 | 看全部 tag |
| Mod+Shift+0 | 窗打到全部 tag |
| Mod+, / . | 焦点到上 / 下一块屏 |
| Mod+Shift+, / . | 窗送到上 / 下一块屏 |
| Mod+- / = | 间隙 − / + |
| Mod+Shift+= | 间隙归零 |

鼠标按住 Mod 点客户窗：左键移动，中键浮动，右键缩放。

## st 快捷键

| 键 | 作用 |
|----|------|
| Ctrl+= 或 Ctrl++ | 字号 + |
| Ctrl+- | 字号 − |
| Ctrl+0 | 字号复位 |
| 小键盘 Ctrl++/−/0 | 同上 |
| Ctrl+Shift+j / k | 回滚下一行 / 上一行 |
| Shift+PageUp / PageDown | 回滚一整屏 |
| Shift+Home / End | 到历史顶 / 底 |
| 滚轮 | 回滚历史 |
| Ctrl+Shift+c / v | 剪贴板复制 / 粘贴 |
| Shift+Insert 或 Ctrl+Shift+y | 主选区粘贴 |
| 中键 | 粘贴选区 |

备用屏（vim 全屏等）不回滚。

## dmenu 快捷键

Mod+Space 拉起。默认横条；竖列加 `-l 20`。

| 键 | 作用 |
|----|------|
| Ctrl+j / k | 下一项 / 上一项 |
| Ctrl+n / p | 同上 |
| 方向键 | 移动选择 / 光标 |
| Enter / Ctrl+m | 确认 |
| Esc、Ctrl+c、Ctrl+g、Ctrl+[ | 取消 |
| Tab | 补全 |
| Ctrl+h | 退格 |
| Ctrl+u | 删掉光标左侧 |
| Ctrl+w | 删一词 |
| Ctrl+a / e | 行首 / 行尾 |
| Ctrl+b / f | 左 / 右 |
| Ctrl+d | Delete |

密码框：`dmenu -P -c -bw 2 -p Password:`（不要给日常 `dmenu_run` 加 `-P`）。

## 相关

- [doc/index.md](doc/index.md)
- [dwm](https://github.com/liuxinyang1984/dwm) · [st](https://github.com/liuxinyang1984/st) · [dmenu](https://github.com/liuxinyang1984/dmenu) · [tabbed](https://github.com/liuxinyang1984/tabbed) · [surf](https://github.com/liuxinyang1984/surf) · [slstatus](https://github.com/liuxinyang1984/slstatus) · [mini-polkit](https://github.com/liuxinyang1984/mini-polkit)
- 上游：[dwm](https://dwm.suckless.org/) · [st](https://st.suckless.org/) · [dmenu](https://tools.suckless.org/dmenu/) · [tabbed](https://tools.suckless.org/tabbed/) · [surf](https://surf.suckless.org/) · [slstatus](https://tools.suckless.org/slstatus/)
