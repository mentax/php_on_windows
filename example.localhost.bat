@ECHO off
ECHO Hello World!
.\php-5.4.3-nts-Win32-VC9-x86\php.exe -S localhost:80 -t F:\ -c %CD%\php.ini router.php

PAUSE