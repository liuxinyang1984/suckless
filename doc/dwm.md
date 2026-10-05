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

## 依赖（Arch）

```bash
sudo pacman -S base-devel libx11 libxinerama libxft libxext
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

<!-- 记录 patch 文件名、顺序、适用 commit、简要说明 -->

| 顺序 | Patch | 说明 |
|------|-------|------|
|      |       |      |

## config.h 要点

<!-- 键位、tags、layout、colors、status bar 等 -->

## 在 Xephyr 中运行

<!-- 替换 twm 后的 xinitrc、启动方式 -->

## 已知问题

## 相关

- [index.md](index.md)
- [st.md](st.md)
- [dmenu.md](dmenu.md)
- [xephyr.md](xephyr.md)
