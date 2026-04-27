#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck source=/dev/null
# bash /volume1/homes/admin/scripts/bash/dnsreload.sh

check_pid_in_docker() {                                                                           # Function to check if a PID belongs to a Docker container
  local pid="$1"                                                                                  # Assigns the first argument to a local variable 'pid'
  if [[ -f "/proc/$pid/mountinfo" ]]; then                                                        # Check if /proc/$pid/mountinfo exists, which provides details about a process's mounts
    if container_id=$(awk -F'docker/containers/|/' '\
    {for (i=2;i<=NF;i++)                            \
    if ($i ~ /^[0-9a-f]{64}$/) {print $i; exit}}' "/proc/$pid/mountinfo"); then                   # Extract container ID from the mountinfo file if the process is in a Docker container
      container_name=$(docker ps --filter "id=$container_id" --format '{{.Names}}' 2>/dev/null)   # Get the container name from the Docker container ID
      if [[ -n "$container_name" ]]; then                                                         # If a container name is found, return it, else return an empty string
        echo "$container_name"
      else
        echo ""
      fi
    else
      echo ""                                                                                     # If container ID is not found, return an empty string
    fi
  else                                                                                            # Print an error if /proc/$pid/mountinfo is not found for the process
    printf '%16s %s\n' "Error:" "/proc/$pid/mountinfo not found"
  fi
}

restart_dns_service() {                                                                           # Function to restart DNS services based on their type (daemon or Docker)
  local service_name="$1"                                                                         # The name of the DNS service
  local type_name="$2"                                                                            # Type of service (daemon or docker)
  local container_name="$3"                                                                       # Docker container name (optional)
  case "$type_name" in
  "daemon")
    printf '%16s %s\n' "Type:" "$type_name"                                                       # Print the type of service (daemon)
    case "$service_name" in                                                                       # Based on the service name, call the appropriate DNS reload command
    "pihole" | "pihole-FTL")                                                                      # Reload Pi-hole DNS
      printf '%16s %s\n' "Action:" "Reloading Pi-hole DNS ($service_name)"
      pihole restartdns reload \
        2> >(grep -v "utils\.sh:.*readonly variable" >&2)                                         # Suppress specific error messages related to readonly variables in Pi-hole's utils.sh
      ;;
    "AdGuardHome")                                                                                # Reload AdGuard Home DNS
      printf '%16s %s\n' "Action:" "Reloading AdGuard DNS ($service_name)"
      systemctl reload AdGuardHome
      ;;
    "named")                                                                                      # Reload BIND DNS
      printf '%16s %s\n' "Action:" "Reloading BIND DNS ($service_name)"
      rndc reload
      ;;
    "unbound")                                                                                    # Reload Unbound DNS
      printf '%16s %s\n' "Action:" "Unbound DNS ($service_name)"
      unbound-control reload
      ;;
    *)                                                                                            # Handle undefined service names
      printf '%16s %s\n' "Error:" "undefined $service_name ($type_name)"                          
      ;;
    esac
    ;;

  "docker")
    printf '%16s %s\n' "Type:" "$type_name ($container_name)"                                     # Print the service type with the Docker container name
    case "$service_name" in                                                                       # Based on the service name, call the appropriate DNS reload command inside the Docker container
    "pihole" | "pihole-FTL")                                                                      # Reload Pi-hole DNS inside Docker
      printf '%16s %s\n' "Action:" "Reloading Pi-hole DNS ($service_name)"
      docker exec "$container_name" pihole reloaddns \
        2> >(grep -v "utils\.sh:.*readonly variable" >&2)                                         # Suppress specific error messages related to readonly variables in Pi-hole's utils.sh
      ;;
    "AdGuardHome")                                                                                # Reload AdGuard DNS inside Docker
      printf '%16s %s\n' "Action:" "Reloading AdGuard DNS ($service_name)"
      docker exec "$container_name" /opt/adguardhome/AdGuardHome -s reload
      ;;
    *)                                                                                            # Handle undefined service names
      printf '%16s %s\n' "Error:" "undefined $service_name ($type_name)"
      ;;
    esac
    ;;

  *)                                                                                              # Handle unknown service types
    echo "Unknown type detected: $type_name"
    printf '%16s %s\n' "Error:" "undefined type ($type_name)"
    ;;
  esac
}

if LOCALTEST=$(netstat -tulpnW | grep "\:53\b" | grep "tcp\b" | grep "LISTEN"); then              # Detect the DNS service and its type by checking port 53
  DNSPROT=$(awk '{ print $1 }'                                                 <<< "$LOCALTEST")  # Capture the protocol (e.g., TCP or UDP) from the first field
  DNSPORT=$(awk '{ split($4, a, ":"); print a[2] }'                            <<< "$LOCALTEST")  # Capture the port number by splitting the IP:port field (field 4)
  DNSPID=$(awk  '{ split($7, a, "/"); print a[1] }'                            <<< "$LOCALTEST")  # Capture the program's PID (field 7, before the '/')
  DNSPROG=$(awk '{ split($7, a, "/"); gsub(/[ \t]+$/, "", a[2]); print a[2] }' <<< "$LOCALTEST")  # Capture the program name (field 7, after the '/')

  printf '\n%s\n\n' "CHECKING FOR LOCAL DNS SERVER AND FLUSHING CACHE"
  printf '%16s %s\n' "Local DNS:" "$DNSPROT/$DNSPORT $DNSPROG (pid:$DNSPID)"                      # Print the detected DNS service and its details

  container_name=$(check_pid_in_docker "$DNSPID")                                                 # Check if the DNS service's PID belongs to a Docker container
  if [ -n "$container_name" ]; then                                                               # If the service is running inside a Docker container, reload it as a Docker service
    restart_dns_service "$DNSPROG" "docker" "$container_name"
  else                                                                                            # Otherwise, treat it as a regular daemon service
    restart_dns_service "$DNSPROG" "daemon"
  fi
else                                                                                              # Print message if no local DNS server is found listening on port 53
  printf '%16s %s\n' "Local DNS:" "Not found"
fi
