@ECHO off
ECHO Hello World!
.\php\php.exe -S localhost:80 -t F:\ -c %CD%\php.ini router.php

PAUSE