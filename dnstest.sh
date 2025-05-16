#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck source=/dev/null
# bash /volume1/homes/admin/scripts/bash/dnstest.sh

# PARSE COMMAND-LINE OPTIONS (FUTURE OPTIONS)
while getopts "::" opt; do
  case ${opt} in
  \?)
    printf "Usage: %s\n" "$0"
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

# CHECK FOR DIG REQUIREMENT
if ! command -v dig &>/dev/null; then
  printf "\n"
  printf "* DIG (Domain Information Gopher) is required for DNS queries,\n"
  printf "  but is not found in the PATH. Please install it.\n"
  printf "\n"
  if [ -e "/proc/sys/kernel/syno_hw_version" ]; then
    printf "  DIG can be installed as a part of the 'SynoCli Network Tools'\n"
    printf "  package. This can be installed via the DSM Package Center by\n"
    printf "  adding the 'SynoCommunity' Package Source site, located at:\n"
    printf "\n"
    printf "     https://packages.synocommunity.com/\n"
  else
    printf "  DIG can typically be installed as a part of the 'dnsutils' or\n"
    printf "  'bind-utils' packages. These can be installed via your\n"
    printf "  package management system.\n"
  fi
  printf "\n"
  printf "Exiting...\n"
  printf "\n"
  exit 1
fi

# SCRAPE SCRIPT PATH INFO
SrceFllPth=$(readlink -f "${BASH_SOURCE[0]}")                       # get full path of running script
SrceFolder=$(dirname "$SrceFllPth")                                 # extract directory path from full path
SrceFileNE=${SrceFllPth##*/}                                        # extract filename and extension from full path
SrceFileNm=${SrceFileNE%.*}                                         # extract only filename from filename and extension

# RECURRING FUNCTIONS

sanitize_array() {
  local -n arr=$1
  shopt -s extglob
  arr=("${arr[@]/#+([[:blank:]])/}")
  arr=("${arr[@]/%+([[:blank:]])/}")
}

query_dns() {
  local server=$1
  local domain=$2
  local time
  time=$(dig +tries=1 +timeout=1 @"$server" "$domain" | awk '/Query time:/ { print $4 }')
  [[ -z "$time" ]] && time=1000
  [[ "$time" -eq 0 ]] && time=1
  printf "%s\n" "$time"
}

# BUILD LIST OF NAMESERVERS USED BY THIS HOST
mapfile -t NAMESERVERS < <(awk '/^nameserver/ {print $2 "#" $1 "/" NR}' /etc/resolv.conf)

# CHECK IF LOCALHOST IS RUNNING DNS ON THE DEFAULT PORT
if LOCALTEST=$(netstat -tulpnW | grep "\:53\b" | grep "tcp\b" | grep "LISTEN"); then
  LOCALDNS=$(awk -F '/' 'NR==1 { sub(/[ \t]+$/, "", $2); print $2; exit }' <<< "$LOCALTEST")
  LOCALDNS="${LOCALDNS:0:14}"
  LOCALHOST=("127.0.0.1#${LOCALDNS}/I" "127.0.0.1#${LOCALDNS}/C")
  NAMESERVERS=("${LOCALHOST[@]}" "${NAMESERVERS[@]}")
fi

# SANITIZE NAMESERVERS ARRAY
sanitize_array NAMESERVERS

# IMPORT LIST OF IPV4 DNS PROVIDERS
mapfile -t PROVIDERSV4 < <(sort -t "#" -k 2,2 "$SrceFolder/$SrceFileNm.ipv4.txt")

# BUILD LIST OF IPV6 DNS PROVIDERS
mapfile -t PROVIDERSV6 < <(sort -t "#" -k 2,2 "$SrceFolder/$SrceFileNm.ipv6.txt")

# BUILD LIST OF DOMAINS TO TEST AGAINST
mapfile -t DOMAINS2TEST < <(sort -u "$SrceFolder/$SrceFileNm.domains.txt")

# SANITIZE DOMAINS2TEST ARRAY
sanitize_array DOMAINS2TEST

if [ "$1" = "ipv6" ]; then
  PROVIDERSTOTEST=("${PROVIDERSV6[@]}")
elif [ "$1" = "ipv4" ]; then
  PROVIDERSTOTEST=("${PROVIDERSV4[@]}")
elif [ "$1" = "all" ]; then
  PROVIDERSTOTEST=("${PROVIDERSV4[@]}" "${PROVIDERSV6[@]}")
else
  PROVIDERSTOTEST=("${PROVIDERSV4[@]}")
fi
if [ "$1" = "host" ]; then
  PROVIDERSTOTEST=("${NAMESERVERS[@]}")
elif [ "$1" = "-host" ]; then
  PROVIDERSTOTEST=("${PROVIDERSTOTEST[@]}")
else
  PROVIDERSTOTEST=("${NAMESERVERS[@]}" "${PROVIDERSTOTEST[@]}")
fi

# SANITIZE NAMESERVERS ARRAY
sanitize_array PROVIDERSTOTEST

# DETERMINE NAMESERVERS NAME LENGTH ($nsl)
for item in "${PROVIDERSTOTEST[@]}"; do
  if [[ -n "$item" ]] && [[ ! $item =~ ^#.* ]]; then
    pname=${item##*#}
    plength[${#pname}]=${item##*#}                                  # use word length as index
  fi
done
longest=("${plength[@]: -1}")                                       # select last array element
length=$((${#longest}))
nsl="%-$((${#longest} + 2))s"

printf '\n\n%s\n\n' "TESTING DOMAINS ($SrceFileNm.domains)"
printf '%8s %s\n' "Test#" "Domain Name"
printf '%8s %s\n' "------" "---------------"

domain_index=0
for d in "${DOMAINS2TEST[@]}"; do
  if [[ -n "$d" ]] && [[ ! $d =~ ^#.* ]]; then
    ((domain_index++))
    printf '%8s %s\n' "t$domain_index" "$d"
  fi
done
unset domain_index

printf '\n\n%s\n\n' "LOCAL THEN ALPHABETICAL BY SERVER ($SrceFileNm.log)"

# REDIRECT STDOUT TO TEE IN ORDER TO DUPLICATE THE OUTPUT TO THE TERMINAL AS WELL AS A .LOG FILE
exec > >(tee "$SrceFolder/$SrceFileNm.log")

eval printf '$nsl' "Server"
for d in "${DOMAINS2TEST[@]}"; do
  if [[ -n "$d" ]] && [[ ! $d =~ ^#.* ]]; then
    totaldomains=$((totaldomains + 1))
    printf "%-4s" "t$totaldomains"
  fi
done
printf "%9s\n" "Median ms"
eval printf -- '-%.0s' "{1..$((length + 1))}"

printf ' %.0s' ""
for d in "${DOMAINS2TEST[@]}"; do
  if [[ -n "$d" ]] && [[ ! $d =~ ^#.* ]]; then
    printf "%-4s" "---"
  fi
done
printf "%-4s\n" "---------"

for p in "${PROVIDERSTOTEST[@]}"; do
  if [[ -n "$p" ]] && [[ ! $p =~ ^#.* ]]; then
    pip=${p%%#*}
    pname=${p##*#}
    ftime=0
    xtime=0
    eval printf '$nsl' "$pname"
    for d in "${DOMAINS2TEST[@]}"; do
      if [[ -n "$d" ]] && [[ ! $d =~ ^#.* ]]; then
        ttime=$(dig +tries=1 +timeout=1 @"$pip" "$d" | grep "Query time:" | awk '{ print $4 }')
        if [ -z "$ttime" ]; then
          ttime=1000                                                # Default timeout of 1000ms (1 second)
        elif [ "$ttime" = "0" ]; then
          ttime=1
        fi
        if [ "$ttime" -ge "1000" ]; then
          printf "%-4s" "*"
          xtime=$((xtime + 1))
        else
          printf "%-4s" "$ttime"
        fi
        ftime=$((ftime + ttime))
      fi
    done
    avg=$(awk -v a="$ftime" -v b="$totaldomains" 'BEGIN { printf "%.2f", a/b }' </dev/null)
    if [ "$xtime" -gt "0" ]; then
      if awk -v avg="$avg" 'BEGIN {exit !(avg > 999)}'; then
        printf "%3s %5s\n" "NR" "$xtime-to"
      else
        printf "%9s\n" "$avg ms"
      fi
      unset xtime
    else
      printf "%9s\n" "$avg ms"
    fi
  fi
done

# CLOSE AND NORMALIZE THE LOGGING REDIRECTIONS
exec >/dev/tty 2>&1

# SUMMARY REPORTS
header_row=$(head -n 2 "$SrceFolder/$SrceFileNm.log")               # Get the reusable results header row

# SORT LOGGED OUTPUT BY FASTEST MEDIAN RESPONSE TIME
read -r third_line < <(head -n 3 "$SrceFolder/$SrceFileNm.log" | tail -n 1)
num_fields=$(awk '{print NF}' <<< "$third_line")
tail -n +3 "$SrceFolder/$SrceFileNm.log" | sort -k "$((num_fields - 1))" -k "$num_fields" -n -o "$SrceFolder/$SrceFileNm.sorted.log"
{                                                                   # Store the data how we want it presented
  printf '%s\n' "$header_row"                                       # Print the summary header
  grep -v "NR" "$SrceFolder/$SrceFileNm.sorted.log"                 # Print responding servers
  grep "NR" "$SrceFolder/$SrceFileNm.sorted.log"                    # Print non-responding servers
} >"$SrceFolder/$SrceFileNm".temp.log && mv "$SrceFolder/$SrceFileNm".temp.log "$SrceFolder/$SrceFileNm.sorted.log"

printf '\n\n%s\n\n' "ALL SERVERS BY MEDIAN RESPONSE TIME ($SrceFileNm.sorted.log)"
cat "$SrceFolder/$SrceFileNm.sorted.log"
printf "\n"

# DISPLAY ONLY TIMEOUT LOGGED OUTPUT IF PRESENT
timeouts=$(grep "\*" "$SrceFolder/$SrceFileNm.sorted.log")
if [[ -n "$timeouts" ]]; then                                       # Check if the variable timeouts is non-empty before printing
  printf '\n%s\n\n' "RESULTS WITH QUERY TIMEOUTS"
  printf '%s\n' "$header_row"
  printf '%s\n' "$timeouts"
fi

printf '\n%s\n\n' "RESPONDING PROVIDERS BY AVERAGED MEDIAN RESPONSE TIMES"

# AVERAGE VALUES CALCULATION FOR EACH SERVER SET
declare -A counts sums

while IFS= read -r line; do                                         # Loop through each line in the sorted log file
  server_set=$(awk '{ sub(/\/.*/, "", $1); print $1 }' <<< "$line") # Extract the server set name (base name before the '/1', '/2', etc.)
  second_to_last_num=$(awk '{ print $(NF-1) }' <<< "$line")         # Extract the second-to-last number (this is the median response time)
  if [[ -n "$second_to_last_num" ]]; then                           # If the extracted number is not empty, process it
    sums[$server_set]=$(awk -v sum="${sums[$server_set]:-0}" -v num="$second_to_last_num" 'BEGIN { print sum + num }') # Convert to floating-point if necessary
    if [[ "$second_to_last_num" != "NR" ]]; then
      counts[$server_set]=$((counts[$server_set] + 1))
    fi
  fi
done < "$SrceFolder/$SrceFileNm.sorted.log"

sorted_sums=()                                                      # Declare an array to hold the sorted sums
for server_set in "${!sums[@]}"; do                                 # Collect the averages and server sets
  if [[ "${counts[$server_set]}" -gt 0 ]]; then
    avg=$(awk -v sum="${sums[$server_set]}" -v count="${counts[$server_set]}" 'BEGIN { printf "%.2f", sum / count }')
    if [[ "$avg" != "0.00" ]]; then                                 # Check if avg is not equal to 0.00 before adding to sorted_sums
      sorted_sums+=("$avg $server_set")                             # Store both avg and server_set into the sorted_sums array
    fi
  fi
done

sorted_output=$(printf '%s\n' "${sorted_sums[@]}" | sort -n)        # Sort the array based on the first column (avg value) numerically
eval printf '$nsl' "Provider"                                       # Print the sorted results header
printf "%9s %s\n" "Average" "Servers"
eval printf -- '-%.0s' "{1..$((length + 1))}"
printf ' %.0s' ""
printf "%-4s %5s\n" "---------" "-------"

while read -r avg server_set; do
  eval printf '$nsl' "$server_set"                                  # Print the provider name (server_set) formatted with $nsl
  printf "%9s " "$avg ms"                                           # Print the avg ms value right after the provider name
  printf "(%s)" "${counts[$server_set]}"                            # Print the count in parentheses (from ${counts[$server_set]})
  printf "\n"
done <<<"$sorted_output"

printf "\n"
