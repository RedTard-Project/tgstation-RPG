#!/bin/sh
set -e
cd "$(dirname "$0")/../.."
exec tools/bootstrap/javascript.sh modular_redtard/build/build_modular.ts "$@"
