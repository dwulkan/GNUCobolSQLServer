echo on
::-------------------------------------------------------------
:: esqlOCStart.bat
::-------------------------------------------------------------

::   cd C:\EOS\source     <-because I'm too lazy to type this

SET "OC_RUNTIME=c:\EOS\GNUCobol\bin"
SET "esqlOC_RUNTIME=c:\EOS\GNUCobol\esqlOC\x64\release"
ECHO ------Update PATH One Time Only!-----
if "%PATHUPDATED%"=="" set PATH=%OC_RUNTIME%;%esqlOC_RUNTIME%";%PATH%
SET PATHUPDATED=1
set "COB_LIBRARY_PATH=c:\EOS\GNUCobol\esqlOC\win32\release;%PATH%"
c:\EOS\EOS\pgmexe\esqlOCStar.exe
