# tmux Workspaces

This guide covers the optional tmux workspace orchestration layer in this repo.

The goal is simple:

- keep the public repo generic and shareable
- make tmux workspace startup repeatable
- let personal/default/private workspaces live outside the public repo
- keep the wrapper script as the stable user-facing interface

## Scope

This layer is optional.

- Base setup does **not** require it.
- `tmux` itself remains the foundation.
- The wrapper is a convenience for repeatable startup.
- Nothing in the shell startup files launches tmux workspaces automatically.

## Public interface

The public command is:

```bash
scripts/tmux-session.sh
```

Supported forms:

```bash
scripts/tmux-session.sh list
scripts/tmux-session.sh start <name>
scripts/tmux-session.sh start <name> <name>
scripts/tmux-session.sh <name>
scripts/tmux-session.sh
```

Behavior:

- `list` shows the available public templates and workspaces, plus private ones when the sibling overlay repo exists
- `start <name>` starts a session template or workspace by name
- running with plain names is shorthand for `start`
- running with **no names** uses defaults from the sibling private overlay repo, if configured

## Backend

The current backend target is **tmuxinator**.

The wrapper is intentionally the stable contract. If the backend changes later, the public usage should stay the same.

## Install

Install tmuxinator only if you want this feature:

```bash
bash scripts/setup.sh --install-tmuxinator
```

Platform notes:

- **macOS:** uses Homebrew
- **Ubuntu / WSL:** uses `apt`

On macOS, users who actively manage Ruby with `rbenv` or `rvm` should review the Homebrew/Ruby caveats before relying on that install path.

## Public repo layout

The public repo should contain only generic templates:

```text
tmux/
  sessions/
  workspaces/
scripts/
  tmux-session.sh
```

Suggested meaning:

- `tmux/sessions/` — one session template per file
- `tmux/workspaces/` — one or more session templates launched together
- `scripts/tmux-session.sh` — discovery, wrapper logic, and attach-or-create behavior

## Sibling private overlay repo

Private defaults and private workspace definitions should live in a sibling repo, for example:

```text
../dev-environment-private/
  tmux/
    defaults.yaml
    sessions/
    workspaces/
```

Use the private overlay for:

- personal startup defaults
- private project names
- local filesystem paths
- employer-specific workspaces
- any command that should not be committed to the public repo

Do **not** put those details in the public repo templates.

## Definition rules for public templates

Public templates should be:

- generic
- safe to publish
- readable
- useful as examples

Avoid checking in:

- private repo paths
- employer-specific hosts or commands
- secrets or tokens
- machine-specific assumptions

Prefer:

- repo-local examples
- generic names
- simple panes and windows that demonstrate the intended workflow

## Private defaults

The sibling private overlay repo can define which templates to start when you run the wrapper with no arguments.

Suggested shape:

```yaml
defaults:
  - template: dev-environment
    name: env
  - template: docs
    name: docs
attach: env
```

Meaning:

- `template` = which public or private template to start
- `name` = the tmux session name to show
- `attach` = which session to attach to after starting everything

## Fallbacks

If you do not want tmuxinator, the fallback options remain:

- `tmuxp` as the main alternative backend
- plain tmux scripting as the zero-dependency fallback

The wrapper design should keep those options open.

## Troubleshooting

### `tmux-session.sh` says tmuxinator is missing

Install the optional backend:

```bash
bash scripts/setup.sh --install-tmuxinator
```

### No defaults are found when running with no arguments

That means the sibling private overlay repo either does not exist or does not have a defaults file configured yet.

Use:

```bash
scripts/tmux-session.sh list
```

and start a public template explicitly until the private overlay is ready.

### A private template should override a public one

Use the same template name in the sibling private overlay repo. The wrapper should prefer the private version when both exist.
