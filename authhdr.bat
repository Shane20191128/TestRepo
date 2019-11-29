@ECHO OFF
@if exist build\authhdr.h @del build\authhdr.h
ECHO //>build\authhdr.h
@for %%i in (%1) do ECHO #define CertSize %%~zi >build\authhdr.h
@%CCX86DIR%\cl.exe /FoBuild\ /nologo /c /D EFI_SPECIFICATION_VERSION=0x2000A /D PI_SPECIFICATION_VERSION=0x00010014 /IMdePkg\Include\x64 /IMdePkg\Include /IAmiCompatibilityPkg\Include\ /IAmiCryptoPkg\Include /I Build /TC Keys\Variables\Certificates\authhdr.c
@%CCX86DIR%\link.exe /OUT:Build\authhdr.dll /nologo /NODEFAULTLIB /NOENTRY /DLL /ALIGN:4 /DRIVER Build\authhdr.obj
@genfw -o Build\authhdr.bin -b Build\authhdr.dll
@copy /b Build\authhdr.bin+%1 Build\authhdr.bin
