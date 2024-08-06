echo on

::   cd C:\GEOS\EOS\Devel\source

SET "OC_RUNTIME=c:\GEOS\GNUCobol\bin"
SET "esqlOC_RUNTIME=c:\GEOS\GNUCobol\esqlOC\x64\release"
set "PATH=%OC_RUNTIME%;%esqlOC_RUNTIME%";%PATH%
set "COB_LIBRARY_PATH=c:\GEOS\GNUCobol\esqlOC\win32\release;%PATH%"
c:\GEOS\EOS\pgmexe\esqlOCStart.exe