#!/usr/bin/env bash

function help() {

    echo -e "
Usage: ${BLUE}$0${NC}
mysnippet [${YELLOW}OPTIONS${NC}]
    ${GREEN}cs  ${NC} | (--${MAGENTA}create_snipeet${NC})    : create a new capsules
    ${GREEN}ls  ${NC} | (--${MAGENTA}list_snippet${NC})      : list all saved capsules
    ${GREEN}[vV]${NC} | (--${MAGENTA}version${NC})           : current CLI version
    ${GREEN}[hH]${NC} | (--${MAGENTA}help${NC})              : show this help

${YELLOW}OPTIONS${NC}:
--------
	(-${RED}cc${NC})   | (${YELLOW}--create_capsule${NC})    : create a new capsules
	(-${RED}l${NC})    | (${YELLOW}--list_capsules${NC})     : list all saved capsules
	(-${RED}rc${NC})   | (${YELLOW}--restore_capsule${NC})   : restore a capsule
	(-${RED}[${BLUE}vV${RED}]${NC}) | (${YELLOW}--version${NC})           : current CLI version
	(-${RED}[${BLUE}hH${RED}]${NC}) | (${YELLOW}--help${NC})              : show this help

${YELLOW}DEPENDENCIES${NC}:
-------------
	- ${BLUE}gdu${NC}       : ${RED}brew${NC} install ${BLUE}gdu${NC}
	- ${BLUE}pv${NC}        : ${RED}brew${NC} install ${BLUE}pv${NC}
	- ${BLUE}zip${NC}       : ${RED}brew${NC} install ${BLUE}zip${NC}

${YELLOW}NOTES${NC}:
------
	${YELLOW}MacOSX${NC}: ${RED}\$HOME${NC} is ${BLUE}\$home${NC} for ${YELLOW}GNU Linux${NC}
	Old Usage: ${RED}nvimTime${NC} [${YELLOW}OPTION${NC}] [${BLUE}FILE${NC}] [${MAGENTA}ARGUMENT${NC}] ...
	"
    exit 0

}

TITLE="Compile and watch on system: $HOSTNAME"
RIGHT_NOW="$(date +"%x %r %Z")"
CREAT_TIME_STAMP="Updated on $RIGHT_NOW by $USER"
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
TIME_STAMP=$(date +%Y-%m-%d-%H%M%S)

function currentTime() {
    TIME_STAMP=$(date +%Y-%m-%d-%H%M%S)
    echo -ne "${RED}$(date +%Y-%m-%d-%H%M%S)${NC}\n"
    #echo "$(date +"%x %r %Z")"
}

SYSTEM_TYPE=""
function whichSystem() {
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        echo -ne "[${BLUE}\uf179${NC} ] Running on ${YELLOW}macOSX${NC}\n"
        #currentTime
        SYSTEM_TYPE='macOSX'
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under GNU/Linux platform
        SYSTEM_TYPE='Linux'
        echo -ne "[${BLUE}\uf306${NC}] Running on LinuX"
    fi
}
echo -ne "$RED$SYSTEM_TYPE$NC"

# ****************************************************************************
# ****************************************************************************

function mac_install_prerequisites() {
    echo -e "[${YELLOW}\uf046${NC} ] ${MAGENTA}Installing prerequisites ...${NC}"
    if [[ -d "$HOME/.mysnippets" ]]; then
        echo -e "[${GREEN}\ue5fe${NC} ] ${BLUE}$HOME/.mysnippets${NC} already exists."
        SNIPPET_DIR="$HOME/.mysnippets/"
    else
        mkdir -p $HOME/.mysnippets
        echo -e "[${GREEN}\uf413${NC} ] ${GREEN}$HOME/.mysnippets${NC} is created."
        SNIPPET_DIR="./"
    fi
}
# ****************************************************************************
##           Global variables
# ****************************************************************************
DEFAULTEDITOR="$HOME/dev/nvim/bin/nvim"
TAGS_ARRAY=("$@")
FINAL_TAG_ARRAY=()
TAG_ARRAY_FILE_NAME=()
whichSystem

# ****************************************************************************
##           Assistant scripts
# ****************************************************************************
function markdDownTempate() {
    local selected_language=$(echo $1 | awk -F '_' '{print $2}')
    local all_tags=$(echo $2)
    cat <<EoF
# Title: $selected_language - Snippet
# ---
### Tags: $all_tags

### Content

\`\`\`$selected_language

\`\`\`
### Link:
### Note:
EoF
}

# ****************************************************************************
# ****************************************************************************
k
# ****************************************************************************
# ****************************************************************************
function fileName_with_tags() {
    local answer=$(echo $1)
    local all_tags=$(echo $2)
    # List must be sperated with space items
    local languages_list=('python' 'cpp' 'bash' 'shell' 'zsh' 'PHP' 'TypeScript' 'Scala' 'Shell' 'PowerShell' 'Perl' 'Haskell' 'Kotlin' 'SQL' 'MATLAB' 'Groovy' 'Lua' 'Rust' 'Ruby' 'HTML and CSS' 'Python' 'Java' 'JavaScript' 'Swift' 'C++' 'C#' 'R' 'Golang (Go)' 'vim')
    for lang in "${languages_list[@]}"; do
        if [[ "$lang" == "$answer" ]]; then
            echo -e "The language$RED $answer$NC Is already existed.."
            echo -e "Will create a template now ..."
            # Create a file name with no ASCII characters
            local FILEUNIQUENAME=$(echo "snippet_$(currentTime)_$answer" | sed -r 's/'$(echo -e "\033")'\[[0-9]{1,2}(;([0-9]{1,2})?)?[mK]//g')
            echo $all_tags
            FILEUNIQUENAME="$FILEUNIQUENAME$TAG_ARRAY_FILE_NAME.md"
            touch "$SNIPPET_DIR$FILEUNIQUENAME"
            echo "$SNIPPET_DIR$FILEUNIQUENAME"
            # Will create the snippet file
            markdDownTempate "_$answer" $FINAL_TAG_ARRAY >$SNIPPET_DIR$FILEUNIQUENAME
            # Will open the file for editing
            $DEFAULTEDITOR $SNIPPET_DIR$FILEUNIQUENAME
            #Preseting the file in markdown viewer
            glow $SNIPPET_DIR$FILEUNIQUENAME

        fi
    done

}

# ****************************************************************************
#                      Main Function
# ****************************************************************************

if [[ $SYSTEM_TYPE == 'macOSX' ]]; then
    currentTime
    mac_install_prerequisites
    while [[ "$1" != "" ]]; do
        case $1 in
        -cs | --create_snippet)
            if [[ "$2" != "" ]]; then
                Plang=$2
                echo $Plang
            else
                read -p "Do you want to create a snippet? for which langauge ... ? " PLang
            fi

            if [ "$#" -eq 0 ]; then
                echo " No tags were provided"
            else
                for arg in "${TAGS_ARRAY[@]:2}"; do
                    FINAL_TAG_ARRAY+=$arg"::"
                    TAG_ARRAY_FILE_NAME+="_"$arg
                done
            fi
            fileName_with_tags $Plang $TAG_ARRAY_FILE_NAME
            exit 1

            ;;
        -ls | --list_snippets | --list_snippet | --snippets | --search)
            # Here you must provide keywords or simply search them all
            # Searching all snippet will be implemented today
            if [[ "$2" != "" ]]; then
                rga --files-with-matches $2 | fzf --sort --preview-window down:80%:wrap --preview 'glow --style=dark {}'
            else
                # Using the tags that you will assigne to the file name
                # https://fossies.org/linux/fzf/ADVANCED.md
                if [[ -d "$HOME/.mysnippets/" ]];then
                cd $HOME/.mysnippets/ &&
                fzf  --info=inline --border --margin=1 --padding=1 --sort --preview-window down:80%:wrap --preview 'glow --style=dark {}'
                # for selection specific --query .md
                fi
            fi
            exit 1

            ;;
        -[hH] | --help)
            #checking_font
            help
            exit 1
            ;;
        -[vV] | --version)
            version
            exit 1
            ;;
        *)
            echo "Unknow flag or arg ... "
            read -p "$(echo -e "See help: Continue? (${YELLOW}Y${NC}/${YELLOW}N${NC}): ")" confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                help
                exit 1
            else
                exit 1
            fi
            ;;

        esac
    done

fi
