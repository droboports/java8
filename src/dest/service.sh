#!/usr/bin/env sh
#
# Service.sh for java8

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="java8"
version="8.33.05"
description="Java Runtime Environment 8u33"
depends=""
webui=""

prog_dir="$(dirname "$(realpath "${0}")")"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  . "${prog_dir}/libexec/service.subr"
fi

start() {
  return 0
}

is_running() {
  return 0
}

is_stopped() {
  return 0
}

stop() {
  return 0
}

force_stop() {
  return 0
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o pipefail # propagate last error code on pipe
set -o xtrace   # enable script tracing

main "${@}"
