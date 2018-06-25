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
    echo "${scriptname}: Usage: ${scriptname} <dirtostrip>"
}

dirtostripdir=`dirname "$1"`
curdir=`pwd`
cd $dirtostripdir

for tostripfile in `find . \( -type f -print \) -o \( ! -name . -type d -prune \)`
do
    echo "    => Processing file '$tostripfile' ..."
    extract-debug-infos.sh $tostripfile
done
