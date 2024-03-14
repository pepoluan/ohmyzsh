# Gentoo Plugin

Provides aliases and functions to assist day-to-day Gentoo maintenance, while
automatically detecting which program is used for subexecution (privilege
escalation).


## Aliases / Functions / Commands

The following commands in the table below has three variants:

* **Command on its own**: Execute command with `-p`/`--pretend` flag
* **Command + `"do"`**: Execute command
* **Command!**: An alias to `command do`

| Command     | Purpos                      | Notes |
|:-----------:|-----------------------------|:-----:|
| `emch`      | emerge changed-use `@world` |       |
| `emcln`     | emerge depclean             |       |
| `emup`      | emerge update               |       |
| `emupw`     | emerge update `@world`      |       |


The following commands in the table below has no variants, they execute immediately:

| Command     | Purpos                      |
|:-----------:|-----------------------------|
| `ekrnl`     | eselect kernel list         |
| `ekrnl set` | eselect kernel set          |
| `ekrnl!`    | alias of `ekrnl set`        |
| `empresreb` | emerge `@preserved-rebuild` |
| `emres`     | emerge resume               |
| `emsync`    | emaint sync                 |
| `enewsr`    | eselect news read           |
| `equu`      | equery use                  |

