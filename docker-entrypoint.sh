#!/bin/bash

[[ $# -gt 0 ]] && exec "$@"

function msg {
    1>&2 cat <<< "$*"
}

CONF_FILE=/mosquitto/config/mosquitto.conf

[[ -e "${CONF_FILE}" ]] && mv "${CONF_FILE}" "${CONF_FILE}.bak"

cat > "${CONF_FILE}" <<CONFIG
log_dest stdout
persistence false
persistence_location /mosquitto/data/
CONFIG

for var in "${!MQTT_@}"; do
    name="${var#MQTT_*}"
    name="${name,,}"
    case "${name}" in
        persistence_location)
            msg "WARN: ${name} can not be changed"
            ;;
        '')
            msg "ERROR: Not a valid variable name: ${name}"
            ;;
        *)
            msg "INFO: Setting '${name}' to '${!var}'"
            echo "${name} ${!var}" >> "${CONF_FILE}"
            ;;
    esac
done

exec /usr/sbin/mosquitto -c ${CONF_FILE}
