@echo off
setlocal enabledelayedexpansion

REM --- Konfiguracja ---
REM Nazwa katalogu reprezentującego aktywną wersję
set "ACTIVE_DIR_NAME=php"
REM Lista dostępnych przyrostków wersji (oddzielone spacją)
set "VERSIONS=81 82 83 84"
REM Prefiks nazw katalogów wersji (np. "php" dla "php81")
set "PREFIX=php"
REM Nazwa pliku przechowującego aktywną wersję
set "VERSION_FILE=version.txt"
REM --- Koniec Konfiguracji ---

echo =======================================================
echo  Przelacznik wersji PHP (przez zmiane nazw katalogow)
echo =======================================================
echo.
ECHO DEBUG: Rozpoczeto skrypt.

REM --- Sprawdzenie obecnej wersji z pliku ---
set "CURRENT_VERSION_SUFFIX="
ECHO DEBUG: Aktualny katalog roboczy: %CD%
ECHO DEBUG: Pelna sciezka sprawdzanego pliku: %CD%\%VERSION_FILE%
ECHO DEBUG: Sprawdzanie istnienia pliku '%VERSION_FILE%'...
if not exist "%VERSION_FILE%" (
    ECHO DEBUG: Plik '%VERSION_FILE%' nie istnieje wg sprawdzenia 'if not exist'. Przejscie do EndScript.
    echo Blad: Nie znaleziono pliku '%VERSION_FILE%'.
    echo Sprawdz, czy plik istnieje w katalogu: %CD%
    echo Upewnij sie, ze nazwa to dokladnie '%VERSION_FILE%'.
    REM Poprawiono linie ponizej - dodano ^ przed nawiasami
    echo Utworz plik '%VERSION_FILE%' i wpisz do niego numer aktualnie aktywnej wersji ^(np. 81^),
    echo ktora znajduje sie w katalogu o nazwie '%ACTIVE_DIR_NAME%'.
    goto :EndScript
)

ECHO DEBUG: Plik '%VERSION_FILE%' istnieje. Proba odczytu...
set /p CURRENT_VERSION_SUFFIX=<"%VERSION_FILE%"
ECHO DEBUG: Odczytano z pliku (surowo): "!CURRENT_VERSION_SUFFIX!"

REM *** NOWA LINIA: Proba usuniecia cudzyslowow z poczatku i konca ***
set CURRENT_VERSION_SUFFIX=%CURRENT_VERSION_SUFFIX:"=%
ECHO DEBUG: Wartosc po usunieciu cudzyslowow: "!CURRENT_VERSION_SUFFIX!"

if not defined CURRENT_VERSION_SUFFIX (
    ECHO DEBUG: Zmienna CURRENT_VERSION_SUFFIX nie jest zdefiniowana (plik pusty?). Przejscie do EndScript.
    echo Blad: Plik '%VERSION_FILE%' jest pusty.
    echo Wpisz do niego numer aktualnie aktywnej wersji ^(np. 81^).
    goto :EndScript
)
ECHO DEBUG: Zmienna CURRENT_VERSION_SUFFIX zdefiniowana: %CURRENT_VERSION_SUFFIX%

REM Walidacja odczytanej wersji
set "VALID_CURRENT=0"
ECHO DEBUG: Rozpoczynanie walidacji odczytanej wersji '%CURRENT_VERSION_SUFFIX%'...
for %%v in (%VERSIONS%) do (
    ECHO DEBUG: Porownanie '%CURRENT_VERSION_SUFFIX%' z '%%v'
    if /I "%%v"=="%CURRENT_VERSION_SUFFIX%" (
        ECHO DEBUG: Znaleziono dopasowanie. Ustawianie VALID_CURRENT=1.
        set "VALID_CURRENT=1"
    )
)
ECHO DEBUG: Zakonczono petle walidacji. Wartosc VALID_CURRENT: %VALID_CURRENT%

if "%VALID_CURRENT%"=="0" (
     ECHO DEBUG: Odczytana wersja nieprawidlowa. Przejscie do EndScript.
     echo Blad: Wersja '%CURRENT_VERSION_SUFFIX%' odczytana z pliku '%VERSION_FILE%' jest nieprawidlowa.
     echo Oczekiwano jednej z: %VERSIONS%. Popraw plik '%VERSION_FILE%'.
     goto :EndScript
)

ECHO DEBUG: Wersja z pliku poprawna.
echo Odczytano z pliku '%VERSION_FILE%': Aktualnie aktywna wersja to %CURRENT_VERSION_SUFFIX% (katalog '%ACTIVE_DIR_NAME%')
echo.

REM --- Wybór wersji docelowej ---
set "TARGET_VERSION_SUFFIX="
set "INPUT_VERSION=%~1" REM Pobranie pierwszego argumentu linii komend
ECHO DEBUG: Sprawdzanie argumentu linii komend: '%INPUT_VERSION%'

if defined INPUT_VERSION (
    ECHO DEBUG: Argument linii komend istnieje: '%INPUT_VERSION%'. Walidacja...
    REM Użycie wersji z argumentu
    set "VALID_ARG=0"
    for %%v in (%VERSIONS%) do (
        if /I "%%v"=="%INPUT_VERSION%" (
            set "TARGET_VERSION_SUFFIX=%%v"
            set "VALID_ARG=1"
            ECHO DEBUG: Argument '%INPUT_VERSION%' jest poprawny. Ustawiono TARGET_VERSION_SUFFIX.
            goto :VersionFromArgFound
        )
    )
    :VersionFromArgFound
    if "%VALID_ARG%"=="0" (
        ECHO DEBUG: Argument '%INPUT_VERSION%' jest niepoprawny. Przejscie do EndScript.
        echo Blad: Nieprawidlowy numer wersji podany jako argument: '%INPUT_VERSION%'.
        echo Dostepne wersje: %VERSIONS%
        goto :EndScript
    )
    echo Wybrano wersje z argumentu linii komend: %TARGET_VERSION_SUFFIX%
    echo.
) else (
    ECHO DEBUG: Brak argumentu linii komend. Wyswietlanie menu.
    REM Wyświetlenie menu wyboru
    echo Wybierz wersje PHP do aktywacji:
    set "INDEX=1"
    set "CHOICES="
    for %%v in (%VERSIONS%) do (
        echo   !INDEX!. %PREFIX%%%v
        set "CHOICES=!CHOICES! !INDEX!"
        set "VERSION_!INDEX!=%%v"
        set /a INDEX+=1
    )
    echo.

    :GetChoiceLoop
    ECHO DEBUG: Oczekiwanie na wybor uzytkownika...
    set "CHOICE="
    set /p CHOICE="Wpisz numer wybranej wersji i nacisnij Enter: "
    ECHO DEBUG: Uzytkownik wybral: '%CHOICE%'

    REM Walidacja wyboru
    set "VALID_CHOICE=0"
    for %%c in (%CHOICES%) do (
        if "%%c"=="!CHOICE!" (
            set "VALID_CHOICE=1"
            set "TARGET_VERSION_SUFFIX=!VERSION_%CHOICE%!"
            ECHO DEBUG: Wybor z menu poprawny. Ustawiono TARGET_VERSION_SUFFIX: !TARGET_VERSION_SUFFIX!
            goto :ChoiceValidated
        )
    )

    ECHO DEBUG: Nieprawidlowy wybor z menu. Ponowienie petli.
    echo Nieprawidlowy wybor '%CHOICE%'. Sprobuj ponownie.
    goto :GetChoiceLoop

    :ChoiceValidated
    echo Wybrano wersje z menu: %TARGET_VERSION_SUFFIX%
    echo.
)

ECHO DEBUG: Wersja docelowa: %TARGET_VERSION_SUFFIX%. Przechodzenie do zmiany nazw.
REM --- Ustawianie nowej wersji przez zmianę nazw ---
set "TARGET_DIR_INACTIVE=%PREFIX%%TARGET_VERSION_SUFFIX%"
set "CURRENT_DIR_INACTIVE=%PREFIX%%CURRENT_VERSION_SUFFIX%"

REM Sprawdzenie, czy wybrana wersja jest już aktywna
ECHO DEBUG: Sprawdzanie czy TARGET (%TARGET_VERSION_SUFFIX%) jest taki sam jak CURRENT (%CURRENT_VERSION_SUFFIX%)...
if /I "%TARGET_VERSION_SUFFIX%"=="%CURRENT_VERSION_SUFFIX%" (
    ECHO DEBUG: Wersja juz aktywna. Przejscie do EndScript.
    echo Wersja %TARGET_VERSION_SUFFIX% jest juz aktywna (katalog '%ACTIVE_DIR_NAME%'). Nie wprowadzono zadnych zmian.
    goto :EndScript
)

REM Sprawdzenie, czy wymagane katalogi istnieją
ECHO DEBUG: Sprawdzanie istnienia katalogu '%ACTIVE_DIR_NAME%'...
if not exist "%ACTIVE_DIR_NAME%\" (
    ECHO DEBUG: Katalog '%ACTIVE_DIR_NAME%' nie istnieje. Przejscie do EndScript.
    echo Blad: Oczekiwany aktywny katalog '%ACTIVE_DIR_NAME%' nie istnieje!
    echo Sprawdz stan katalogow i zawartosc pliku '%VERSION_FILE%'.
    goto :EndScript
)
ECHO DEBUG: Sprawdzanie istnienia katalogu '%TARGET_DIR_INACTIVE%'...
if not exist "%TARGET_DIR_INACTIVE%\" (
    ECHO DEBUG: Katalog '%TARGET_DIR_INACTIVE%' nie istnieje. Przejscie do EndScript.
    echo Blad: Katalog docelowy '%TARGET_DIR_INACTIVE%' nie istnieje!
    echo Upewnij sie, ze katalog dla wybranej wersji PHP istnieje.
    goto :EndScript
)

ECHO DEBUG: Rozpoczynanie zmiany nazw katalogow.
echo Proba zmiany nazw katalogow:
echo   1. Zmiana nazwy '%ACTIVE_DIR_NAME%' na '%CURRENT_DIR_INACTIVE%'
echo   2. Zmiana nazwy '%TARGET_DIR_INACTIVE%' na '%ACTIVE_DIR_NAME%'
echo.

REM Krok 1: Zmiana nazwy aktywnego katalogu na jego nieaktywną nazwę
ECHO DEBUG: Wykonywanie: ren "%ACTIVE_DIR_NAME%" "%CURRENT_DIR_INACTIVE%"
ren "%ACTIVE_DIR_NAME%" "%CURRENT_DIR_INACTIVE%"
if errorlevel 1 (
    ECHO DEBUG: Blad podczas kroku 1 (ren %ACTIVE_DIR_NAME%). Przejscie do EndScript.
    echo Blad: Nie udalo sie zmienic nazwy '%ACTIVE_DIR_NAME%' na '%CURRENT_DIR_INACTIVE%'.
    echo Sprawdz, czy katalog nie jest uzywany przez inny program.
    goto :EndScript
) else (
    ECHO DEBUG: Krok 1 zakonczony pomyslnie.
    echo   - Krok 1 zakonczony pomyslnie.
)

REM Krok 2: Zmiana nazwy docelowego katalogu na aktywną nazwę
ECHO DEBUG: Wykonywanie: ren "%TARGET_DIR_INACTIVE%" "%ACTIVE_DIR_NAME%"
ren "%TARGET_DIR_INACTIVE%" "%ACTIVE_DIR_NAME%"
if errorlevel 1 (
    ECHO DEBUG: Blad podczas kroku 2 (ren %TARGET_DIR_INACTIVE%). Proba przywrocenia.
    echo Blad: Nie udalo sie zmienic nazwy '%TARGET_DIR_INACTIVE%' na '%ACTIVE_DIR_NAME%'.
    echo Sprawdz, czy katalog nie jest uzywany przez inny program.
    echo UWAGA: Stan katalogow moze byc niespojny!
    echo Proba przywrocenia poprzedniej nazwy...
    ECHO DEBUG: Proba przywrocenia: ren "%CURRENT_DIR_INACTIVE%" "%ACTIVE_DIR_NAME%"
    ren "%CURRENT_DIR_INACTIVE%" "%ACTIVE_DIR_NAME%"
    if errorlevel 1 (
       ECHO DEBUG: Blad krytyczny podczas przywracania. Przejscie do EndScript.
       echo Blad krytyczny: Nie udalo sie nawet przywrocic nazwy '%ACTIVE_DIR_NAME%'. Wymagana reczna interwencja!
    ) else (
       ECHO DEBUG: Przywracanie udane. Przejscie do EndScript.
       echo Przywrocono nazwe '%ACTIVE_DIR_NAME%'. Poprzednia wersja (%CURRENT_VERSION_SUFFIX%) powinna byc nadal aktywna.
    )
    goto :EndScript
) else (
     ECHO DEBUG: Krok 2 zakonczony pomyslnie.
     echo   - Krok 2 zakonczony pomyslnie.
)

REM Krok 3: Aktualizacja pliku wersji
ECHO DEBUG: Aktualizacja pliku '%VERSION_FILE%' wartoscia '%TARGET_VERSION_SUFFIX%'...
echo %TARGET_VERSION_SUFFIX%>"%VERSION_FILE%"
if errorlevel 1 (
    ECHO DEBUG: Blad podczas aktualizacji pliku '%VERSION_FILE%'.
    echo Ostrzezenie: Nie udalo sie zaktualizowac pliku '%VERSION_FILE%'.
    echo Recznie wpisz '%TARGET_VERSION_SUFFIX%' do pliku '%VERSION_FILE%', aby zachowac spojny stan.
) else (
    ECHO DEBUG: Plik '%VERSION_FILE%' zaktualizowany.
    echo   - Plik '%VERSION_FILE%' zaktualizowany.
)


echo.
echo ===================================
echo SUKCES!
echo ===================================
echo Poprzednia wersja: %CURRENT_VERSION_SUFFIX%
echo Nowa aktywna wersja: %TARGET_VERSION_SUFFIX% (katalog '%ACTIVE_DIR_NAME%' zawiera teraz te wersje)
echo ===================================


:EndScript
ECHO DEBUG: Dotarto do etykiety EndScript.
echo.
pause
endlocal
ECHO DEBUG: Koniec skryptu.
exit /b %errorlevel%
