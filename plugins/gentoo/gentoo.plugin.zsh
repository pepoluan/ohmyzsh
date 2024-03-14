
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
    subex emerge -1v --update --deep "$@"
  else
    subex emerge -pv --update --deep --tree "$@"
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
    subex emerge -pv --changed-use --deep --tree @world
  elif [[ $1 == "do" ]]; then
    subex emerge -1v --changed-use --deep @world
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
    subex emerge --depclean "$@"
  else
    subex emerge -p --depclean "$@"
  fi
}

alias 'emcln!'="emcln do"

function emsync() {
  subex emaint sync
}

function emres() {
  subex emerge --resume
}

function equu() {
  equery u "$@"
}

function empresreb() {
  print -P "%F{bold}$(functions empresreb | egrep -v print)%f"
  subex emerge -1v --deep @preserved-rebuild
}

function emmodreb() {
  subex emerge -1v --deep --with-bdeps=y @module-rebuild
}

function enewsr() {
  subex eselect news read
}

function ekrnl() {
  if [[ $1 == "set" ]]; then
    subex eselect kernel set $2
  else
    eselect kernel list
  fi
}

alias 'ekrnl!'="ekrnl set"

