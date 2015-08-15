::ApkDecompiler - The simplest apk decompiler
::Copyright (C) 2015  Junhui Lee(ohenwkgdj@gmail.com)
::
::This program is free software; you can redistribute it and/or modify
::it under the terms of the GNU General Public License as published by
::the Free Software Foundation; either version 2 of the License, or
::(at your option) any later version.
::
::This program is distributed in the hope that it will be useful,
::but WITHOUT ANY WARRANTY; without even the implied warranty of
::MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::GNU General Public License for more details.
::
::You should have received a copy of the GNU General Public License along
::with this program; if not, write to the Free Software Foundation, Inc.,
::51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
@echo off
IF [%1]==[] (
   echo You must set the parameter1
   TIMEOUT 3
   EXIT
)

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