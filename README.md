mtxDevServer
============

php 5.5 + xdebug


== KONFIGURACJA SERWERKA ==


=== Część pierwsza  - symlinki ===

Musimy utworzyć 2 symlinki. Aby to zrobić odpalamy CMD z UPRAWNIENIAMI ADMINISTRATORA
 i wykonujemy 2 komendy:

1. wewnątrz katalogu z serwerkiem:
  mklink /D php .\php-5.6.29-Win32-VC11-x86\
gdzie drugi parametr to aktualnie posiadana, Główna wersja PHP

2. na dysku C: 
  mklink /D php D:\Programy\mtxDevServer\  
gdzie drugi parametr to miejsce, gdzie znajduje się pobrany z GIT serwerek


3. Uruchomoenie Composera
Przechodzimy do katalogu
	~/AppData/Roaming/
np.
	 C:/Users/Dawid/AppData/Roaming/

 mklink /D Composer D:\Programy\mtxDevServer\Composer  


=== Część druga  - konfiguracja ===

1. skopiować plik example.localhost.bat => localhost.bat  
2. poprawić ścieżki w pliku bat
3. Dodać do ścieżki środowiskowej PATH katalog c:\php\php;c:\php\bat;c:\php\Composer\vendor\bin
4. Wykonać PHP_ENV.reg
