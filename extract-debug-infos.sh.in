#!/bin/bash
set -e
function errorexit() {
    errorcode=$1; shift; if test $errorcode -lt 0; then echo $scriptname: error: $@; exit $errorcode; else echo $scriptname: warning: $@; fi
}
function usage() {
    echo "$scriptname: Usage: $scriptname <tostrip>"
}
function getBuildID() {
    file $1 | tr ',' "\n" | grep BuildID | while read string; do eval `echo $string | sed -e 's/\[sha1\]//'`; echo $BuildID; done
}
objcopy_cmd="@OBJCOPY_CMD@"; strip_cmd="@STRIP_CMD@"; chmod_cmd="@CHMOD_CMD@"; scriptdir=`dirname $0`; scriptdir=`(cd $scriptdir; pwd)`; scriptname=`basename $0`; tostripdir=`dirname "$1"`; tostripfile=`basename "$1"`; if test -z "${tostripfile}"; then usage; errorexit -1 "tostrip must be specified"; fi; cd "${tostripdir}"; debugdir=.debug; debugfile="${tostripfile}.debug"; if test `file $tostripfile | egrep 'ELF (32|64)-bit LSB' | grep 'with debug_info, not stripped' | wc -l` -eq 1; then if test ! -d "${debugdir}"; then mkdir -p "${debugdir}"; fi; echo -n "stripping ${tostripfile}, putting debug info into ${debugfile} ... "; $objcopy_cmd --only-keep-debug "${tostripfile}" "${debugdir}/${debugfile}"; $strip_cmd --strip-debug --strip-unneeded "${tostripfile}"; $objcopy_cmd --add-gnu-debuglink="$debugdir/$debugfile" "$tostripfile"; $chmod_cmd -x "$debugdir/$debugfile"; echo "done!"; else if test `file $tostripfile | egrep 'ELF (32|64)-bit LSB' | grep 'stripped' | grep 'BuildID' | wc -l` -eq 1; then BuildID=`getBuildID $tostripfile`; if test -f $debugdir/$debugfile; then DebugBuildID=`getBuildID $debugdir/$debugfile`; if test $BuildID = $DebugBuildID; then errorexit 1 skipping $tostripfile: already processed; else errorexit -2 skipping $tostripfile: already stripped but BuildID doesn\'t match!; fi; else errorexit -3 skipping $tostripfile: already stripped but debug file missing; fi; else if test -e "$tostripfile"; then errorexit 4 skipping $tostripfile: not the kind of file type I can handle; else errorexit -5 skipping $tostripfile: this file does not exist; fi; fi; fi
