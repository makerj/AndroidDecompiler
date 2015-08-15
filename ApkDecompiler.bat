@echo off
REM --SET VARIABLE -----------------------
SET _root=%~dp0
SET _7zout=%_root%\_7zoutPath
SET _dexout=%_root%\_dexoutPath
SET _CHILD_PROCESS_NAME=AD_Child

REM --START MAIN--------------------------
echo Tool suite is running...
START "AndroidDecompiler" /W %_root%\tools\main.bat %1 %_root%
TASKKILL /FI "WINDOWTITLE eq AndroidDecompiler*"

REM AFTER CLEANING------------------------
echo Now cleaning...
RMDIR /S /Q %_7zout%
RMDIR /S /Q %_dexout%
DEL %_root%\*.src.jar
DEL %_root%\null
CLS

echo Your apk Successfully decompiled seeya!
TIMEOUT 3
EXIT