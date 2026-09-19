# miale-swa

Kifuatilia-miale (*ray tracer*) kilichoandikwa kwa **[Swa](https://github.com/lugha-swa/swa)**
safi: lugha ya mfumo ya Kiswahili inayojikusanya yenyewe. Programu ni faili
tuli la ELF la takriban KB 44 -- hakuna libc, hakuna maktaba za kushirikiana,
hakuna lugha nyingine yoyote kwenye mradi (msimbo, majaribio, mifano).

![Mfano: duara tatu juu ya sakafu ya ubao wa chesi](mfano.png)

*Pato la `./miale` bila hoja (400 x 300, sampuli 2 x 2). Picha hii ni pato
hilohilo baada ya kubadilishwa kutoka PPM kuwa PNG kwa ImageMagick;
pikseli ni zilezile.*

## Anza haraka

```sh
git clone https://github.com/lugha-swa/swa ~/Projects/compilers/swa   # mkusanyaji
git clone https://github.com/Sakajara/miale-swa && cd miale-swa

./jenga.sh miale.swa miale      # mara ya kwanza hujenga pia mnyororo wa mkusanyaji
./miale                         # huandika miale.ppm
```

Mahitaji: Linux x86-64 na `bash`. Kama mkusanyaji wa Swa uko sehemu nyingine
kuliko `~/Projects/compilers/swa`, weka `SWA_DIR=/njia/ya/swa`.

## Matumizi

```
miale [upana urefu [sampuli [faili.ppm]]]
```

| Hoja | Maana | Chaguo-msingi | Halali |
|---|---|---|---|
| `upana` | upana wa picha kwa pikseli | 400 | 1 .. 4096 |
| `urefu` | urefu wa picha kwa pikseli | 300 | 1 .. 4096 |
| `sampuli` | antialiasing: `sampuli x sampuli` miale kwa pikseli | 2 | 1 .. 8 |
| `faili.ppm` | mahali pa kuandika picha | `miale.ppm` | njia yoyote inayoandikika |

Hoja ni nambari kamili chanya za tarakimu 1..9; `abc`, `-3`, `5x` na
nafasi tupu zinakataliwa. `upana` na `urefu` huja pamoja (hoja moja tu ni kosa).

```sh
./miale                          # 400x300, sampuli 2  -> miale.ppm
./miale 800 600                  # 800x600, sampuli 2
./miale 1024 768 4 kubwa.ppm     # antialiasing 4x4, faili maalum
./miale 200 150 1 haraka.ppm     # rasimu ya haraka, bila antialiasing
convert miale.ppm miale.png      # PNG (ImageMagick) -- si sehemu ya mradi
```

**Msimbo wa kutoka:** `0` = sawa; `1` = imeshindwa kuandika faili au
kumbukumbu imeisha; `2` = hoja zisizo sahihi (ujumbe wa matumizi huenda
kwenye `stderr`).

**Muda na kumbukumbu.** Gharama ni sawia na `upana x urefu x sampuli²`,
takriban mikrosekunde 3 kwa mwale mmoja (kwa mashine ya kujaribia, msingi
mmoja, hakuna nyuzi nyingi):

| Ukubwa | Sampuli | Miale | Muda | Faili |
|---|---|---|---|---|
| 400 x 300 | 1 | 120 elfu | 0.4 s | KB 360 |
| 400 x 300 | 2 | 480 elfu | 1.3 s | KB 360 |
| 1024 x 768 | 2 | milioni 3.1 | 9.4 s | MB 2.4 |
| 1920 x 1080 | 4 | milioni 33 | 104 s | MB 6.2 |

Kumbukumbu inayohitajika ni baiti 3 kwa pikseli pamoja na kichwa (`4096 x 4096`
= MB 50). Kifuatilia hiki hakijaboreshwa kwa kasi -- lengo lake ni uwazi na
usahihi; angalia "Mipaka".

## Kinachochorwa

Mandhari moja isiyobadilika (`mandhari.swa`): duara tatu, sakafu, taa moja.

| Kitu | Kituo | Nusu-kipenyo | Rangi (0..1) |
|---|---|---|---|
| Duara jekundu | (-1.2, 0, -4) | 1.0 | (0.9, 0.2, 0.2) |
| Duara kijani | (1.3, -0.3, -3.2) | 0.7 | (0.2, 0.8, 0.3) |
| Duara la buluu | (0.1, -0.65, -2.2) | 0.35 | (0.2, 0.4, 0.95) |
| Sakafu | ndege `y = -1` | -- | ubao wa chesi: (0.9, 0.9, 0.9) na (0.35, 0.35, 0.4) |
| Taa | (-3, 5, -0.5) | -- | taa ya nukta, nyeupe, bila kupungua kwa umbali |
| Kamera | jicho (0, 0, 1), inatazama `-z` | -- | pembe ya kuona wima ≈ 73.7° |

Mwonekano: mwanga wa diffuse (Lambert) na mwanga mdogo wa mazingira, vivuli
vikali vya duara kwenye sakafu na kwenye duara zenyewe, ukungu kwenye sakafu
ya mbali, anga ya mteremko, antialiasing, na marekebisho ya gamma.

## Jinsi inavyofanya kazi

Kwa kila pikseli `(i, j)` na kila sampuli `(si, sj)` ndani yake:

1. **Mwale wa kamera.** Nukta ndani ya pikseli ni
   `px = i + (si + 0.5) / sampuli`, `py = j + (sj + 0.5) / sampuli`
   (gridi ya kawaida, si nasibu -- matokeo ni ya uamuzi). Kisha
   `u = (2·px/upana - 1) · (upana/urefu) · 0.75`,
   `v = (1 - 2·py/urefu) · 0.75`, na mwale una asili ya jicho na mwelekeo
   `sawazisha(u, v, -1)`. Nambari `0.75` ni `tan(pembe/2)` ya kuona wima.
2. **Makutano.** Kwa duara lenye kituo `c` na nusu-kipenyo `r`, tunatatua
   `a·t² + 2h·t + (oc·oc - r²) = 0`, ambapo `a = mwelekeo·mwelekeo` (mwelekeo
   si lazima usawazishwe), `oc = asili - c` na `h = oc·mwelekeo`. Kama diskriminanti `h² - a·c < 0` hakuna makutano;
   vinginevyo `t = (-h ∓ √diskriminanti) / a`, tukichagua mzizi mdogo unaozidi
   `0.001`. Sakafu ni `t = (-1 - asili.y) / mwelekeo.y`. Kinachoonekana ni
   `t` ndogo kuliko zote; sakafu zaidi ya umbali 100 haichorwi. Kutopata
   chochote = rangi ya anga: mchanganyiko wa nyeupe `(1,1,1)` na buluu
   `(0.5,0.7,1)` kwa `k = 0.5·(mwelekeo.y + 1)`.
3. **Kawaida ya uso.** Duara: `sawazisha(p - kituo)`. Sakafu: `(0, 1, 0)`.
   Rangi ya sakafu: `(⌊x⌋ + ⌊z⌋)` shufwa = kigae chepesi, witiri = kigae
   cheusi (imeongezwa `1000` ili nambari zibaki chanya kabla ya kukata).
4. **Mwanga.** `L` ni mwelekeo kuelekea taa;
   `rangi = rangi_msingi · (0.15 + 0.85 · max(0, kawaida·L))`.
5. **Kivuli.** Mwale wa pili hutumwa kutoka `p + 0.002·kawaida` kuelekea taa.
   Kama duara lolote liko kati ya nukta na taa, sehemu ya diffuse ni sifuri
   (mwanga wa mazingira 0.15 unabaki). Kupanda kwa `0.002` kando ya kawaida
   huzuia *shadow acne* (uso kujivuli wenyewe).
6. **Ukungu (sakafu tu).** `f = t / 100`;
   `rangi = rangi·(1 - f) + anga·f` -- sakafu ya mbali huyeyuka kuwa anga.
7. **Wastani na gamma.** Rangi za sampuli zote hujumlishwa na kugawanywa
   kwa `sampuli²`. Kila kituo hubanwa kwenye `[0, 1]`, kinachukuliwa mzizi wa
   mraba (gamma 2.0) na kuzidishwa `255`.
8. **PPM.** Kichwa `P6\n<upana> <urefu>\n255\n` kisha baiti tatu (R, G, B)
   kwa pikseli, safu ya juu kwanza.

Hesabu zote ni `D64` kwa maktaba ya `hesabu.swa` ya Swa (mzizi wa mraba kwa
mbinu ya Newton kwa marudio 25, bila libc). Hakuna nasibu wala wakati
kwenye kuchora, kwa hiyo **pato ni la uamuzi**: hoja zilezile daima hutoa baiti zilezile.

## Muundo wa mradi

| Faili | Kazi |
|---|---|
| `vekta.swa` | `Vekta` (`D64` x3): jumlisha, toa, zidisha, nukta, msalaba, urefu, sawazisha |
| `jiometri.swa` | `Mwale`, `Duara`; makutano ya mwale na duara; kawaida ya duara |
| `mandhari.swa` | duara, sakafu, taa, anga; `fuatilia(mwale)` (uangazaji, kivuli, ukungu); `baiti_ya_rangi` (gamma) |
| `kifuatilia.swa` | `chora_picha(bafa, upana, urefu, sampuli)`: mzunguko wa pikseli/sampuli, kuandika PPM kwenye kumbukumbu; `chora_ukubwa` |
| `miale.swa` | `main()`: hoja za mstari-wa-amri, uthibitisho, kuandika faili |
| `jaribu_*.swa` | majaribio (chini) |
| `jenga.sh`, `jaribu.sh` | gundi ya bash: kujenga na kuendesha majaribio tu; hakuna mantiki |

Tabaka zinategemeana kwa mstari mmoja: `vekta` ← `jiometri` ← `mandhari` ←
`kifuatilia` ← `miale`. Kiini (`kifuatilia.swa`) hakina `main()` wala
uandishi wa faili ili kijaribiwe moja kwa moja kwenye kumbukumbu.

## Majaribio

```sh
./jaribu.sh                       # yote
./jaribu.sh jaribu_picha.swa      # moja
JARIBIO_MUDA=60 ./jaribu.sh       # kikomo cha muda kwa kila jaribio (chaguo-msingi 300 s)
```

| Jaribio | Linakagua |
|---|---|
| `jaribu_vekta.swa` | shughuli zote za vekta, thamani zilizokokotolewa kwa mkono |
| `jaribu_jiometri.swa` | mwale-duara: mbele, kukosa, ndani ya duara, nyuma ya asili, mwelekeo usiosawazishwa |
| `jaribu_mandhari.swa` | kivuli (kituo cha kivuli kwenye sakafu, uso wa mbele/nyuma wa duara), sakafu, duara la karibu, anga, uangazaji wa diffuse (`0.6803`, `0.1512` -- kwa mkono) |
| `jaribu_picha.swa` | picha nzima kwenye kumbukumbu: kichwa na ukubwa wa PPM kwa vipimo 1x1, 8x6, 4096x1, 1x4096, 400x300; **bafa haipitwi** (*canary* ya baiti 16 baada ya mwisho); hoja batili (`0`, hasi) zinarudisha 0; rangi za pikseli maalum (anga, duara tatu, sakafu); rangi tofauti > 1000 (bitmap ya rangi 2²⁴); kuchora mara mbili = baiti sawa; **hash iliyofungwa** ya picha nzima |
| ukaguzi wa mstari-wa-amri (ndani ya `jaribu.sh`) | msimbo wa kutoka 0/1/2 kwa hoja halali na batili, na ukubwa wa faili lililoandikwa |

**Hash iliyofungwa (*golden*).** `jaribu_picha.swa` huhesabu hash ya
baiti zote 360015 za picha ya 400x300 na kuilinganisha na `GOLDEN_HASH`.
Badiliko lolote la pato -- jiometri, hesabu ya `D64`, au mkusanyaji
kubadilisha hesabu ya nukta-desimali -- huonekana hapo. Thamani ya sasa
(`2277982281`) ilithibitishwa kwa hesabu tofauti kabisa (`awk` juu ya PPM ya
kabla ya kupanga upya msimbo). Ukibadilisha mandhari kwa makusudi: endesha
jaribio, likishindwa litaonyesha hash mpya; ihakiki picha kwa macho, kisha
sasisha `GOLDEN_HASH` na `mfano.png` kwenye PR ile ile.

**Kuthibitisha majaribio yenyewe.** Majaribio yamejaribiwa kwa
*mutation testing*: kuvunja msimbo kwa makusudi -- kuzima vivuli, kupuuza
kawaida ya uso, kubadilisha pembe ya kuona (`0.75` -> `0.76` hushindwa kwenye
hash), kupunguza `chora_ukubwa` (hushindwa kwenye canary), kubadilisha msimbo
wa kutoka wa mstari-wa-amri -- hufanya majaribio kushindwa.

CI ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) huendesha yote
dhidi ya `main` ya `lugha-swa/swa` kwa kila push na kila Jumatatu, kugundua
mapema kama mkusanyaji umevunja kitu.

## Mipaka

- **Mandhari moja iliyoandikwa kwenye msimbo.** Hakuna faili la mandhari, wala
  duara/taa zinazoweza kubadilishwa kwa hoja. Kuongeza duara: badilisha
  `IDADI_DUARA`, ukubwa wa `ulimwengu[]`, na `jenga_ulimwengu()` (kisha
  `GOLDEN_HASH`).
- **Vipengele vichache kwa makusudi:** hakuna mwakisiko, mwanga unaopita
  (uwazi), taa nyingi, maumbo mengine ya kijiometri kuliko duara na ndege,
  wala vivuli laini. Taa haipungui kwa umbali.
- **Kasi.** Kifuatilia ni cha nyuzi moja, hakina muundo wa kuharakisha (BVH;
  hauhitajiki kwa duara tatu) na Swa bado ni polepole kuliko C. Picha ya
  1920x1080 kwa sampuli 4 huchukua kama dakika mbili.
- **Ukubwa:** upana/urefu hadi 4096, sampuli hadi 8; ni kikomo cha
  uthibitisho wa hoja, si cha algoriti.
- **Umbizo:** PPM (P6) tu. PNG kwenye `mfano.png` ilitengenezwa nje ya mradi
  kwa `convert` (ImageMagick) kutoka pato la programu; si sehemu ya
  ujenzi wala majaribio.

## Vidokezo kuhusu mkusanyaji wa Swa

Mambo yaliyojitokeza wakati wa kuandika programu hii (yanaweza kubadilika
mkusanyaji unavyoboreshwa; yote yamethibitishwa dhidi ya toleo lililotajwa
chini):

- Wito unaopitisha **miundo kwa thamani** ukiwa ndani ya tawi la `sivyo`
  hushindwa kukusanya ("bafa ya miundo ya wito imejaa"), ingawa wito ule ule
  ndani ya `kama` hufanya kazi. `fuatilia()` hutumia vitalu viwili vya `kama`
  badala ya `kama`/`sivyo` (angalia maoni kwenye `mandhari.swa`).
- Kipengele cha safu ya miundo (`ulimwengu[i]`) hakiwezi kupitishwa moja kwa
  moja kama hoja ya muundo; kinanakiliwa kwanza kwenye kigezo cha ndani.
- Kianzio cha kigezo cha ulimwengu cha `D64` lazima kiwe namba halisi
  (`0.0 - 1.0` haikubaliwi), kwa hiyo `sakafu_y()` ni kazi.
- `N32` ina ishara: kianzio kikubwa kuliko 2³¹ kinasomwa kama hasi, kwa hiyo
  `GOLDEN_HASH` (hadi 2³²) ni `N64`.
- `mfuatano_umbiza` haikubali kielekezi kwa `%s` (hoja zake ni `N64`), kwa hiyo
  kichwa cha PPM hutumia `%d` tu; `andika`/`andika_stderr` zinakubali `%s`.

## Upatanifu

Imejaribiwa dhidi ya `lugha-swa/swa` @ `aa1b87f` (2026-09-18), Linux x86-64.
CI hutumia `main` ya sasa.

## Kuchangia na historia

Angalia [CONTRIBUTING.md](CONTRIBUTING.md) na [CHANGELOG.md](CHANGELOG.md).

## Leseni

MIT -- angalia [LICENSE](LICENSE).
