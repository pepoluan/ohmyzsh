# Gentoo Plugin

Provides aliases and functions to assist day-to-day Gentoo maintenance.


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

| Command     | Purpose                         |
|:-----------:|---------------------------------|
| `ekrnl`     | eselect kernel list             |
| `ekrnl set` | eselect kernel set              |
| `ekrnl!`    | alias of `ekrnl set`            |
| `ekrnlc`    | `make menuconfig` in kernel dir |
| `empresreb` | emerge `@preserved-rebuild`     |
| `emres`     | emerge resume                   |
| `emsync`    | emaint sync                     |
| `enewsr`    | eselect news read               |
| `equu`      | equery use                      |

