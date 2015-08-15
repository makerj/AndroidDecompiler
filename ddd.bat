@echo off

echo **************************************************
echo ApkDDD "Simplest Apk decompiler"
echo Copyright (c) 2015 Junhui Lee(ohenwkgdj@gmail.com)
echo **************************************************
echo.

REM --SET VARIABLE -----------------------
SET _root=%CD%
SET _7zout=%_root%\_7zoutPath
SET _dexout=%_root%\_dexoutPath
SET _childName=AD_Child

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
IF [%0]==[] (
   GOTO ERROR
)

REM --Start Commands ---------------------

   REM --Step1: extract apk---------------
      echo Extracting apk archive...
      echo %_7z% x -y -o"%_7zout%" %1
      echo.

   REM --Step2: convert dex to jar--------
      echo Converting dex to jar...
      CD %_dexout%
      START "%_childName%" %_dex2jar% --force %_7zout%\classes.dex
   
      SET _returnPos=STEP2_DONE
      SET _arg0=%_dexout%\classes-dex2jar.jar
      GOTO HANDLE_OUTPUT
      :STEP2_DONE
   
      CD %_root%
      echo.

   REM --Step3: decompile jar to java classes----
      echo Decompiling jar to java...
      START "%_childName%" %_jd% %_dexout%\classes-dex2jar.jar
      
      SET _returnPos=STEP3_DONE
      SET _arg0=%_root%\classes-dex2jar.src.jar
      GOTO HANDLE_OUTPUT
      :STEP3_DONE
   
      REN %_root%\classes-dex2jar.src.jar done.zip
      echo.

REM --Exit -------------------------------
SET done="DONE"










:HANDLE_OUTPUT
TIMEOUT 1 >nul
IF NOT EXIST "%_arg0" GOTO HANDLE_OUTPUT
TASKKILL /FI "WINDOWTITLE EQ %_childName%"
GOTO %_returnPos%













