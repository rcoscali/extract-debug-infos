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
  echo "${scriptname}: Usage: ${scriptname} <package-root>"
}

if test -z "$1"
then
    packagedir=`pwd`
    extract-debug-infos-from-dir.sh .
else
    packagedir="$1"
    curdir=`pwd`
    cd $packagedir
    extract-debug-infos-from-dir.sh .
fi

for f in `find . -name .debug -type d -prune -o -type f -print`
do
    tostripfiledir=`dirname $f`
    tostripfilename=`basename $f`
    echo "=> Processing file '$tostripfilename' in directory '$tostripfiledir' ..."
    (cd $tostripfiledir && extract-debug-infos.sh $tostripfilename)
done
if ! test -z "$1"
then
    cd $curdir
fi
