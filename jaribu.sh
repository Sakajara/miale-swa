#!/bin/bash
# jaribu.sh -- endesha majaribio ya vekta.
set -e
HAPA="$(cd "$(dirname "$0")" && pwd)"
"$HAPA/jenga.sh" jaribu_vekta.swa "$HAPA/.jenga/jaribu_vekta"
"$HAPA/.jenga/jaribu_vekta" && echo "jaribu_vekta: SAWA" || { echo "jaribu_vekta: SHINDWA (msimbo $?)"; exit 1; }
