# slstatus

[suckless slstatus](https://tools.suckless.org/slstatus/) — 往 dwm 状态栏写文本（CPU%、内存%、日期等）。

源码目录：[../slstatus](../slstatus)

## 依赖

Arch：

```bash
sudo pacman -S base-devel libx11
```

Alpine：

```bash
doas apk add build-base libx11-dev
```

## 构建

```bash
cd slstatus
rm -f config.h
make PREFIX=$HOME/.local install
```

栏内容在 `config.def.h`。改完删 `config.h` 再编。

## 启动

dwm 的 xinitrc 里、`exec dwm` 之前：

```sh
slstatus &
```

不要再跑 `while …; do xsetroot …; done`，会抢栏。Hyprland 不要起 slstatus。

## 相关

- [index.md](index.md)
- [dwm.md](dwm.md)
- [xephyr.md](xephyr.md)
