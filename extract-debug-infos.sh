#!/bin/bash

scriptdir=`dirname ${0}`
scriptdir=`(cd ${scriptdir}; pwd)`
scriptname=`basename ${0}`

set -e

function errorexit()
{
    errorcode=${1}
    shift
    echo $@
    exit ${errorcode}
}

function usage()
{
    echo "${scriptname}: Usage: ${scriptname} <tostrip>"
}

function getBuildID()
{
    file $1 | tr ',' "\n" | grep BuildID | while read string; do eval `echo $string | sed -e 's/\[sha1\]//'`; echo $BuildID; done
}

tostripdir=`dirname "$1"`
tostripfile=`basename "$1"`


if test -z "${tostripfile}"
then
  usage
  errorexit 0 "tostrip must be specified"
fi

cd "${tostripdir}"

debugdir=.debug
debugfile="${tostripfile}.debug"

if test `file $tostripfile | egrep 'ELF (32|64)-bit LSB' | grep 'with debug_info, not stripped' | wc -l` -eq 1
then 
    if test ! -d "${debugdir}"
    then
        mkdir -p "${debugdir}"
    fi
    echo -n "stripping ${tostripfile}, putting debug info into ${debugfile} ... "
    # Copy debug infos from exe to debug file
    objcopy --only-keep-debug "${tostripfile}" "${debugdir}/${debugfile}"
    # strip debug infos from exe
    strip --strip-debug --strip-unneeded "${tostripfile}"
    # link debug info in .debug to the exe for gdb to able to find debug info
    objcopy --add-gnu-debuglink="${debugdir}/${debugfile}" "${tostripfile}"
    chmod -x "${debugdir}/${debugfile}"
    echo "done!"
else
    if test `file $tostripfile | egrep 'ELF (32|64)-bit LSB' | grep 'stripped' | grep 'BuildID' | wc -l` -eq 1
    then
        BuildID=`getBuildID $tostripfile`
        if test -f $debugdir/$debugfile
        then
            DebugBuildID=`getBuildID $debugdir/$debugfile`
	    if test $BuildID = $DebugBuildID
	    then
	        echo "Skipping $tostripfile: already processed ..."
	    else
	        echo "*** WARNING! Skipping $tostripfile: already stripped but BuildID doesn't match!"
	    fi
        else
	    echo "*** WARNING! Skipping $tostripfile: already stripped but debug file missing"
        fi
    else
        echo "*** WARNING! Skipping $tostripfile: not the kind of file type I can handle ..."
    fi
fi
