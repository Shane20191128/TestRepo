@ECHO OFF
@if exist build\serialize.h @del build\serialize.h
ECHO #define VarName %1 >>build\serialize.h
ECHO #define Attributes %2 >>build\serialize.h
@%CCX86DIR%\cl /FoBuild\ /nologo /c /Gy /W3 /WX /D EFI_SPECIFICATION_VERSION=0x2000A /D PI_SPECIFICATION_VERSION=0x00010014 /IMdePkg\Include\x64 /IMdePkg\Include /IAmiCompatibilityPkg\Include\ /IAmiCryptoPkg\Include /I Build /TC Keys\Variables\Certificates\serialize.c
@%CCX86DIR%\LINK /OUT:Build\serialize.dll /DLL /SUBSYSTEM:NATIVE /NODEFAULTLIB /NOENTRY Build\serialize.obj
@genfw -o Build\serialize.bin -b Build\serialize.dll
@copy /b Build\serialize.bin+%4 %5
@signtool sign /fd sha256 /p7 Build\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /f %3 /p "%6" %5
