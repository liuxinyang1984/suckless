# suckless

父仓库：文档 + 子模块。源码与补丁历史在 [dwm](https://github.com/liuxinyang1984/dwm)、[st](https://github.com/liuxinyang1984/st)、[dmenu](https://github.com/liuxinyang1984/dmenu)、[mini-polkit](https://github.com/liuxinyang1984/mini-polkit)。

安装和快捷键见 [README.md](../README.md)。

## 仓库结构

```
suckless/
├── README.md
├── doc/
├── dwm/          # submodule
├── dmenu/        # submodule
├── st/           # submodule
└── mini-polkit/  # submodule
```

## 文档

| 文档 | 内容 |
|------|------|
| [../README.md](../README.md) | 克隆、安装、mini-polkit、快捷键 |
| [xephyr.md](xephyr.md) | Xephyr 嵌套 X11 |
| [st.md](st.md) | st 构建与 patch |
| [dwm.md](dwm.md) | dwm 构建与 patch |
| [dmenu.md](dmenu.md) | dmenu 构建与 patch |

```bash
git clone --recursive git@github.com:liuxinyang1984/suckless.git
```

构建默认 `make PREFIX=$HOME/.local install`。

## 外部链接

- [suckless dwm](https://dwm.suckless.org/)
- [suckless dmenu](https://tools.suckless.org/dmenu/)
- [suckless st](https://st.suckless.org/)
