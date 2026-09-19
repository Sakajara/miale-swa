#!/bin/bash
# jaribu.sh -- endesha majaribio yote (vekta, jiometri, mandhari) na
# ukaguzi wa picha (jaribu_picha.sh).
HAPA="$(cd "$(dirname "$0")" && pwd)"
SHIDA=0
for j in jaribu_vekta jaribu_jiometri jaribu_mandhari; do
    "$HAPA/jenga.sh" "$j.swa" "$HAPA/.jenga/$j" || { echo "$j: KUJENGA KUMESHINDWA"; SHIDA=1; continue; }
    "$HAPA/.jenga/$j"
    RC=$?
    if [ $RC -eq 0 ]; then echo "$j: SAWA"; else echo "$j: SHINDWA (msimbo $RC)"; SHIDA=1; fi
done
"$HAPA/jaribu_picha.sh" || SHIDA=1
exit $SHIDA
