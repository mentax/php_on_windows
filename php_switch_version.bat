@ECHO off
ECHO zmiana wersji php 8.1 - 8.2

IF exist php82 ( ren php php81 && ren php82 php ) ELSE ( ren php php82 && ren php81 php )

ECHO Aktualna wersja PHP TO:

php -v

PAUSE