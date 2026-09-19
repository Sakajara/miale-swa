# Historia ya mabadiliko

Muundo unafuata [Keep a Changelog](https://keepachangelog.com/) na
[Semantic Versioning](https://semver.org/).

## [0.2.0] -- 2026-09-19

### Imeongezwa
- Programu ya mstari-wa-amri: `miale [upana urefu [sampuli [faili.ppm]]]`
  yenye uthibitisho wa hoja (nambari za tarakimu 1..9, upana/urefu 1..4096,
  sampuli 1..8) na msimbo wa kutoka 0 / 1 (kuandika) / 2 (hoja).
- `kifuatilia.swa`: kiini cha uchoraji kisicho na `main()` --
  `chora_picha` na `chora_ukubwa` -- kinachoweza kujaribiwa kwenye kumbukumbu.
  Uandishi haupiti kamwe `chora_ukubwa(upana, urefu)`.
- `jaribu_picha.swa`: ukaguzi wa picha nzima kwa Swa safi (vipimo mbalimbali,
  *canary* ya bafa, hoja batili, rangi za pikseli, rangi tofauti, uamuzi,
  hash iliyofungwa ya picha ya 400x300).
- Ukaguzi wa mstari-wa-amri ndani ya `jaribu.sh`; kikomo cha muda kwa kila
  jaribio (`JARIBIO_MUDA`).
- CI ya GitHub Actions dhidi ya `main` ya `lugha-swa/swa` (kila push na kila
  Jumatatu).
- `CONTRIBUTING.md`, `CHANGELOG.md`, na README mpya kamili.

### Limebadilika
- `miale.swa` sasa ni ganda jembamba juu ya `kifuatilia.swa`. Pato la
  chaguo-msingi (400x300, sampuli 2) ni baiti zilezile kama la 0.1.0
  (hash `2277982281`, imethibitishwa kwa hesabu huru).

### Kuondolewa
- `jaribu_picha.sh` (ilitegemea `od`, `sort`, `sed`); nafasi yake imechukuliwa
  na `jaribu_picha.swa`.

## [0.1.0] -- 2026-09-19

Toleo la kwanza: vekta, mwale-duara, mandhari (duara tatu, sakafu ya ubao wa
chesi, taa moja, vivuli, ukungu), antialiasing 2x2, gamma, pato la PPM;
majaribio ya vekta/jiometri/mandhari na ukaguzi wa picha kwa shell; README.
