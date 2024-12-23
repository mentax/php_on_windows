@ECHO off
ECHO zmiana wersji php 8.1 - 8.2 - 8.3

set /p Ver=<version.txt

ECHO Poprzednia wersja PHP bylo %Ver%
ECHO:

IF %Ver%==84 goto :PHP84
IF %Ver%==83 goto :PHP83
IF %Ver%==82 goto :PHP82
IF %Ver%==81 goto :PHP81


:PHP81
    REN php php81
    REN php82 php

    echo 82 > version.txt
    goto :FINISH

:PHP82
    REN php php82
    REN php83 php

    echo 83 > version.txt
    goto :FINISH

:PHP83
    REN php php83
    REN php84 php

    echo 84 > version.txt
    goto :FINISH

:PHP84
    REN php php84
    REN php81 php

    echo 81 > version.txt
    goto :FINISH


:FINISH

ECHO Aktualna wersja PHP TO:

php -v

PAUSE