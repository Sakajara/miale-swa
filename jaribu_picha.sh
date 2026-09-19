#!/bin/bash
# jaribu_picha.sh -- ukaguzi wa picha nzima: jenga miale.swa, chora miale.ppm,
# na kagua muundo wa PPM, uamuzi (rendering mara mbili = picha sawa baiti kwa
# baiti), na rangi za pikseli maalum (anga, duara tatu, sakafu nyepesi).
HAPA="$(cd "$(dirname "$0")" && pwd)"
cd "$HAPA" || exit 1
mkdir -p .jenga
./jenga.sh miale.swa .jenga/miale || { echo "jaribu_picha: KUJENGA KUMESHINDWA"; exit 1; }
cd .jenga || exit 1
./miale > /dev/null || { echo "jaribu_picha: miale imeshindwa kuendeshwa"; exit 1; }

SHIDA=0
kagua() { if [ "$1" = "1" ]; then echo "  sawa: $2"; else echo "  SHINDWA: $2"; SHIDA=1; fi; }

UKUBWA=$(stat -c%s miale.ppm)
kagua "$([ "$UKUBWA" -eq 360015 ] && echo 1 || echo 0)" "ukubwa wa faili = 360015 (15 + 400*300*3), umepata $UKUBWA"
KICHWA=$(head -c 15 miale.ppm | od -An -c | tr -d ' \n')
kagua "$([ "$KICHWA" = 'P6\n400300\n255\n' ] && echo 1 || echo 0)" "kichwa cha PPM ni P6 / 400 300 / 255"

pikseli() { # x y -> "r g b"
    od -An -tu1 -j$((15 + ($2 * 400 + $1) * 3)) -N3 miale.ppm | tr -s ' ' | sed 's/^ //'
}

read R G B <<< "$(pikseli 50 30)"
kagua "$([ "$B" -gt 240 ] && [ "$B" -gt "$R" ] && echo 1 || echo 0)" "anga (50,30) ni buluu-nyeupe: $R $G $B"
read R G B <<< "$(pikseli 150 140)"
kagua "$([ "$R" -gt 150 ] && [ "$G" -lt 110 ] && [ "$B" -lt 110 ] && echo 1 || echo 0)" "duara jekundu (150,140): $R $G $B"
read R G B <<< "$(pikseli 265 165)"
kagua "$([ "$G" -gt 140 ] && [ "$R" -lt 110 ] && echo 1 || echo 0)" "duara kijani (265,165): $R $G $B"
read R G B <<< "$(pikseli 205 188)"
kagua "$([ "$B" -gt 150 ] && [ "$R" -lt 110 ] && echo 1 || echo 0)" "duara la buluu (205,188): $R $G $B"
read R G B <<< "$(pikseli 150 280)"
kagua "$([ "$R" -gt 200 ] && [ "$G" -gt 200 ] && [ "$B" -gt 200 ] && echo 1 || echo 0)" "kigae cha sakafu chenye mwanga (150,280) ni nyepesi: $R $G $B"

RANGI=$(od -An -tu1 -v -w3 -j15 miale.ppm | sort -u | wc -l)
kagua "$([ "$RANGI" -gt 1000 ] && echo 1 || echo 0)" "picha si tupu wala rangi moja: rangi tofauti $RANGI (> 1000)"

cp miale.ppm miale_ya_kwanza.ppm
./miale > /dev/null
kagua "$(cmp -s miale.ppm miale_ya_kwanza.ppm && echo 1 || echo 0)" "kuchora mara mbili kunatoa picha sawa baiti kwa baiti"
rm -f miale_ya_kwanza.ppm

if [ $SHIDA -eq 0 ]; then echo "jaribu_picha: SAWA"; else echo "jaribu_picha: SHINDWA"; fi
exit $SHIDA
