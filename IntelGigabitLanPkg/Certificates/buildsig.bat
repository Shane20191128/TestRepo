@ECHO OFF
@for %%i in (%*) do (
@if exist build\siglist.h @del build\siglist.h
ECHO #define CertSize %%~zi >build\siglist.h
@echo CertSize = %%~zi
@copy %%~piOwnerGuid.h Build\
@%CCX86DIR%\cl /FoBuild\ /nologo /c /D EFI_SPECIFICATION_VERSION=0x2000A /D PI_SPECIFICATION_VERSION=0x00010014 /IMdePkg\Include\x64 /IMdePkg\Include /IAmiCompatibilityPkg\Include\ /IAmiCryptoPkg\Include /I Build  /TC Keys\Variables\Certificates\siglist.c
@%CCX86DIR%\link.exe /OUT:Build\siglist.dll /nologo /NODEFAULTLIB /NOENTRY /DLL /ALIGN:4 /DRIVER Build\siglist.obj
@genfw -o Build\siglist.bin -b Build\siglist.dll
@if exist Build\sig.tmp @del Build\sig.tmp
@if exist Build\sig.dat copy /b Build\sig.dat Build\sig.tmp
@copy /b Build\siglist.bin+%%i+Build\sig.tmp Build\sig.dat
)
