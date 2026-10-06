# surf

[suckless surf](https://surf.suckless.org/) — WebKitGTK 浏览器。本仓跟踪上游分支 `surf-webkit2`。

源码目录：[../surf](../surf)

## 依赖

`pkg-config` 需能找到 `gtk+-3.0`、`gcr-3`、`webkit2gtk-4.1`（见 `config.mk`）。

Arch：

```bash
sudo pacman -S base-devel gtk3 gcr webkit2gtk-4.1 pkgconf
```

Alpine：

```bash
doas apk add build-base gtk+3.0-dev gcr-dev webkit2gtk-4.1-dev pkgconf
```

## 构建

```bash
cd surf
rm -f config.h
make PREFIX=$HOME/.local install
```

Web 扩展装到 `$PREFIX/lib/surf`。

## 常用

```bash
tabbed -c surf -e https://example.com
surf-open.sh https://example.com
```

## 相关

- [index.md](index.md)
- [tabbed.md](tabbed.md)
