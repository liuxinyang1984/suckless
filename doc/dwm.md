# dwm

[suckless dwm](https://dwm.suckless.org/) — 动态窗口管理器。

源码目录：[../dwm](../dwm)

## 版本

```
44dbc68  buttonpress: fix status text click area mismatch
```

```bash
cd dwm && git log -1 --oneline
```

## 依赖

Arch：

```bash
sudo pacman -S base-devel libx11 libxinerama libxft libxext libxcb xcb-util
# 多媒体键（可选运行时）：pipewire 的 wpctl、brightnessctl
```

Alpine：

```bash
doas apk add build-base libx11-dev libxinerama-dev libxft-dev libxext-dev \
  libxcb-dev xcb-util-dev
```

## 构建

```bash
cd dwm
cp config.def.h config.h
make clean
make
make PREFIX=$HOME/.local install
```

## Patches

| 顺序 | Patch | 说明 |
|------|-------|------|
| … | （既有 attachbottom / gaps / systray / …） | 见 `dwm/patches/` |
| 后 | `dwm-status2d-systray-20261031.diff` | status2d（色/矩形），已与现有 systray 合入 `drawbar` |

status2d 用法（由 dwmblocks / `sb-*` 输出）：

- `^c#RRGGBB^` 前景 · `^b#RRGGBB^` 文字背景 · `^d^` 恢复 SchemeNorm
- `^rx,y,w,h^` 画矩形 · `^fN^` 光标前移 N 像素

`stext` 缓冲已扩到 1024；块输出见 dwmblocks `MAX_BLOCK_OUTPUT_LENGTH`。

## config.h 要点

Gruvbox 色、多媒体键、布局 `[T]`/`[F]`/`[M]`、栏左 `archicon`（Nerd Font Arch）等以 `config.def.h` 为准。

## 在 Xephyr 中运行

<!-- 替换 twm 后的 xinitrc、启动方式 -->

## 已知问题

## 相关

- [index.md](index.md)
- [st.md](st.md)
- [dmenu.md](dmenu.md)
- [xephyr.md](xephyr.md)
