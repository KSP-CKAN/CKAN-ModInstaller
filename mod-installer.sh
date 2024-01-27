#!/bin/bash

if [[ -z $INPUT_OUTPUT_PATH ]]
then
    echo 'Input parameter "output path" is required to specify path of the game instance'
    exit 2
fi

if [[ -z $INPUT_MODS ]]
then
    echo 'Input parameter "mods" is required to specify identifiers of mods to install'
    exit 2
fi

GAME=${INPUT_GAME:-KSP}
MAIN_GAME_VERSION=${INPUT_GAME_VERSIONS%% *}
OTHER_GAME_VERSIONS=${INPUT_GAME_VERSIONS#* }

if [[ -z $MAIN_GAME_VERSION ]]
then
    case $GAME in

        KSP)
            MAIN_GAME_VERSION=$(jq -rM 'last(.builds[])' /ksp-builds.json)
        ;;

        KSP2)
            MAIN_GAME_VERSION=$(jq -rM last /ksp2-builds.json)
        ;;

        *)
            echo 'Input parameter "game" is invalid'
            exit 2
        ;;
    esac
fi

COMPAT_COMMAND=''
if [[ -n $OTHER_GAME_VERSIONS ]]
then
    COMPAT_COMMAND="compat add $OTHER_GAME_VERSIONS"
fi

FILTER_COMMAND=''
if [[ -n $INPUT_INSTALL_FILTERS ]]
then
    FILTER_COMMAND="filter add --global $INPUT_INSTALL_FILTERS"
fi

# Need quoting in case the path has spaces
ckan instance fake fake_inst "$INPUT_OUTPUT_PATH" $MAIN_GAME_VERSION --game $GAME --set-default

# Group the remaining commands into one to reduce startup/teardown overhead
ckan prompt --headless <<EOF
$COMPAT_COMMAND
$FILTER_COMMAND
update
install --no-recommends $INPUT_MODS
EOF
