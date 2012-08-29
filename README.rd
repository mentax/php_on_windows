== KONFIGURACJA SERWERKA == 


=== Czêœæ pierwsza  - symlinki === 

Musimy utworzyæ 2 symlinki. Aby to zrobiæ odpalamy CMD z UPRAWNIENIAMI ADMINISTRATORA
 i wykonujemy 2 komendy: 

1. wewn¹trz katalogu z serwerkiem: 
  mklink /D php .\php-5.4.3-nts-Win32-VC9-x86\
gdzie drugi parametr to aktualnie posiadana, G£ÓWNA wersja PHP

2. na dysku C: 
  mklink /D php D:\Programy\mtxDevServer\  
gdzie drugi parametr to miejsce, gdzie znajduje siê pobrany z GIT serwerek



=== Czêœæ druga  - konfiguracja === 

1. skopiowaæ plik example.localhost.bat => localhost.bat  
2. poprawiæ œcie¿ki w pliku bat
3. Dodaæ do œcie¿ki œrodowiskowej PATH katalog c:\php\php
4. Wykonaæ PHP_ENV.reg

