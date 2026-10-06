# dmenu

[suckless dmenu](https://tools.suckless.org/dmenu/) — 动态菜单 / launcher。

源码目录：[../dmenu](../dmenu)

## 版本

```
7175c48  add -of and -ob arguments for outline colors options for multi-selection
```

```bash
cd dmenu && git log -1 --oneline
```

## 依赖

Arch：

```bash
sudo pacman -S base-devel libx11 libxft libxext fontconfig
```

Alpine：

```bash
doas apk add build-base libx11-dev libxft-dev libxext-dev fontconfig-dev
```

## 构建

```bash
cd dmenu
cp config.def.h config.h
make clean
make
make PREFIX=$HOME/.local install
```

## Patches

<!-- 记录 patch 文件名、顺序、适用 commit、简要说明 -->

| 顺序 | Patch | 说明 |
|------|-------|------|
|      |       |      |

## config.h 要点

<!-- 字体、颜色、默认参数等 -->

## 测试

```bash
echo -e "one\ntwo\nthree" | dmenu
```

在 Xephyr 内通过 dwm 键位或 `DISPLAY=:2 dmenu` 测试。

## 已知问题

## 相关

- [index.md](index.md)
- [dwm.md](dwm.md)
- [xephyr.md](xephyr.md)
