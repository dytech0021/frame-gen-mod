@echo off
REM Recompila o instalador usando o csc.exe que vem no Windows (.NET Framework 4).
REM Requer "payload.zip" nesta pasta (arquivos do mod compactados: dxgi.dll, OptiScaler.ini,
REM dlssg_to_fsr3..., fakenvapi..., amd_fidelityfx_dx12.dll, OptiPatcher.asi, D3D12_Optiscaler\,
REM Licenses\, FSR4_INT8_4.0.2c\). Esses binarios nao ficam no git (grandes/terceiros).
REM A pasta "DLSS 310.6\" e OPCIONAL: deixe-a FORA do payload.zip para encolher o exe e nao
REM embutir DLLs proprietarios da NVIDIA (a opcao de upgrade de DLSS se desativa sozinha no app).
setlocal
set CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe

echo [1/2] Gerando skull.ico...
"%CSC%" /nologo /target:exe /codepage:65001 /out:MakeIcon.exe /reference:System.Drawing.dll MakeIcon.cs
if errorlevel 1 goto erro
MakeIcon.exe

if not exist payload.zip (
  echo ERRO: payload.zip nao encontrado nesta pasta.
  echo Crie o payload.zip com os arquivos do mod antes de compilar.
  goto erro
)

echo [2/2] Compilando Instalar_Mod.exe (com payload embutido)...
"%CSC%" /nologo /target:winexe /codepage:65001 /optimize+ /win32icon:skull.ico /resource:payload.zip,payload.zip /out:Instalar_Mod.exe ^
  /reference:System.dll /reference:System.Core.dll /reference:System.Drawing.dll ^
  /reference:System.Windows.Forms.dll /reference:System.Web.Extensions.dll ^
  /reference:System.IO.Compression.dll /reference:System.IO.Compression.FileSystem.dll OptiInstaller.cs
if errorlevel 1 goto erro

echo.
echo OK - Instalar_Mod.exe gerado (autossuficiente).
goto fim
:erro
echo.
echo ERRO na compilacao.
:fim
pause
