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
ORIG_DIR="$(pwd)"
#
#
#

getQuery () {
    local file=$1
    cat "$file" | grep "?"

}

getQuery_dir() {
    local target_dir="$1"
    echo "[*] Scanning directory for juicy information: $target_dir"
    find "$target_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
        getQuery "$file"
    done
}

getContent () {
    local url=$1
    local output_file=$2
    if [ -n "$output_file" ]; then
        curl -s "$url" | tee -a "$output_file"
    else
        curl -s "$url"
    fi
}

process_js_file () {
    local file="$1"
    local output_file=$2
    if [[ "$file" != /* ]];then
        file="$ORIG_DIR/$file"
    fi

    file="${file//$'\r'/}"

    if [[ ! -f "$file" ]]; then
        echo "file not found :$file"
        exit 1
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue
        if [[ "$line" =~ ^https?://.+\.js$ ]]; then
            if [ -n "$output_file" ]; then
                curl -s "$line" | tee -a "$output_file"
            else
                curl -s "$line"
            fi
        else
            if [ -n "$output_file" ]; then
                echo "Invalid JS URL :$line" | tee -a "$output_file"
            else
                echo "Invalid JS URL :$line"
            fi
        fi
    done < "$file"
}


getJuicyinfo (){

    local fileToExtract=$1
}









if [[ $# -eq 0 || "$1" == "--help" ]]; then
  echo -e "${YELLOW}Usage: ./gex js [--module] [options] <target>${RESET}"
  echo ""
  echo -e "${MAGENTA}[modules]${RESET}"
  echo "  --secrets     Check for secrets in files/directories."
  echo "  --juicy       Find juicy information in files/directories."
  echo "  --content     Get content from a URL."
  echo ""
  echo -e "${MAGENTA}[options]${RESET}"
  echo "  -u <url>        Url target"
  echo "  -f <file>       Input file."
  echo "  -d <directory>  Input directory."
  echo "  -o <output>     Write output to a file."
  echo ""
  exit 0
fi






case "$1" in
        # --secrets)
        #     echo "You are using [js] module"
        #     shift
        #     local secrets_target=""
        #     local output_file=""
    
        #     while [[ $# -gt 0 ]]; do
        #         case "$1" in
        #             -f)
        #                 secrets_target="$2"
        #                 shift 2
        #                 ;;
        #             -d)
        #                 secrets_target="$2"
        #                 shift 2
        #                 ;;
        #             -o)
        #                 output_file="$2"
        #                 shift 2
        #                 ;;
        #             *)
        #                 echo "Unknown option for --secrets: $1"
        #                 exit 1
        #                 ;;
        #         esac
        #     done
    
        #     if [ -n "$output_file" ]; then
        #         exec > "$output_file"
        #     fi
    
        #     if [ -f "$secrets_target" ]; then
        #         scanRegex_file "$secrets_target"
        #     elif [ -d "$secrets_target" ]; then
        #         if [[ "$secrets_target" == "." ]]; then
        #             scanRegex_dir "$(pwd)"
        #         else
        #             scanRegex_dir "$secrets_target"
        #         fi
        #     else
        #         echo "Error: there is no file or directory"
        #         exit 1
        #     fi
        #
        
    # --juicy)
    #     shift
    #     juicy_target=""
    #     output_file=""

    #     while [[ $# -gt 0 ]]; do
    #         case "$1" in
    #             -f)
    #                 juicy_target="$2"
    #                 shift 2
    #                 ;;
    #             -d)
    #                 juicy_target="$2"
    #                 shift 2
    #                 ;;
    #             -o)
    #                 output_file="$2"
    #                 shift 2
    #                 ;;
    #             *)
    #                 echo "Unknown option for --juicy: $1"
    #                 exit 1
    #                 ;;
    #         esac
    #     done

    #     if [ -n "$output_file" ]; then
    #         exec > "$output_file"
    #     fi

    #     if [ -f "$juicy_target" ]; then
    #         getQuery "$juicy_target"
    #     elif [ -d "$juicy_target" ]; then
    #         getQuery_dir "$juicy_target"
    #     else
    #         echo "Error: there is no file or directory"
    #         exit 1
    #     fi
    #     ;;



    --content)
        shift
        content_url=""
        output_file=""
        content_file=""
        
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -u)
                    if [[ -z "$2" || "$2" == -* ]];then
                        echo "Invalid URL: -u requires a value"
                        exit 1
                    fi
                    content_url="$2"
                    shift 2
                    ;;
                -f|-fil)
                    if [[ -z "$2" || "$2" == -* ]];then
                        echo "Invalid file: -f requires a value"
                        exit 1
                    fi
                    content_file="$2"
                    shift 2
                    ;;

                -o)
                    output_file="$2"
                    shift 2
                    ;;
                *)
                    echo "Unknown option for --content: $1"
                    exit 1
                    ;;
            esac
        done

        # cannot use both
        if [[ -n "$content_url" && -n "$content_file" ]];then
            echo "Use either -u OR -f, not both"
            exit 1
        fi


        # single JS URL
        if [[ -n "$content_url" ]]; then
            if [[ "$content_url" =~ ^https?://.+\.js$ ]]; then
                getContent "$content_url" "$output_file"
            else
                echo "Invalid URL"
                exit 1
            fi
        elif [[ -n "$content_file" ]]; then
            process_js_file "$content_file" "$output_file"
        else
            echo "Invalid Input: use -u or -f"
            exit 1
        fi
        ;;
    *)
        echo "No Module with this name"
        exit 1
        ;;
esac




