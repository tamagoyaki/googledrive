#!/bin/bash
#
#  Mount Googledrive on to specified directory using google-drive-ocamlfuse.
#
#  IMPORTANT
#
#    Set GOOGLE_DRIVE_OCAMLFUSE_OAUTHINFO variable in ~/.googledrivesh.conf
#    before using this script.
#
#    The info is so private so you have to secure it.
#
#  EXAMPLE
#
#    declare -A GOOGLE_DRIVE_OCAMLFUSE_OAUTHINFO=(
#        ["john"]="
#            "1234-lasdkfiw.apps.googleusercontent.com"
#            "GEIFEWOF-wleifEgg"
#            "~/googledrive/john"
#            "
#        ["jane"]="
#            "5678-seifenfe.apps.googleusercontent.com"
#            "GDLIEFED-welrjKKd"
#            "~/googledrive/hane"
#            "
#   )

#
#
HELP="USAGE : $0 mount|umount user"
ACTION=$1
USER=$2

# check if dictionary variable is set
. ~/.googledrivesh.conf
declare -p GOOGLE_DRIVE_OCAMLFUSE_OAUTHINFO > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    echo "set GOOGLE_DRIVE_OCAMLFUSE_OAUTHINFO first."
    exit
fi

# check arguments
if [ "$ACTION" != "mount" ] && [ "$ACTION" != "umount" ] \
       || [ "$USER" == "" ] ; then
   echo $HELP
   exit
fi


# looking up specified user
for key in "${!GOOGLE_DRIVE_OCAMLFUSE_OAUTHINFO[@]}"; do
    #echo "${key}"

    # found it in dictionary ?
    if [ "$USER" != "${key}" ]; then
	continue
    fi
    
    arr=(`echo ${GOOGLE_DRIVE_OCAMLFUSE_OAUTHINFO[${key}]}`)
    cid=${arr[0]}
    sid=${arr[1]}
    mnt=${arr[2]}

    if [ "$ACTION" == "mount" ]; then
	mkdir -p ${mnt}
	google-drive-ocamlfuse -headless -id ${cid} -secret ${sid} -label $USER ${mnt}
    else
	fusermount -u ${mnt}
    fi

    exit
done


echo "I don't know who $USER is."
