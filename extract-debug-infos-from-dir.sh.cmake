#!/bin/bash
set -e
function errorexit() {
    errorcode=$1; shift; if test $errorcode -lt 0; then echo $scriptname: error: $@; else echo $scriptname: warning: $@; fi; exit $errorcode
}
function usage() {
    echo "$scriptname: Usage: $scriptname <dirtostrip>"
}
extract_debug_infos_cmd="${BINDIR}/extract-debug-infos.sh"; scriptdir=`dirname $0`; scriptdir=`(cd $scriptdir; pwd)`; scriptname=`basename $0`; dirtostripdir=`dirname "$1"`; curdir=`pwd`; cd $dirtostripdir; for tostripfile in `find . \( -type f -print \) -o \( ! -name . -type d -prune \)`; do echo "    => Processing file '$tostripfile' ..."; $extract_debug_infos_cmd $tostripfile; done
