#!/bin/bash
# jenga.sh -- jenga programu ya Swa kwa mkusanyaji wa Swa (stage1).
#
# Matumizi:  ./jenga.sh <faili.swa> <towe>
#   SWA_DIR  = mahali pa hazina ya mkusanyaji wa Swa
#              (chaguo-msingi: ~/Projects/compilers/swa)
#
# Mara ya kwanza, hujenga mnyororo wa mkusanyaji (mbegu -> msuluhishi ->
# stage1) na kuuhifadhi kwenye .jenga/. Kisha hutatua "husisha" na
# kukusanya programu yako.
set -e
SWA="${SWA_DIR:-$HOME/Projects/compilers/swa}"
HAPA="$(cd "$(dirname "$0")" && pwd)"
KASHE="$HAPA/.jenga"
FAILI="$1"
TOWE="$2"
[ -n "$FAILI" ] && [ -n "$TOWE" ] || { echo "matumizi: $0 <faili.swa> <towe>"; exit 2; }
[ -d "$SWA/msingi" ] || { echo "hazina ya Swa haipatikani: $SWA (weka SWA_DIR)"; exit 1; }

mkdir -p "$KASHE"
if [ ! -x "$KASHE/stage1" ]; then
    echo "jenga mnyororo wa mkusanyaji (mara ya kwanza tu)..."
    (cd "$SWA" && bash gharama/jenga-kwanza.sh > /dev/null)
    MBEGU=/tmp/mbegu2.bin
    cat "$SWA/msingi/maktaba/kumbukumbu.swa" "$SWA/msingi/maktaba/mfuatano.swa" \
        "$SWA/msingi/maktaba/faili.swa" "$SWA/gharama/msuluhishi.swa" > "$KASHE/ms.swa"
    "$MBEGU" --exe "$KASHE/ms.swa" > "$KASHE/msuluhishi"
    chmod +x "$KASHE/msuluhishi"
    (cd "$SWA" && "$KASHE/msuluhishi" msingi/mkusanyaji/stage1.swa) > "$KASHE/zima.swa"
    "$MBEGU" --exe "$KASHE/zima.swa" > "$KASHE/stage1"
    chmod +x "$KASHE/stage1"
fi

# msuluhishi hutafuta "husisha" kwenye msingi/, msingi/maktaba/ na saraka ya sasa
ln -sfn "$SWA/msingi" "$HAPA/msingi"
(cd "$HAPA" && "$KASHE/msuluhishi" "$FAILI") > "$KASHE/zima_programu.swa"
"$KASHE/stage1" --exe "$KASHE/zima_programu.swa" > "$TOWE"
chmod +x "$TOWE"
