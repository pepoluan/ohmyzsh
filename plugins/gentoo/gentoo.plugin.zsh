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
    gsubex emerge -pv --update --deep --tree "$@"
  fi
}

alias 'emup!'="emup do"

function emupw() {
  local _do
  if [[ "${1:l}" == "do" ]]; then
    _do="do"
  fi
  emup $_do @world
}

alias 'emupw!'="emupw do"

function emch() {
  if [[ -z $1 ]]; then
    emerge -pv --changed-use --deep --tree @world
  elif [[ $1 == "do" ]]; then
    gsubex emerge -1v --changed-use --deep @world
  fi
}

alias 'emch!'="emch do"

function emcln() {
  local _do
  if [[ $1 == "do" ]]; then
    _do=1
    shift
  fi
  if [[ $_do ]]; then
    gsubex emerge --depclean "$@"
  else
    gsubex emerge -p --depclean "$@"
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
  print -P "%F{bold}$(functions empresreb | egrep -v print)%f"
  gsubex emerge -1v --deep @preserved-rebuild
}

function emmodreb() {
  gsubex emerge -1v --deep --with-bdeps=y @module-rebuild
}

function enewsr() {
  gsubex eselect news read
}

function ekrnl() {
  if [[ $1 == "set" ]]; then
    gsubex eselect kernel set $2
  else
    eselect kernel list
  fi
}

alias 'ekrnl!'="ekrnl set"

function ekrnlc() {
  cd /usr/src/linux
  gsubex make menuconfig
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

autoload -URz ekrnlmk
