# gentoo.plugin.zsh - Provides helper functions and aliases for Gentoo users

# --- Perform auto-detection of subexecutor ----------

# This part is taken from PR#12261; if that PR gets merged, we will delete this
#
# Differencess from PR#12261:
#   * Configurable via ':omz:plugins:gentoo' namespace instead of ':omz'
#   * Does not define the '_' alias
#   * The stand-in function is called gsubex() instead of subex()

# If in the future a new subexecuter is created, we only need to edit this array
typeset _KNOWN_SUBEXES=( "doas" "sudo" )
typeset _SUBEX

function _SetupSubexecutor() {
  local _i
  local _cmd
  zstyle -s ':omz:plugins:gentoo' 'subexecutor' _SUBEX
  if [[ "$_SUBEX" ]]; then
    if command -v "$_SUBEX" > /dev/null; then
      return 0
    fi
    print "Cannot find subexecutor '${_SUBEX}'; please check your configuration!" >&2
    return 1
  fi
  for _i in "${_KNOWN_SUBEXES[@]}"; do
    if command -v "$_i" > /dev/null; then
      _SUBEX="$_i"
      break
    fi
  done
  if [[ -z $_SUBEX ]]; then
    print "oh-my-zsh: cannot auto-detect subexecutor; please specify explicitly using 'zstyle :omz:plugins:gentoo subexecutor'." >&2
    return 1
  fi
  zstyle ':omz:plugins:gentoo' 'subexecutor' "$_SUBEX"
}

_SetupSubexecutor
unfunction _SetupSubexecutor
unset _KNOWN_SUBEXES
unset _SUBEX

function gsubex() {
  local _subex
  zstyle -s ':omz:plugins:gentoo' 'subexecutor' _subex
  ${_subex} "$@"
}

# --- Actual implementation of helper functions and aliases ----------

## Tri-variant commands

function emup() {
  local _do
  if [[ "${1:l}" == "do" ]]; then
    _do=1
    shift
  fi
  if [[ -z $1 ]]; then
    print "emup needs one or more packages to be specified." >&2
    return 1
  fi
  if [[ $_do ]]; then
    gsubex emerge -1v --update --deep "$@"
  else
    emerge -pv --update --deep --tree "$@"
  fi
}

alias 'emup!'="emup do"

function emupw() {
  local _do
  if [[ "${1:l}" == "do" ]]; then
    _do="do"
    shift
  fi
  emup $_do "$@" "@world"
}

alias 'emupw!'="emupw do"

function emch() {
  if [[ "${1:l}" == "do" ]]; then
    shift
    gsubex emerge -1v --changed-use --deep "$@" @world
  else
    emerge -pv --changed-use --deep --tree "$@" @world
  fi
}

alias 'emch!'="emch do"

function emcln() {
  local _do
  if [[ "${1:l}" == "do" ]]; then
    _do=1
    shift
  fi
  if [[ $_do ]]; then
    gsubex emerge --depclean "$@"
  else
    emerge -p --depclean "$@"
  fi
}

alias 'emcln!'="emcln do"

## Non Tri-variant commands

function emsync() {
  gsubex emaint sync
}

function emres() {
  gsubex emerge --resume
}

function equu() {
  equery u "$@"
}

function empresreb() {
  gsubex emerge -1v --deep "$@" @preserved-rebuild
}

function emmodreb() {
  gsubex emerge -1v --deep --with-bdeps=y "$@" @module-rebuild
}

function enewsr() {
  gsubex eselect news read
}

function ekrnl() {
  if [[ $1 ]]; then
    gsubex eselect kernel set $1
  else
    eselect kernel list
  fi
}

function ekrnlc() {
  local __c
  # First check that this is writable
  local __t="$(mktemp -q -p /usr/src/linux)"
  if [[ -z $__t ]]; then
    print -P "$B$F{yellow}/usr/src/linux is not writable!%f"
    print -P "You should do a $F{cyan}chown%f first to ensure successful config & compile"
    read -r -q "__c?Continue [yN] ? "
    print -P "%f%b"
    if [[ $__c != "y" ]]; then
      return 1
    fi
  else
    rm "$__t"
  fi
  cd /usr/src/linux
  if ! [[ -r .config ]]; then
    print -P "%B%F{yellow}.config is not found!%f"
    print -P "Possible options:"
    print -P "  %F{yellow}a%f = Abort, so you can handle things on your own"
    print -P "  %F{yellow}c%f = Continue, make menuconfig *should* create an empty, default .config file"
    print -P "  %F{yellow}o%f = Run %F{cyan}make oldconfig%f, which will copy your current kernel config and run the oldconfig procedure"
    read -r -k1 "__c?Choice [Aco] ? "
    print -P "${(L)__c}%f%b"
    case ${(L)__c} in
      o)
        make oldconfig
        ;;
      c)
        __c="c"
        ;;
      *)
        return 1
        ;;
    esac
  fi
  make menuconfig
}

function emlog() {
  local browser
  zstyle -s ":omz:plugins:gentoo" "browser" browser
  if [[ -z $browser ]]; then
    for browser in elinks links lynx w3m NOTFOUND; do
      if command -v $browser > /dev/null; then
        break
      fi
    done
  fi
  if [[ $browser == NOTFOUND ]]; then
    print "TUI browser not found!\nSet 'zstyle :omz:plugins:gentoo browser' to explicitly define one."
    return 1
  fi
  $browser "https://gitweb.gentoo.org/repo/gentoo.git/log/${1}?showmsg=1"
}

function edconf() {
  gsubex dispatch-conf
}


autoload -URz ekrnlmk

