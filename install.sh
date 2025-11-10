#!/usr/bin/env bash

readonly SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd );

function main
{
  set -o errexit
  set -o pipefail
  set -o nounset
  set -o errtrace

  sudo apt install pipx -y

  if [ ! -d ~/.infisical/ ]
  then
    curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | sudo -E bash
    sudo apt-get update && sudo apt-get install -y infisical
    infisical login
  fi

  cd ~
  if [ ! -f ~/.infisical.json ]
  then
    infisical init
  fi

  cd "${SCRIPT_DIR}"
  sudo cp "${SCRIPT_DIR}/locust_worker.service" /etc/systemd/system/locust_worker.service
  sudo systemctl daemon-reload
  sudo systemctl enable locust_worker
  sudo systemctl start locust_worker
}

function error_exit
{
  (>&2 echo "$1")
  exit 1
}

main "$@"


