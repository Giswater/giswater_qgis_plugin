#!/usr/bin/env bash
# Bootstrap a full Giswater network from scratch:
#   extensions → ws + ud → satellites → integrate → network show
#
# Usage:
#   export CONN='postgresql://user:pass@host:port/dbname'
#   ./scripts/gw_bootstrap_network.sh
#
# Options:
#   --check   plan only (passes --check to gw)
#   --drop    drop network + satellite schemas (demo cleanup)
#
# Schema names (override via env):
#   WS=ws UD=ud UTILS=utils CIBS=cibs
#
# Extend satellites: edit SATELLITES_CREATE below (uncomment cm, am, audit when ready).

set -euo pipefail

CONN="${CONN:?export CONN='postgresql://user:pass@host:port/dbname'}"
WS="${WS:-ws}"
UD="${UD:-ud}"
UTILS="${UTILS:-utils}"
CIBS="${CIBS:-cibs}"
# CM="${CM:-cm}"
# AM="${AM:-am}"
# AUDIT="${AUDIT:-audit}"

CHECK=""
DROP=""

for arg in "$@"; do
  case "$arg" in
    --check) CHECK="--check" ;;
    --drop) DROP=1 ;;
    -h|--help)
      sed -n '2,16p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $arg (try --help)" >&2; exit 1 ;;
  esac
done

# Satellite kinds to create and integrate with each parent (ws, ud).
# Order matters if you add FK-dependent addons later.
SATELLITES_CREATE=(
  utils
  cibs
  # cm
  # am
  # audit
)

declare -A SATELLITE_NAME=(
  [utils]="$UTILS"
  [cibs]="$CIBS"
  # [cm]="$CM"
  # [am]="$AM"
  # [audit]="$AUDIT"
)

PARENTS=("$WS" "$UD")

PLUGIN_VER="${PLUGIN_VER:-}"

run() {
  echo ""
  echo ">>> gw $*"
  extra=()
  if [[ -n "$PLUGIN_VER" ]]; then
    extra+=(--version "$PLUGIN_VER")
  fi
  gw "$@" "${extra[@]}" $CHECK
}

drop_schemas() {
  echo "=== drop network schemas ==="
  gw schema main drop --name "$WS" --yes --cascade --conn "$CONN" || true
  gw schema main drop --name "$UD" --yes --cascade --conn "$CONN" || true

  echo "=== drop satellite schemas ==="
  for kind in "${SATELLITES_CREATE[@]}"; do
    name="${SATELLITE_NAME[$kind]:-$kind}"
    gw schema addon drop --type "$kind" --name "$name" --yes --cascade --conn "$CONN" || true
  done

  echo "Dropped $WS $UD and satellites: ${SATELLITES_CREATE[*]}"
}

create_satellite() {
  local kind="$1"
  local name="${SATELLITE_NAME[$kind]:-$kind}"
  local extra=()

  case "$kind" in
    utils|cibs)
      extra=(--name "$name")
      ;;
    # cm|am)
    #   extra=(--name "$name" --profile bootstrap)
    #   ;;
    # audit)
    #   extra=(--name "$name" --profile empty)
    #   ;;
    *)
      extra=(--name "$name")
      ;;
  esac

  run schema addon create --type "$kind" "${extra[@]}" --conn "$CONN"
}

integrate_satellite() {
  local kind="$1"
  local parent="$2"

  case "$kind" in
    utils)
      run schema addon integrate --type utils --parent "$parent" --conn "$CONN"
      ;;
    cibs|cm|am)
      run schema addon integrate --type "$kind" --parent "$parent" --conn "$CONN"
      ;;
    # audit uses activate profile after structure exists
    # audit)
    #   run schema addon integrate --type audit --parent "$parent" --profile integrate --conn "$CONN"
    #   ;;
    *)
      run schema addon integrate --type "$kind" --parent "$parent" --conn "$CONN"
      ;;
  esac
}

if [[ -n "$DROP" ]]; then
  drop_schemas
  exit 0
fi

echo "=== 1. PostgreSQL extensions ==="
run db init --conn "$CONN"

echo "=== 2. Network schemas (ws + ud) ==="
run schema main create --type ws --name "$WS" --profile empty --conn "$CONN"
run schema main create --type ud --name "$UD" --profile empty --conn "$CONN"

echo "=== 3. Satellite schemas ==="
for kind in "${SATELLITES_CREATE[@]}"; do
  create_satellite "$kind"
done

echo "=== 4. Integrate satellites with ws and ud ==="
for kind in "${SATELLITES_CREATE[@]}"; do
  for parent in "${PARENTS[@]}"; do
    integrate_satellite "$kind" "$parent"
  done
done

if [[ -z "$CHECK" ]]; then
  echo ""
  echo "=== 5. Network status ==="
  extra=()
  if [[ -n "$PLUGIN_VER" ]]; then
    extra+=(--version "$PLUGIN_VER")
  fi
  gw network show "${extra[@]}" --conn "$CONN"
fi

echo ""
echo "Done."
