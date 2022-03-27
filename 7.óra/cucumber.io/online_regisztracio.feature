Jellemző: Online regisztráció során a felhasználónak minden előfeltételt teljesítenie kell, hogy tag lehessen

    Háttér:
        Amennyiben az online regisztrációs oldalon vagyok

    Forgatókönyv: Létező érényes tagsággal nem lehet regisztrálni
        Amikor egy már létező tag adatait adom meg minden mezőbe
        És a tag tagsága még nem járt le
        És elküldöm a regisztrációs űrlapot
        Akkor az oldal hibaüzenettel tér vissza a létező tagságról

    Forgatókönyv vázlat: Minden kötelező mező hibával tér vissza, ha nincs kitöltve
        Amikor minden kötelező mezőt kitöltök
        És nem rendelkezek érvényes tagsággal
        És törlöm a "<mező>" tartalmát
        És elküldöm a regisztrációs űrlapot
        Akkor az oldal a "<hiba>" hibaüzenettel tér vissza

        Példák:
        | mező           | hiba                   |
        | nev            | hianyzo_nev            |
        | szuletesi_nev  | hianyzo_szuletesi_nev  |
        | anyja_neve     | hianyzo_anyja_neve     |
        | szuletesi_hely | hianyzo_szuletesi_hely |
        | szuletesi_ido  | hianyzo_szuletesi_ido  |
        | lakcim         | hianyzo_lakcim         |
        | email_cim      | hianyzo_email_cim      |

    Forgatókönyv vázlat: Érvényes adatok és még nem létező tagáság estén a regisztáció sikeres
        Amikor minden kötelező mezőt kitöltök
        És nem rendelkezek érvényes tagsággal
        És elküldöm a regisztrációs űrlapot
        Akkor az adataim rögzítésre kerülnek az adatbázisban
        És rögzítésre kerül az egyedi azonosításra alkalmas vonlkódom