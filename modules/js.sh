#!/bin/bash
# Show help if no args or --help used
#
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
cd "$(dirname "$0")"
#
#
#

getQuery () {
    local file=$1
    cat "$file" | grep "?"

}



scanRegex_file() {
    local target_file="$1"
    local total_matches=0

    local API_REGEX="$(dirname "${BASH_SOURCE[0]}")/../regex/api_regex.json"

    echo "[*] Scanning file: $target_file"
    echo ""

    local keys
    keys=$(jq -r 'keys[]' "$API_REGEX")

    for key in $keys; do
        local regex
        regex=$(jq -r --arg k "$key" '.[$k]' "$API_REGEX")

        local matches
        matches=$(grep -oP "$regex" "$target_file" | sort -u)

        if [[ -n "$matches" ]]; then
            local count
            count=$(echo "$matches" | wc -l)

            echo "[+] Key: $key"
            echo "$matches"
            echo ""

            total_matches=$((total_matches + count))
        fi
    done

    echo "[*] Total matches found: $total_matches"
    echo "[*] Scan complete."
}







if [[ $# -eq 0 || "$1" == "--help" ]]; then
  echo -e "${YELLOW}  Usage: ./quevy regex [--module] <target> ${RESET}"
    

  echo -e "${MAGENTA}  [options]${RESET}"
  echo "        --secrets     check for existed regex in file" 
  echo "        --juicy       Can contain juicy information [md5, sha, other encryption types]"

  echo -e "${MAGENTA}  [target]${RESET}"
  echo -e "         -url <url>        JavaScript endpoint extract"
  echo -e "         -f   <file>       file contain Java script | List of Java script endpoints"
  echo -e "         -d   <directory>  Search directory recursively"  

  exit 0
fi






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
            
            -url)
                URL=$2
                if [[ $URL =~ ^https?://.*\.js$ ]]; then
                # /////////////////////////////////// 


                    python3 ../pylib/getContent.py -u $URL > tmp_file                   
                    scanRegex_file tmp_file
                    rm  tmp_file
                    


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
    *)
        echo "No Module with this name"
        exit 1
        ;;
esac












    









