#!/bin/bash
# Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

bold=`tput bold`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

# Get the entry in the dpkg status file corresponding to the provied package name
# Prepend two newlines so it can be safely added to the end of any existing
# dpkg/status file.
get_dpkg_status() {
    echo -e "\n"
    awk '/Package: '"$1"'/,/^$/' /var/lib/dpkg/status
}

usage()
{
    if [ "$1" != "" ]; then
        echo "${red}$1${reset}" >&2
    fi
    
    local name=$(basename ${0})
    echo "$name [PROJECT_NAME] [[OPTIONS]]" >&2
    echo "OPTIONS:" >&2
    echo "  -v                       |  Verbose. Schow extra info " >&2
    echo "  -ci                      |  Build docker without cache " >&2
    echo "  --push                   |  Push docker. Need to be logged in " >&2
    echo "  --tag [TAG_NAME:=latest] |  Tag and push latest release" >&2
    echo "  --pull-base-image        |  Pull the base image " >&2
}

main()
{
    local PLATFORM="$(uname -m)"
    # Check if is running on NVIDIA Jetson platform
    if [[ $PLATFORM != "aarch64" ]]; then
        echo "${red}Run this script only on ${bold}${green}NVIDIA${reset}${red} Jetson platform${reset}"
        exit 33
    fi
    
    local PROJECT_NAME=""
    local TAG_NAME="latest"
    local PUSH=false
    local VERBOSE=false
    local CI_BUILD=false
    local PULL_IMAGE=false
    if [ -z $1 ] ; then
        usage "[ERROR] Missing [PROJECT_NAME]" >&2
        exit 1
    fi
    # Decode all information from startup
    while [ -n "$1" ]; do
        case "$1" in
            -h|--help) # Load help
                usage
                exit 0
            ;;
            -v)
                VERBOSE=true
            ;;
            -ci)
                CI_BUILD=true
            ;;
            --tag)
                TAG_NAME=$1
                shift 1
            ;;
            --pull-base-image)
                PULL_IMAGE=true
            ;;
            --push)
                PUSH=true
            ;;
            *)
                if [[ ${1::1} == "-" ]] ; then
                    usage "[ERROR] Unknown option: $1" >&2
                    exit 1
                elif [ -z $PROJECT_NAME ] ; then
                    PROJECT_NAME=$1
                else
                    usage "[ERROR] Unknown option: $1" >&2
                    exit 1
                fi
            ;;
        esac
        shift 1
    done
    
    if ! $PUSH ; then
        # Extract Libraries info
        local DPKG_STATUS=$(get_dpkg_status cuda-cudart-10-2)$(get_dpkg_status libcufft-10-2)
        if $VERBOSE ; then
            echo "${yellow} Libraries ${reset}"
            echo "$DPKG_STATUS"
        fi
        
        local CI_OPTIONS=""
        if $CI_BUILD ; then
            # Set no-cache and pull before build
            # https://newbedev.com/what-s-the-purpose-of-docker-build-pull
            CI_OPTIONS="--no-cache"
        fi
        
        local PULL_OPTION=""
        if $PULL_IMAGE ; then
            PULL_OPTION="--pull"
        fi
        
        echo "- Build repo ${green}$PROJECT_NAME:$TAG_NAME${reset}"
        docker build $CI_OPTIONS $PULL_OPTION -t $PROJECT_NAME:$TAG_NAME --build-arg "DPKG_STATUS=$DPKG_STATUS" . || { echo "${red}docker build failure!${reset}"; exit 1; }
        
        if $CI_BUILD ; then
            echo "- ${bold}Prune${reset} old docker images"
            docker image prune -f
        fi
    else
        echo "- Push repo ${green}$PROJECT_NAME:$TAG_NAME${reset}"
        docker image push $PROJECT_NAME:$TAG_NAME
    fi
}

main $@
# EOF
