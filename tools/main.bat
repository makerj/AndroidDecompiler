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
echo **************************************************
echo Apk Decompiler "Simplest Apk decompiler"
echo Copyright (c) 2015 Junhui Lee(ohenwkgdj@gmail.com)
echo **************************************************
echo.

REM --SET VARIABLE -----------------------
SET _root=%2
SET _7zout=%_root%\_7zoutPath
SET _dexout=%_root%\_dexoutPath
SET _CHILD_PROCESS_NAME=AD_Child

SET _returnPos=0
SET _arg0=0
SET _arg1=0

REM --SET EXECUTABLE PATH ----------------
SET _dex2jar=%_root%\tools\dex2jar-2.0\d2j-dex2jar.bat
SET _jd=%_root%\tools\jd-cli-0.9.1.Final-dist\jd-cli.bat
IF EXIST "%PROGRAMFILES(X86)%" (
   SET _7z=%_root%\tools\7z\7-Zip64\7z.exe
) ELSE (
   SET _7z=%_root%\tools\7z\7-Zip\7z.exe
)
IF NOT EXIST "%_7zout%" mkdir %_7zout%
IF NOT EXIST "%_dexout%" mkdir %_dexout%

REM --Validate variables -----------------
IF [%1]==[] (
   GOTO ERROR
)

REM --Start Commands ---------------------

   REM --Step1: extract apk---------------
      echo Extracting apk archive...
      %_7z% x -y -o"%_7zout%" %1
      echo.

   REM --Step2: convert dex to jar--------
      echo Converting dex to jar...
      CD %_dexout%   
      SET _returnPos=STEP2_DONE
      SET _arg0=%_dexout%\classes-dex2jar.jar
      SET _arg1=STEP2
      START /B "%_CHILD_PROCESS_NAME%%_arg1%" /B %_dex2jar% --force %_7zout%\classes.dex
      GOTO HANDLE_OUTPUT
      :STEP2_DONE
   
      CD %_root%
      echo.

   REM --Step3: decompile jar to java classes----
      echo Decompiling jar to java...
      SET _returnPos=STEP3_DONE
      SET _arg0=%_root%\classes-dex2jar.src.jar
      SET _arg1=STEP3
      START "%_CHILD_PROCESS_NAME%%_arg1%" /B %_jd% %_dexout%\classes-dex2jar.jar
      GOTO HANDLE_OUTPUT
      :STEP3_DONE
      REN %_root%\classes-dex2jar.src.jar done.zip
      echo.

REM --Exit -------------------------------
CLS
echo End of main







REM --------------------------------HANDLE_OUTPUT
:HANDLE_OUTPUT
   SET /a __tryCount=0
   SET /a _FIVE=5
   :__HANDLE_OUTPUT
      SET /a __tryCount+=1
      TIMEOUT 5 >nul
   REM TRY OUT--------------------------------------
      IF %__tryCount% EQU %_FIVE% GOTO ERROR
   REM FILE EXIST CHECK LOOP------------------------
      IF NOT EXIST %_arg0% GOTO __HANDLE_OUTPUT
   GOTO %_returnPos%
REM --------------------------------HANDLE_OUTPUT










:ERROR
echo Welcome to ERORR world