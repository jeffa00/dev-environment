# .NET in this environment

This guide covers the **opt-in .NET workflow** in this repo: SDK install, Neovim C# support, and debugging.

The goal is not to turn the managed Neovim config into a heavyweight IDE. The .NET layer stays additive and lightweight:

- optional SDK install
- optional Neovim C# support
- optional debugging through `netcoredbg`

## What to enable

There are two separate setup flags:

```bash
bash scripts/setup.sh --install-dotnet
bash scripts/setup.sh --enable-dotnet-nvim
```

Use them together when you want the full repo-managed .NET workflow:

```bash
bash scripts/setup.sh --install-dotnet --enable-dotnet-nvim
```

Meaning:

- `--install-dotnet` installs the .NET 10 SDK
- `--enable-dotnet-nvim` enables the optional Neovim C# and debugging layer

If `dotnet` is already installed on the machine, you can enable the Neovim layer without reinstalling the SDK.

## Platform expectations

Current repo-managed install path:

- **macOS:** Homebrew `dotnet`
- **Ubuntu 24.04+ / WSL on Ubuntu 24.04+:** `apt install dotnet-sdk-10.0`
- **Ubuntu 22.04 / WSL on Ubuntu 22.04:** `ppa:dotnet/backports`, then `dotnet-sdk-10.0`

After setup, open a new shell and confirm:

```bash
dotnet --version
which dotnet
```

On WSL, `which dotnet` should resolve to the Linux install path, not a Windows path under `/mnt/c/...`.

## First Neovim setup for C#

The optional Neovim .NET layer expects two tools to be installed through Mason:

```text
:MasonInstall roslyn
:MasonInstall netcoredbg
```

Recommended first-run flow:

1. run the setup flags you want
2. open a new shell
3. start `nvim`
4. run the Mason install commands above
5. restart Neovim
6. open a `.cs` file inside the project you want to work on

The C# layer adds:

- Roslyn language-server support
- C# treesitter support
- `nvim-dap` configuration for `netcoredbg`

For general Neovim behavior in this repo, see [Neovim](./neovim.md).

## Everyday .NET CLI workflow

From a project directory:

```bash
dotnet restore
dotnet build
dotnet test
dotnet run
```

### Suggested rhythm with tmux

A practical layout in this environment is:

- **pane 1:** `nvim .`
- **pane 2:** `dotnet test` or `dotnet watch test`
- **pane 3:** `dotnet run` or `dotnet watch run`

That fits the repo’s existing tmux-first workflow well:

- edit in Neovim
- build/test/run in neighboring panes
- keep the project workspace persistent inside tmux

If you want the tmux side of that workflow documented in more detail, see [tmux](./tmux.md).

## C# editing in Neovim

With the optional .NET layer enabled and Roslyn installed, C# buffers get a small LSP-focused key set:

- `gd` — go to definition
- `gr` — list references
- `K` — hover
- `<leader>rn` — rename symbol
- `<leader>ca` — code action

The rest of the Neovim experience stays intentionally minimal. There is no repo-managed completion framework or heavyweight IDE UI layer.

## Debugging

This repo uses:

- `nvim-dap` as the Neovim DAP client
- `netcoredbg` as the .NET debug adapter

Install the adapter with:

```text
:MasonInstall netcoredbg
```

### Default debug actions

In C# buffers:

- `<leader>dc` — continue / launch
- `<leader>db` — toggle breakpoint
- `<leader>di` — step into
- `<leader>do` — step over
- `<leader>dO` — step out
- `<leader>dr` — open the debug REPL
- `<leader>dq` — terminate the session

### Launch flow

The default launch configuration prompts for the compiled `.dll` path.

A practical flow is:

1. build the project:

   ```bash
   dotnet build
   ```

2. open the main C# project in Neovim
3. set breakpoints with `<leader>db`
4. start the session with `<leader>dc`
5. enter the path to the built `.dll`, usually under `bin/Debug/...`

There is also an **Attach to process** configuration for attaching to an already-running .NET process.

## Troubleshooting

### `dotnet` is missing after setup

Open a new shell first, then check:

```bash
dotnet --version
which dotnet
```

If you only enabled `--enable-dotnet-nvim`, remember that it does **not** install the SDK by itself.

### WSL is picking up Windows `dotnet.exe`

Check:

```bash
which dotnet
```

You want the Linux path, typically `/usr/bin/dotnet`, not a Windows path under `/mnt/c/...`.

### Roslyn warning appears in Neovim

Install the language server through Mason:

```text
:MasonInstall roslyn
```

Then restart Neovim.

### `netcoredbg` warning appears in Neovim

Install the adapter through Mason:

```text
:MasonInstall netcoredbg
```

Then restart Neovim before trying to debug.

### Debug launch asks for a DLL path

That is expected. Build first, then point the prompt at the compiled output under your project’s `bin/Debug/...` directory.

### A C# buffer does not show LSP behavior

Check the basics:

- the Neovim .NET layer was enabled with `--enable-dotnet-nvim`
- `dotnet` is available on `PATH`
- Roslyn was installed through Mason
- you restarted Neovim after installing Roslyn

## Bottom line

In this environment, the .NET workflow is:

1. opt into the SDK
2. opt into the Neovim layer if you want editor support
3. install Roslyn and `netcoredbg` through Mason
4. use normal `dotnet` CLI commands in tmux panes
5. use the lightweight LSP and DAP keybindings in Neovim when you need them

That keeps the repo’s terminal-first workflow intact while still making C# and .NET practical day to day.
