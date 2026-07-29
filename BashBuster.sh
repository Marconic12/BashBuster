#! /usr/bin/bash 
shopt -s extglob

function fuzzing {
       local extension=$4
       local timeout=${3:-0}
       local target=${1%/}	 
       local file=$2
	if [ ! -f "$file" ]; then
	 	printf "[!] File %s not found..\n" "$file"
		exit 1
	else
		while read -r word; do
			local url="$target"/"$word"
			if [[ -n $extension ]]; then
			    url="$url.$extension"
			fi
			statusCode=$(curl -s -o /dev/null -w %{http_code} "$url"
		       	sleep "$timeout"
			
			if [[ "$statusCode" == @(200|301|302) ]]; then
				printf "[+] Endpoint found: %s" "$url"
			fi
		done < "$file"
	fi
}

while getopts "u:w:e:d:h" flag; do
	case "${flag}" in
		(u) url="${OPTARG}" ;;
		(w) wordlist="${OPTARG}";;
		(e) extension="${OPTARG}";;
		(d) delay="${OPTARG}" ;;
		(h) printf "USO: ./BashBuster.sh -u <URL> -w <WORDLIST> [-e EXTENSION ] [-d DELAY ] \n"
			exit 0;;
		(*) printf "[!] Invalid flag !!!"
			exit 1 ;;
	esac
	done
		if [[ -z "$url" || -z "$wordlist" ]]; then
			printf "[!] Error: -u <URL> and -w <WORDLIST> are required.\n"
			exit 1
	
	fuzzing "$url" "$wordlist" "$delay" "$extension"

#bydrw	
