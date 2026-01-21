#!/bin/bash
# Show help if no args or --help used
# color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m'
#
#
#
extract_parameter () {
    # check if it file or not      
    file=$1
    cat "$file" | grep "?"

}




if [[ $# -eq 0 || "$1" == "--help" ]]; then
  echo -e "${YELLOW}  Usage: ./gex.sh urls [--module] <target> ${RESET}"
    
  echo -e "${MAGENTA}  [options]${RESET}"
  echo "    --path    Find importent path [api]" 
  echo "    --param   xtract URLs with parameters"

  echo -e "${MAGENTA}  [target]${RESET}"
  echo -e "    -f   <file>       Search specific file"
  echo -e "    -d   <directory>  Search directory recursively"  
  echo -e "    -d .              Current directory"

  exit 0
fi


case "$1" in
    --param)
        shift
        case "$1" in
            -f)
                if [ ! -f "$2" ]; then
                    echo "Error: there is no file"
                    exit 1
                fi
                FILE_PATH="$2"
                # /////////////////////////////////// 
                extract_parameter "$FILE_PATH"
                # /////////////////////////////////// 
                shift 2 
                ;;
            -d)
                if [ ! -d "$2" ]; then
                    echo "Error: there is not directory"
                    exit 1
                fi
                DIRECTORY_PATH="$2"
                # /////////////////////////////////// 
                if [[ "$DIRECTORY_PATH" == "." ]]; then
                    echo "Pass"
                fi

                echo "Pass"
                
                shift 2
                ;;
            
            -url)
                URL=$2
                if [[ $URL =~ ^https?://.*\.js$ ]]; then
                # /////////////////////////////////// 
                echo "Test" 
                # /////////////////////////////////// 
                else
                    echo "Wrong url form !"
                fi
                shift 2
                ;;
            *)
                echo "no target "
                exit 1 
                ;;
        esac
        ;;
esac







case "$1" in
    --secrets)
        echo "You are using [js] module"
        shift
        case "$1" in
            -f)
                if [ ! -f "$2" ]; then
                    echo "Error: there is no file"
                    exit 1
                fi
                FILE_PATH="$2"
                # /////////////////////////////////// 
                scanRegex_file "$FILE_PATH"
                # /////////////////////////////////// 
                shift 2 
                ;;
            -d)
                if [ ! -d "$2" ]; then
                    echo "Error: there is not directory"
                    exit 1
                fi
                DIRECTORY_PATH="$2"
                # /////////////////////////////////// 
                if [[ "$DIRECTORY_PATH" == "." ]]; then
                    scanRegex_dir "$(pwd)"

                fi
                scanRegex_dir "$DIRECTORY_PATH"                                
                
                # /////////////////////////////////// 
                shift 2
                ;;

             -o)
                current_path=$(pwd)
                echo "$current_path"
                shift 2
                ;;
            *)
                echo "no target "
                exit 1 
                ;;
        esac
        ;;
    --juicy)
        echo "You are using PARAM module"
        shift
        case "$1" in
            -f)
                if [ ! -f "$2" ]; then
                    echo "Error: there is no file"
                    exit 1
                fi
                FILE_PATH="$2"
                # /////////////////////////////////// 
                getQuery "$FILE_PATH"                
                # /////////////////////////////////// 
                shift 2 
                ;;
            -d)
                if [ ! -d "$2" ]; then
                    echo "Error: there is no directory"
                    exit 1
                fi
                DIRECTORY_PATH="$2"
                if [ "$DIRECTORY_PATH" ]]; then
                    echo "Hello"
                fi
                # do some shit over here
                shift 2

                ;;
            *)

                echo "no target "
                exit 1 
                ;;
        esac
        ;;
    --content)
        shift
        case "$1" in

            -u)
                URL=$2
                if [[ $URL == http://* ]] || [[ $URL == https://* ]]; then
                    getContent "$URL"
                else
                    echo "Invalid URL (missing http/https)"
                    exit 1
                fi
                shift 2
                ;;
                -f)
                if [ ! -f "$2" ]; then
                    echo "Error: there is no file"
                    exit 1
                fi
                FILE_PATH="$2"
                # /////////////////////////////////// 
                getQuery "$FILE_PATH"                
                # /////////////////////////////////// 
                shift 2 
                ;;
            -d)
                if [ ! -d "$2" ]; then
                    echo "Error: there is no directory"
                    exit 1
                fi
                DIRECTORY_PATH="$2"
                if [ "$DIRECTORY_PATH" ]]; then
                    echo "Hello"
                fi
                # do some shit over here
                shift 2
                ;;
            *)
                echo "no target "
                exit 1 
                ;;
        esac
        ;;
    *)
        echo "No Module with this name"
        exit 1
        ;;
esac


