@echo off
setlocal
echo ==============================================================================
echo  BUILD DELPHI 7 NATIVE: DelphiInsuranceRBAC.exe
echo  Compiler: C:\Delphi7\Borland\Delphi7\Bin\dcc32.exe
echo ==============================================================================

set D7_BIN=C:\Delphi7\Borland\Delphi7\Bin
set D7_LIB=C:\Delphi7\Borland\Delphi7\Lib

if not exist "bin" mkdir "bin"
if not exist "bin\dcu" mkdir "bin\dcu"

REM Compile Resource jika file RC lebih baru atau RES belum ada
if not exist "DelphiInsuranceRBAC.res" (
    echo [*] Mengompilasi DelphiInsuranceRBAC.res...
    "%D7_BIN%\brcc32.exe" "DelphiInsuranceRBAC.rc"
)

echo [*] Mengompilasi Project DelphiInsuranceRBAC.dpr...
"%D7_BIN%\dcc32.exe" -B -W -H -U"%D7_LIB%;%D7_LIB%\Obj;.\src\Data;.\src\Forms;.\src\Utils" -I"%D7_LIB%;%D7_LIB%\Obj;.\src\Data;.\src\Forms;.\src\Utils" -R"%D7_LIB%;%D7_LIB%\Obj;.\src\Data;.\src\Forms;.\src\Utils" -E".\bin" -N".\bin\dcu" DelphiInsuranceRBAC.dpr

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==============================================================================
    echo  [BERHASIL] Kompilasi Delphi 7 Sukses!
    echo  Output Executable: bin\DelphiInsuranceRBAC.exe
    echo ==============================================================================
) else (
    echo.
    echo ==============================================================================
    echo  [GAGAL] Kompilasi Delphi 7 mengalami error. Periksa pesan di atas.
    echo ==============================================================================
    exit /b %ERRORLEVEL%
)

endlocal
