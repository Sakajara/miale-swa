#!/bin/bash
# jaribu.sh -- endesha majaribio yote ya Swa (jaribu_*.swa), pamoja na
# ukaguzi wa mstari-wa-amri wa miale.swa.
#
# Matumizi: SWA_DIR=/njia/ya/swa ./jaribu.sh [jaribu_jina.swa ...]
# Bila hoja, inaendesha majaribio yote. Kila jaribio lina kikomo cha muda
# (JARIBIO_MUDA, sekunde, chaguo-msingi 300): kuning'inia = kushindwa.
# Msimbo wa kutoka 0 = yote yamefaulu.
HAPA="$(cd "$(dirname "$0")" && pwd)"
cd "$HAPA" || exit 1
mkdir -p .jenga
if [ $# -gt 0 ]; then MAJARIBIO=("$@"); else MAJARIBIO=(jaribu_*.swa); fi
LIMIT=""
command -v timeout > /dev/null 2>&1 && LIMIT="timeout ${JARIBIO_MUDA:-300}"
FAULU=0; SHINDWA=0
for j in "${MAJARIBIO[@]}"; do
    jina="$(basename "$j" .swa)"
    if ! ./jenga.sh "$jina.swa" ".jenga/$jina" 2> ".jenga/$jina.jenga.log"; then
        echo "SHINDWA (kukusanya): $jina"; cat ".jenga/$jina.jenga.log"; SHINDWA=$((SHINDWA+1)); continue
    fi
    $LIMIT ".jenga/$jina" > ".jenga/$jina.towe" 2>&1
    RC=$?
    if [ $RC -eq 0 ]; then
        echo "imefaulu: $jina  ($(tail -1 ".jenga/$jina.towe"))"; FAULU=$((FAULU+1))
    else
        echo "SHINDWA: $jina (msimbo $RC)"; cat ".jenga/$jina.towe"; SHINDWA=$((SHINDWA+1))
    fi
done

# Programu ya mstari-wa-amri: msimbo wa kutoka na faili la towe kwa hoja
# halali na zisizo halali (hakuna mantiki ya picha hapa -- hiyo iko kwenye
# jaribu_picha.swa).
if [ $# -eq 0 ]; then
    if ./jenga.sh miale.swa .jenga/miale 2> .jenga/miale.jenga.log; then
        KABLA=$SHINDWA; M=".jenga/miale"; T=".jenga/cli"; rm -rf "$T"; mkdir -p "$T"
        kagua() { # jina, msimbo unaotarajiwa, msimbo halisi
            if [ "$2" = "$3" ]; then FAULU=$((FAULU+1)); else echo "SHINDWA: cli: $1 (tarajiwa $2, halisi $3)"; SHINDWA=$((SHINDWA+1)); fi
        }
        $M 8 6 1 "$T/a.ppm" > /dev/null;            kagua "8 6 1 -> 0" 0 $?
        kagua "faili la 8x6 ni baiti 155" 155 "$(stat -c%s "$T/a.ppm")"
        $M 1 1 1 "$T/b.ppm" > /dev/null;            kagua "1 1 1 -> 0" 0 $?
        kagua "faili la 1x1 ni baiti 14" 14 "$(stat -c%s "$T/b.ppm")"
        $M 4096 1 1 "$T/c.ppm" > /dev/null;         kagua "4096 1 1 -> 0" 0 $?
        kagua "faili la 4096x1 ni baiti 12302" 12302 "$(stat -c%s "$T/c.ppm")"
        for h in "0 5" "5 0" "4097 5" "5 4097" "abc 5" "5 -3" "5 5x" "5 5 0 x.ppm" "5 5 9 x.ppm" "5 5 1x x.ppm" "1234567890 5"; do
            $M $h > /dev/null 2>&1;                 kagua "hoja zisizo sahihi ($h) -> 2" 2 $?
        done
        $M 7 > /dev/null 2>&1;                      kagua "hoja moja -> 2" 2 $?
        $M 1 1 1 a.ppm ziada > /dev/null 2>&1;      kagua "hoja nyingi mno -> 2" 2 $?
        $M 4 4 1 /hakuna/saraka/x.ppm > /dev/null 2>&1; kagua "faili lisiloandikika -> 1" 1 $?
        [ ! -e x.ppm ] && [ ! -e a.ppm ] && FAULU=$((FAULU+1)) || { echo "SHINDWA: cli: faili la bahati mbaya limeandikwa"; SHINDWA=$((SHINDWA+1)); }
        [ "$SHINDWA" -eq "$KABLA" ] && echo "imefaulu: ukaguzi wa mstari-wa-amri (miale.swa)"
    else
        echo "SHINDWA (kukusanya): miale.swa"; cat .jenga/miale.jenga.log; SHINDWA=$((SHINDWA+1))
    fi
fi
echo "=== majaribio: $FAULU yamefaulu, $SHINDWA yameshindwa ==="
[ "$SHINDWA" -eq 0 ]
