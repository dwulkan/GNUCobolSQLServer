echo on
::-------------------------------------------------------------
:: esqlOCStart.bat
::-------------------------------------------------------------

::   cd C:\GEOS\EOS\Devel\source     <-because I'm too lazy to type this

SET "OC_RUNTIME=c:\GEOS\GNUCobol\bin"
SET "esqlOC_RUNTIME=c:\GEOS\GNUCobol\esqlOC\x64\release"
ECHO ------Update PATH One Time Only!-----
if "%PATHUPDATED%"=="" set PATH=%OC_RUNTIME%;%esqlOC_RUNTIME%";%PATH%
SET PATHUPDATED=1
set "COB_LIBRARY_PATH=c:\GEOS\GNUCobol\esqlOC\win32\release;%PATH%"
c:\GEOS\EOS\pgmexe\esqlOCStart.exe
