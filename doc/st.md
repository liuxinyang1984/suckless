# st

[suckless st](https://st.suckless.org/) — 简单终端。

源码目录：[../st](../st)

## 版本

```
04ce0d6  fix async-unsafe error paths in sigchld()
```

```bash
cd st && git log -1 --oneline
```

## 依赖

Arch：

```bash
sudo pacman -S base-devel libx11 libxft libxext fontconfig freetype2
```

Alpine：

```bash
doas apk add build-base libx11-dev libxft-dev libxext-dev fontconfig-dev freetype-dev
```

## 构建

```bash
cd st
cp config.def.h config.h   # 首次；改 config.h 不碰 config.def.h
make clean
make
make PREFIX=$HOME/.local install
```

## Patches

<!-- 记录 patch 文件名、顺序、适用 commit、简要说明 -->

| 顺序 | Patch | 说明 |
|------|-------|------|
|      |       |      |

计划：`font2`（CJK 回退）、`scrollback`（滚动历史）。

## config.h 要点

<!-- 字体、颜色、快捷键等结论性配置，不贴全文 -->

## 中文环境

- 显示：UTF-8 + `font2` 回退 CJK 字体
- 输入：XIM + fcitx5（待在 Xephyr 内验证）

## 已知问题

<!-- 现象 → 原因 → 处理 -->

## 相关

- [index.md](index.md)
- [xephyr.md](xephyr.md)
