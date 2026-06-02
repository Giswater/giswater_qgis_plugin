# Baked into runner image (LF). Run bind-mounted test/*.sh without CRLF breaking "set -o pipefail".
gw_bash() {
  bash <(tr -d '\r' < "$1") "${@:2}"
}
