# Gentoo Plugin

Provides aliases and functions to assist day-to-day Gentoo maintenance.


## Configuration

All configuration is done in the `:omz:plugin:gentoo` namespace using the command:

```
zstype :omz:plugin:gentoo <knob>
```

### `browser`

Sets the browser to invoke for the `emlog` command. If not set, will try to
detect automatically in the following order: `elinks`, `links`, `lynx`, `w3m`

Default: Not Set


### `subexecutor` 

Explicitly specifies the subexecutor to be used. If not set, then the plugin will
try to detect automatically, prioritizing `doas` over `sudo`

Default: Not Set

> **Note:** This configuration knob will be removed when
> [PR#12261](https://github.com/ohmyzsh/ohmyzsh/pull/12261)
> have been merged.


## Aliases / Functions / Commands

The following commands in the table below has three variants:

* **Command** (on its own) : Execute command with `-p`/`--pretend` flag
* **Command `do`** : Execute command -- will invoke subexecutor
* **Command!**: An alias to `command do`

| Command     | Purpose                     | Notes |
|:-----------:|-----------------------------|:-----:|
| `emch`      | emerge changed-use `@world` |       |
| `emcln`     | emerge depclean             |       |
| `emup`      | emerge update               |       |
| `emupw`     | emerge update `@world`      |       |


The following commands in the table below has no variants, they execute immediately:

| Command     | Purpose                                             | Notes |
|:-----------:|-----------------------------------------------------|:-----:|
| `ekrnl`     | eselect kernel list/set                             |  [2]  |
| `ekrnlc`    | `make menuconfig` in kernel dir                     |  [1]  |
| `ekrnlmk`   | Build (and install) kernel dir                      |  [1]  |
| `emlog`     | Invokes a TUI browser to see a package's commit log |       |
| `emmodreb`  | emerge `@module-rebuild`                            |  [1]  |
| `empresreb` | emerge `@preserved-rebuild`                         |  [1]  |
| `emres`     | emerge resume                                       |  [1]  |
| `emsync`    | emaint sync                                         |  [1]  |
| `enewsr`    | eselect news read                                   |       |
| `equu`      | equery use                                          |       |

**Notes:**

**[1]** Automatically invokes subexecutor  
**[2]** Without args, invokes 'list' command. With args, invokes 'set' command (automatically invokes subexecutor)  

