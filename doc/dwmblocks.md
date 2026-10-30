# dwmblocks（async）

状态栏：[liuxinyang1984/dwmblocks-async](https://github.com/liuxinyang1984/dwmblocks-async)（上游 [UtkarshVerma/dwmblocks-async](https://github.com/UtkarshVerma/dwmblocks-async)）。子模块 `dwmblocks/`，二进制名仍为 `dwmblocks`。

脚本在独立仓 [shell_script](https://github.com/liuxinyang1984/shell_script)（子模块 `shell_script/`）：

| 脚本 | 作用 |
|------|------|
| `status/sb-fcitx` | 拼 / 五 / En |
| `status/sb-datetime` | `%A %m-%d %H:%M:%S` |

`config.h` 在 **dwmblocks fork** 内维护（`BLOCKS` 调用上述 `sb-*`）。

```bash
./install.sh dwmblocks          # 系统：二进制 + 脚本 → /usr/local
./install.sh --user dwmblocks   # → ~/.local
# 或只装脚本：
./shell_script/install.sh --user
```

启动（勿与 `slstatus` 叠跑）：

```sh
dwmblocks &
```

## 依赖

Arch：`libxcb`（`pkg-config xcb-atom`）。输入法块需要 `fcitx5-remote`。
