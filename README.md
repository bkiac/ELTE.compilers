# A beadandóhoz használandó programozási nyelv leírása (Abap, 2018 tavasz)

A félév során az alábbi programozási nyelvhez kell fordítóprogramot írni ```flex``` és ```bisonc++``` segítségével.

A nyelv az ABAP egyszerűsített változata.

Az alábbi példaprogram a bemenetről logikai értékeket és egészeket olvas felváltva. Az egészek közül a 10 és 100 közöttieket összeadja, amíg először hamis értéket nem kap a bemeneten. Az összeget kiírja a kimenetre.

```
* Osszegzes
PROGRAM osszeg.
DATA:
  i TYPE I,
  s TYPE I,
  more TYPE B.
MOVE 0 TO s.
READ TO more.
WHILE more.
  READ TO i.
  IF i> 10 AND i < 100.
    ADD i TO s.
  ENDIF.
  READ TO more.
ENDWHILE.
WRITE s.
```

# A nyelv definíciója

## Karakterek

A forrásfájlok a következő ASCII karaktereket tartalmazhatják:
  * az angol abc kis és nagybetűi
  * számjegyek (0-9)
  * ```():<>=,.```
  * szóköz, tab, sorvége 

Minden más karakter esetén hibajelzést kell adnia a fordítónak, kivéve megjegyzések belsejében, mert ott tetszőleges karakter megengedett. Az ABAP-pal ellentétben ebben a nyelvben számítanak a kis és nagybetűk.


## Azonosítók

A változók nevei, illetve a program neve az angol ábécé kisbetűiből, nagybetűiből és számjegyekből állhatnak, és betűvel kell kezdődniük.

## Típusok

  * ```I```: négy bájtos, előjel nélküli egészként kell megvalósítani; literáljai számjegyekből állnak és nincs előttük előjel
  * ```B```: egy bájton kell ábrázolni, literáljai a ```FALSE``` és a ```TRUE```

## Megjegyzések

A sor elején álló ```*``` karakterektől kezdve a sor végéig. Megjegyzések a program tetszőleges sorában előfordulhatnak (de csak a sor elején). A fordítást és a keletkező programkódot nem befolyásolják.

## A program felépítése

A program szignatúrából, deklarációs részből és törzsből. A szignatúra tartalma: ```PROGRAM``` név ```.```, ahol a név tetszőleges azonosító. A deklarációs részt ```DATA:``` vezeti be. A deklarációs rész nem kötelező, de ha van, akkor legalább egy változódeklarációt tartalamaz. A törzs utasításokat tartalamaz, de lehet üres is.

## Változódeklarációk

Minden változót név ```TYPE``` típus alakban, egy vesszőkkel elválasztott listában kell deklarálni, minden változóhoz külön feltüntetve a típusát

## Kifejezések

  * ```I``` típusú kifejezések: számliterálok, ```I``` típusú változók.
  * ```B``` típusú kifejezések: ```TRUE``` és ```FALSE```, ```B``` típusú változók, két ```I``` típusú kifejezésből az ```=``` (egyenlőség), ```<``` (kisebb), ```>``` (nagyobb) infix operátorral, valamint az ezekből ```AND``` (konjunkció), ```OR``` (diszjunkció) infix és a ```NOT``` (negáció) prefix operátorral és zárójelekkel felépített kifejezések.
  * Az infix operátorok mind balasszociatívak és a precedenciájuk növevő sorrendben a következő:
    * ```OR```
    * ```AND```
    * ```=```
    * ```<``` ```>```

## Utasítások
 
  * Értékadás: ```MOVE``` kifejezés ```TO``` változó ```.``` alakú. A változó és a kifejezés típusa csak azonos lehet.
  * Olvasás: A ```READ``` ```TO``` változó ```.``` utasítás a megadott változóba olvas be egy megfelelő típusú értéket a standard bemenetről. (Megvalósítása: meg kell hívni a be eljárást, amit a 4. beadandó feladathoz mellékelt C fájl tartalmaz. A beolvasott érték az eax (logikai típus esetén az al) regiszterben lesz.)
  * Írás: A ```WRITE``` utasítás ```.``` a megadott kifejezés értékét a képernyőre írja (és egy sortöréssel fejezi be). (Megvalósítása: meg kell hívni a ki eljárást, amit a 4. beadandó feladathoz mellékelt C fájl tartalmaz. Paraméterként a kiírandó értéket (mindkét esetben 4 bájtot) kell a verembe tenni.)
  * Aritmetika:
    * ```ADD``` kifejezés ```TO``` változó ```.```
    * ```SUBTRACT``` kifejezés ```FROM``` változó ```.```
    * ```MULTIPLY``` változó ```BY``` kifejezés ```.```
    * ```DIVIDE``` változó ```BY``` kifejezés ```.```
  * Ciklus: ```WHILE``` feltétel ```.``` utasítások ```ENDWHILE``` ```.```
    * A feltétel logikai kifejezés, és a ciklus belsejében legalább egy utasításnak kell lennie. A megszokott módon, elöltesztelős ciklusként működik.
  * Elágazás:
    * ```IF``` feltétel ```.``` utasítások ```ENDIF``` ```.```
    * ```IF``` feltétel ```.``` utasítások ```ELSE``` ```.``` utasitasok ```ENDIF``` ```.```
    * ```IF``` feltétel ```.``` utasítások ```ELSEIF``` feltétel ```.``` utasitasok ... ```ENDIF``` ```.```
    * A feltétel logikai kifejezés, és az egyes ágakban legalább egy-egy utasítás van. Az ```IF``` ágból pontosan egy van, ami az első ág. ```ELSEIF``` ágból akárhány lehet. Az ```ELSE``` ág nem kötelező, legfeljebb egy lehet belőle, és ha van, akkor az az utolsó ág. A megszokott módon működik.
