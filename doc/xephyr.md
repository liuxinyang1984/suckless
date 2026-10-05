# Xephyr 调试环境

在 Hyprland 下用 Xephyr 跑嵌套 X11，避免窗口跑到主桌面。

- Hyprland 多为 `DISPLAY=:0`（XWayland）
- Xephyr 用独立 display（例如 `:2`）
- 从 Hyprland 终端往里打程序要带 `DISPLAY=:2`

```bash
Xephyr :2 -screen 1600x900 -ac &
export DISPLAY=:2
unset WAYLAND_DISPLAY
export XDG_SESSION_TYPE=x11
export PATH="${HOME}/.local/bin:${PATH}"
dwm
```

打靶：

```bash
DISPLAY=:2 st
DISPLAY=:2 dmenu_run -c -bw 2
```

先点 Xephyr 窗口再按键，否则快捷键可能被 Hyprland 截走。display 被占用就换 `:3`。
