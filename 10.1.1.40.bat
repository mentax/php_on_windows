@ECHO off
ECHO Hello World!
.\php\php.exe -S 10.1.1.40:80 -t F:\ -c %CD%\php.ini router.php

PAUSE