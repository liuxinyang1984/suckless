# st

[suckless st](https://st.suckless.org/) — 简单终端。

源码目录：[../st](../st)

## 版本

```bash
cd st && git log -1 --oneline
```

当前在 0.9.3 上叠加 kitty-graphics 与既有补丁（见下）。

## 依赖

Arch：

```bash
sudo pacman -S base-devel libx11 libxft libxext fontconfig freetype2 imlib2 zlib
```

Alpine：

```bash
doas apk add build-base libx11-dev libxft-dev libxext-dev fontconfig-dev freetype-dev \
  imlib2-dev zlib-dev
```

`imlib2` / `zlib` 为 **kitty-graphics** 所需。

## 构建

```bash
cd st
cp config.def.h config.h   # 首次；改 config.h 不碰 config.def.h
make clean
make
make PREFIX=$HOME/.local install
```

## Patches

顺序（相对干净 0.9.3 `6e97047`）：

| 顺序 | Patch | 说明 |
|------|-------|------|
| 1 | `st-kitty-graphics-20251230-0.9.3.diff` | Kitty Graphics Protocol 子集；内含 anysize、underline color/style；依赖 imlib2/zlib |
| 2 | `st-alpha-20240814-a0274bc.diff` | 背景透明（`alpha`） |
| 3 | `st-boxdraw_v2-0.8.5.diff` | 盒线 / braille 自绘（与 kitty 手工合并） |
| 4 | `st-scrollback-reflow-standalone-0.9.3.diff` | 回滚 + 重排（与 kitty 手工合并） |

另有（改 `config.def.h`，无独立 diff 文件）：字体 monospace 16、Ctrl+Shift+=/− 缩放、fix-keyboard-input（CSI u）、`anysize_*align=0`。

补丁原文在 `st/patches/`。yazi 等预览：本机 st 已支持 kitty 协议；SSH 远端仍看客户端能力。需要假装 kitty 时可 `TERM=xterm-kitty`（yazi 新版本也可认 st-graphics 的 XTVERSION）。

## config.h 要点

- `font`：`monospace:size=16`
- `alpha`：`0.8`
- `boxdraw` / `boxdraw_braille`：开
- `anysize_halign` / `anysize_valign`：`0`（余量靠右下）
- `scrollback_lines`：`5000`
- 图形缓存与上限：见 `graphics_*` 配置项

## 中文环境

- 显示：UTF-8；CJK 仍依赖 fontconfig 回退（尚未打 `font2`）
- 输入：XIM + fcitx5

## 已知问题

- kitty-graphics 与 boxdraw / scrollback-reflow 有冲突，本仓已手工合并；升级补丁时勿盲目 `git apply`。
- 经典 placements 叠在 Unicode placeholder 上，部分依赖 z-index 的程序会有残影/擦除异常（上游 st-graphics 说明）。

## 相关

- [index.md](index.md)
- [xephyr.md](xephyr.md)
- [st-graphics](https://github.com/sergei-grechanik/st-graphics)
