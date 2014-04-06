#!/bin/bash
# This file is part of minidlna-autoconfig.
#
# minidlna-autoconfig is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# minidlna-autoconfig is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# minidlna-autoconfig.  If not, see <http://www.gnu.org/licenses/>.
#
# =======================================
#
# Author: Rodolphe Houdas <houdas.rodolphe@gmail.com>
#
# Author Note: This script, minidlna-makeconfig.sh and minidlna-autoconfig@.service is based
# on btsync-autoconfig by Emil Lundberg. All my thanks go to him and whoever worked
# on btsync-autoconfig.
#
# Checks if the named config file exists, and creates it if necessary.
#
# This script will create a default Minidlna configuration file
# at $configPath, if it does not already exist. $configPath is the value
# of the first positional parameter if it exists, and
# ~/.config/minidlna/minidlna.conf if it does not exist.
#
# The script /usr/share/minidlna-autoconfig/minidlna-makeconfig.sh will be used to
# create the config file. No arguments will be given to the minidlna-makeconfig.sh
# script.
#
# If creation of the config file fails, the script exits with nonzero
# exit status.
#
# Exit status codes:
#   0 The script was executed successfully.
#   1 The config file did not exist and the script failed to create its
#     parent directory
#   2 The config file did not exist, its parent directory did exist or
#     was successfully created, and the script failed to create the
#     file.
#   3 The storage_path setting in the config file is nonempty, the specified
#     directory does not exist and the script failed to create it.

logger "$0 starting"

configPath=~/.config/minidlna/minidlna.conf

# Parse arguments
if [[ $# > 0 ]]; then
    configPath=$1
    logger "Using config path $configPath given as positional parameter"
else
    logger "Using default config path $configPath"
fi

# Create config file if necessary
if [[ -f $configPath ]]; then
    logger "Config file $configPath already exists"
else
    logger "File $configPath does not exist - will create config file at this location"

    if mkdir -p $(dirname $configPath); then
        if /usr/bin/bash /usr/share/minidlna-autoconfig/minidlna-makeconfig.sh > $configPath; then
            logger "Config file successfully created at $configPath!"
        else
            logger "Could not create config at $configPath - exiting"
            exit 2
        fi
    else
        logger "Could not create directory $(dirname $configPath) - exiting"
        exit 1
    fi
fi

# Create cache directory if necessary
cachePath=$(grep -E 'db_dir\s*=' $configPath | cut -d = -f 2-)
if [[ -d "$cachePath" ]]; then
    logger "Cache directory ${cachePath} already exists"
elif [[ -n "$cachePath" ]]; then
    logger "Cache directory ${cachePath} does not exist - will create it"
    if mkdir -p "$cachePath"; then
        logger "Cache directory ${cachePath} created successfully"
    else
        logger "Failed to create cache directory ${cachePath}"
        exit 3
    fi
fi

# Create log directory if necessary
logPath=$(grep -E 'log_dir\s*=' $configPath | cut -d = -f 2-)
if [[ -d "$logPath" ]]; then
    logger "Log directory ${logPath} already exists"
elif [[ -n "$logPath" ]]; then
    logger "Log directory ${logPath} does not exist - will create it"
    if mkdir -p "$logPath"; then
        logger "Log directory ${logPath} created successfully"
    else
        logger "Failed to create log directory ${logPath}"
        exit 3
    fi
fi

# Create Music directory if necessary
MusicPath=$(grep -E 'media_dir\s*=A,' $configPath | cut -d , -f 2-)
if [[ -d "$MusicPath" ]]; then
    logger "Music directory ${MusicPath} already exists"
elif [[ -n "$MusicPath" ]]; then
    logger "Music directory ${MusicPath} does not exist - will create it"
    if mkdir -p "$MusicPath"; then
        logger "Music directory ${MusicPath} created successfully"
    else
        logger "Failed to create music directory ${MusicPath}"
        exit 3
    fi
fi

# Create Pictures directory if necessary
PicturesPath=$(grep -E 'media_dir\s*=P,' $configPath | cut -d , -f 2-)
if [[ -d "$PicturesPath" ]]; then
    logger "Pictures directory ${PicturesPath} already exists"
elif [[ -n "$PicturesPath" ]]; then
    logger "Pictures directory ${PicturesPath} does not exist - will create it"
    if mkdir -p "$PicturesPath"; then
        logger "Pictures directory ${PicturesPath} created successfully"
    else
        logger "Failed to create pictures directory ${PicturesPath}"
        exit 3
    fi
fi

# Create Videos directory if necessary
VideosPath=$(grep -E 'media_dir\s*=V,' $configPath | cut -d , -f 2-)
if [[ -d "$VideosPath" ]]; then
    logger "Videos directory ${VideosPath} already exists"
elif [[ -n "$logPath" ]]; then
    logger "Videos directory ${VideosPath} does not exist - will create it"
    if mkdir -p "$VideosPath"; then
        logger "Videos directory ${VideosPath} created successfully"
    else
        logger "Failed to create videos directory ${VideosPath}"
        exit 3
    fi
fi
