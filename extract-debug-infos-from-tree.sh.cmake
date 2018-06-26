#!/bin/bash
set -e
function errorexit() {
  errorcode=$1; shift; if test $errorcode -lt 0; then echo $scriptname: error: $@; else echo $scriptname: warning: $@; fi; exit $errorcode
}
function usage() {
  echo "$scriptname: Usage: $scriptname <package-root>"
}
extract_debug_infos_from_dir_cmd="${BINDIR}/extract-debug-infos-from-dir.sh"; extract_debug_infos_cmd="${BINDIR}/extract-debug-infos.sh"; scriptdir=`dirname $0`; scriptdir=`(cd $scriptdir; pwd)`; scriptname=`basename $0`; if test -z "$1"; then packagedir=`pwd`; $extract_debug_infos_from_dir_cmd .; else packagedir="$1"; curdir=`pwd`; cd $packagedir; $extract_debug_infos_from_dir_cmd .; fi; for f in `find . -name .debug -type d -prune -o -type f -print`; do tostripfiledir=`dirname $f`; tostripfilename=`basename $f`; echo "=> Processing file '$tostripfilename' in directory '$tostripfiledir' ..."; (cd $tostripfiledir && $extract_debug_infos_cmd $tostripfilename); done; if ! test -z "$1"; then cd $curdir; fi
