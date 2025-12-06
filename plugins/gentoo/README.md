# Gentoo Plugin

Provides aliases and functions to assist day-to-day Gentoo maintenance.


## Configuration

All configuration is done in the `:omz:plugin:gentoo` namespace using the command:

```
zstyle :omz:plugin:gentoo <knob>
```

### `browser`

Sets the browser to invoke for the `emlog` command. If not set, will try to
detect automatically in the following order: `elinks`, `links`, `lynx`, `w3m`

Default: Not Set


### `subexecutor` 

Explicitly specifies the subexecutor to be used. If not set, then the plugin will
try to detect automatically, prioritizing `doas` over `sudo`

Default: Not Set

> **Note:** This configuration knob will be removed when a way to globally specify a custom subexecutor has been implemented.
>
> I did try submitting [PR#12261](https://github.com/ohmyzsh/ohmyzsh/pull/12261) but the PR had been closed.


## Aliases / Functions / Commands

In general:

* Commands without `!` suffix means it can run as low-privilege user.  
  This usually means the `--pretend|-p` option will be passed through to the command.

* Commands with `!` suffix means it will invoke the subexecutor.  
  This usually also means `--pretend|-p` will be removed.

* Some commands have two variants: with `!`, and without.

In the following table, commands without `!` mean they have two variants, unless noted.
Commands with `!` have only one variant


| Command      | Purpose / Is similar to                                 | Notes |
|:-------------|---------------------------------------------------------|:-----:|
| `edconf!`    | `dispatch-conf`                                         |       |
| `ekrnl`      | (See below)                                             |       |
| `ekrnlc`     | (See below)                                             |  [1]  |
| `ekrnlmk!`   | (See below)                                             |       |
| `emch`       | `emerge -pvDt --changed-use [OPTIONS] @world`           |  [2]  |
| `emcln`      | `emerge -p --depclean`                                  |       |
| `emlog`      | Invokes a TUI browser to see a package's commit log     |  [1]  |
| `emmodreb!`  | `emerge -1vD --with-bdeps=y [OPTIONS] @module-rebuild`  |  [2]  |
| `empresreb!` | `emerge -1vD [OPTIONS] @preserved-rebuild`              |  [2]  |
| `emres!`     | `emerge --resume`                                       |       |
| `emsync!`    | `emaint sync`                                           |       |
| `emup`       | `emerge -pvuDt`                                         |       |
| `emupw`      | `emup [OPTIONS] @world`                                 |  [2]  |
| `enewsr!`    | `eselect news read`                                     |       |
| `equu`       | `equery uses`                                           |  [1]  |



**Notes:**

**[1]** These commands have only one variant.  
**[2]** Unlike other commands that append your arguments to the end, these commands INSERT your arguments within, at the position marked with the `[OPTIONS]` notation.


### The `ekrnl` command:

* WithOUT `!`, it will execute `eselect kernel list`, a non-privileged command
* WITH `!` it depends on the argument
  * WithOUT additional argument: Same as `ekrnl`
  * WITH an argument (must be a number): Execute `eselect kernel set` via subexecutor


### The `ekrnlc` command:

This command will run `make menuconfig` _as the currently logged in user_ (NOT as a privileged user)
for the currently selected kernel, after checking for the following pre-requisites:

* The `/usr/src/linux` directory is RW for the current user
* The `.config` file exists in the above directory

If the above pre-requisites are not met, it will ask for confirmation and suggest possible fixes.


### The `ekrnlmk!` command:

Performs the compile + install process for the selected kernel, INCLUDING compilation of kernel modules, if any.

It supports several options/switches, which you can read by running `ekrnlmk! --help`.
The most helpful one is probably `--no-clean` which skips the `make clean` stage,
helpful if you only do minor config changes to currently-selected kernel, as it reuses
previously-compiled code, and only compile what needs to change.


## Common Usage Flow

### Updating packages and kernel

```sh
# First we sync the repo -- please do this only ONCE PER DAY, or you might get blocked!
emsync!

# Oh, a Gentoo News! Let's read it
enewsr!

# Let's review what's changed
emupw

# We see new USE flags. After editing our USE flags in /etc/portage/package.use as necessary, let's (re)compile them
# But review first:
emch

# Now we execute the changes
emch!

# Oh, some config changed
edconf!

# That done, let's review again what Portage suggests:
emupw

# Everything's good, let's update the world!
emupw!

# Config changes again
edconf!

# Cleanup obsoleted packages, but review first
emcln
emcln!

# If the cleanup bollixed some libs, rebuild them:
empresreb!

# Apparently we have a new kernel. Let's see and select it:
ekrnl
ekrnl! 4  # Assuming it's kernel number 4 in the list

# Preparation for configuring the new kernel
chown -vR my_user:my_group /usr/src/linux /usr/src/linux/*
zcat /proc/config.gz > /usr/src/linux/.config

# Let's configure the kernel
ekrnlc

# Now let's make and install the kernel
ekrnlmk!
```
