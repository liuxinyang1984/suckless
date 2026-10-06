# tabbed

[suckless tabbed](https://tools.suckless.org/tabbed/) — Xembed 标签容器，给 st / surf 合页。

源码目录：[../tabbed](../tabbed)

## 依赖

Arch：

```bash
sudo pacman -S base-devel libx11 libxft fontconfig freetype2
```

Alpine：

```bash
doas apk add build-base libx11-dev libxft-dev fontconfig-dev freetype-dev
```

## 构建

```bash
cd tabbed
rm -f config.h
make PREFIX=$HOME/.local install
```

## 常用

```bash
tabbed -c st -e
tabbed -c surf -e https://example.com
```

## 相关

- [index.md](index.md)
- [st.md](st.md)
- [surf.md](surf.md)
