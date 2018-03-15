#!/bin/bash
###变量
funcdir=~/shell/ansible
scriptdir=$funcdir/script
uph2dir=~/shell/upHttp2
remotedir=/tmp
###变量
source $funcdir/a-function
rpush $uph2dir root down $remotedir
#ansi root down $remotedir/upHttp2/install.sh
