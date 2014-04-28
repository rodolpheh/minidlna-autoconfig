#!/bin/bash
# This file is part of minidlna-autoconfig.
#
# SHARE YOUR PROFITS LICENSE (Revision 1):
# <houdas.rodolphe@gmail.com> and <pailleux.pierre@gmail.com> wrote this file.
# You are free to use this software, look into its code, modify it to fit your
# own needs and redistribute it. In order to commercialise it, you must give 50%
# of the profits to charities. The charities choice will be made by voters on
# Internet and the charities will receive the benefits proportionally to their
# votes quantity. If you're willing to do so, please contact us.
# Rodolphe HOUDAS and Pierre PAILLEUX.
#
# You should have received a copy of the Share Your Profits License along with
# minidlna-autoconfig. If not, see above.
#
# =======================================
#
# Generate a default Minidlna config file for the current user.
# The config file is written to standard out.

if [[ $0 == '/bin/bash' ]]; then
    echo "It looks like you're sourcing this script."
    echo "Please execute it directly instead, lest it clutter your shell with variables and then fail."
    return 1
fi

##############################
# READ INPUT
##############################
for arg in $@; do
    case $previous in
        --name)
            devicename=$arg;;
        --port)
            port=$arg;;
        --db-dir)
            dbdir=$arg;;
        --log-dir)
            logdir=$arg;;
        --music-dir)
	    mdir=$arg;;
	--pictures-dir)
	    pdir=$arg;;
	--videos-dir)
	    vdir=$arg;;
    esac
    case $arg in
        -h|--help)
            cat<<EOF
Usage: source minidlna-makeconfig.sh [-h|--help] | [OPTION OPTION_VALUE] ...
    -h
        Print the short version of this message and exit.
    --help
        Print the long version of this message and exit.
    (If both -h and --help appear, the first takes precedence.)

Common options:
    --name=
        Name to display to controllers
        
    --music-dir=
	Directory containing music
	
    --pictures-dir=
	Directory containing pictures
	
    --videos-dir=
	Directory containing videos

EOF
            # Set exit status to nonzero
            /bin/false
            ;;&
        --help)
            cat<<EOF
OPTIONS
  These options are accepted, with defaults in parentheses. If an option
  appears more than once, the last occurrence overwrites all previous
  ones.

    --name= (\$USER@\$HOSTNAME)
        The name of this device to show in other connected controllers.

    --port= (8200)
        The port on which to listen for minidlna connections.

    --db-dir= (~/.config/minidlna/cache)
        The directory to store database and metadata.

    --log-dir= (~/.config/minidlna/logs)
        The directory to store logs
        
    --music-dir=
	Directory containing music. This directory will be scanned.
	
    --pictures-dir=
	Directory containing pictures. This directory will be scanned.
	
    --videos-dir=
	Directory containing videos. This directory will be scanned.
        
EOF
            # Set exit status to nonzero
            /bin/false
            ;;
    esac || exit 0 # Exit if any of the case blocks were executed
    previous=$arg
done

##############################
# DEFAULTS
##############################
devicename=${devicename:-$USER@$HOSTNAME}
port=${port:-8200}
dbdir=${dbdir:-$HOME/.config/minidlna/cache}
logdir=${logdir:-$HOME/.config/minidlna/logs}
mdir=${mdir:-$HOME/Music}
pdir=${pdir:-$HOME/Pictures}
vdir=${vdir:-$HOME/Videos}

##############################
# REPLACEMENT
##############################
# String parameter values in the LHS are surrounded with "s and searched for as such
# Non-string parameter values in the LHS are not quoted - use , as delimiter
cat /etc/minidlna.conf \
    | sed 's&#friendly_name=.*&friendly_name='$devicename'&' \
    | sed 's&port=.*&port='$port'&' \
    | sed 's&#db_dir=.*&db_dir='$dbdir'&' \
    | sed 's&#log_dir=.*&log_dir='$logdir'&' \
    | sed 's&media_dir=/.*&media_dir=A,'$mdir'\nmedia_dir=P,'$pdir'\nmedia_dir=V,'$vdir'&' 
