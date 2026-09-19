# Kuchangia kwenye miale-swa

Karibu! Mradi huu ni kifuatilia-miale kilichoandikwa kwa **Swa safi**. Kanuni
tatu zinaongoza kila badiliko:

1. **Swa safi.** Msimbo, majaribio na mifano ni Swa -- hakuna Python, C, wala
   utegemezi wa libc. Script za `bash` (`jenga.sh`, `jaribu.sh`) ni gundi ya
   kujenga na kuendesha tu; mantiki ya majaribio iandikwe kama jaribio la
   Swa (`jaribu_*.swa`). Picha ya PNG kwenye README ndiyo pekee iliyotengenezwa
   nje ya mradi (angalia README, "Mipaka").
2. **Kila badiliko lina jaribio.** Marekebisho ya mdudu huanza na jaribio
   linalofeli, kisha suluhisho. Thamani za jaribio zikokotolewe kwa mkono kutoka
   jiometri, si kutoka pato la msimbo wako.
3. **Uaminifu.** Dai lolote kwenye README (kasi, mipaka, vipimo) liwe
   limepimwa; usiliandike kwa kukisia.

## Mazingira

Linux x86-64, `bash`, na hazina ya
[lugha-swa/swa](https://github.com/lugha-swa/swa) (chaguo-msingi
`~/Projects/compilers/swa`, au `SWA_DIR=/njia`).

```sh
./jaribu.sh                      # yote -- lazima yapite
./jaribu.sh jaribu_picha.swa     # jaribio moja
```

## Kabla ya kutuma PR

- [ ] `./jaribu.sh` inapita.
- [ ] Ukibadilisha pato la picha kwa makusudi (mandhari, kamera, gamma):
      angalia picha kwa macho, sasisha `GOLDEN_HASH` kwenye
      `jaribu_picha.swa` (jaribio lililoshindwa linaonyesha thamani mpya) na
      `mfano.png` (`convert miale.ppm mfano.png`) kwenye PR ile ile, na
      eleza sababu kwenye maelezo ya PR.
- [ ] Ukigusa `kifuatilia.swa`: hakikisha `chora_ukubwa` bado inatosha
      (majaribio ya canary yatashindwa vinginevyo).
- [ ] Ukigusa mstari-wa-amri: ongeza kesi kwenye sehemu ya "mstari-wa-amri" ya
      `jaribu.sh`.
- [ ] Ujumbe wa commit kwa Kiswahili, wenye aina: `ongeza:`, `rekebisha:`,
      `jaribio:`, `panga upya:` (angalia `git log`).
- [ ] Hakuna faili la lugha nyingine; hakuna alama za AI kwenye commit/PR.

## Kuripoti mdudu

Toa: amri kamili uliyoendesha, matokeo uliyotarajia, matokeo uliyopata, na
toleo la mkusanyaji (`git -C $SWA_DIR log -1 --oneline`). Kwa makosa ya
picha, ambatisha hoja na hash ya `jaribu_picha.swa`.

## Mtindo

- Maoni kwa Kiswahili; eleza *kwa nini*, si *nini*.
- Kila njia ya kushindwa irudishe msimbo/`0` -- usiache kuanguka kwa hoja
  yoyote ya mtumiaji.
- Kumbuka mipaka ya mkusanyaji iliyoorodheshwa kwenye README (miundo kwa
  thamani ndani ya `sivyo`, n.k.).
