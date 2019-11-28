@echo ----run FWBUILD to build rom map file for this BIOS image
@echo FWBUILD Build\Kabylake\RELEASE_MYTOOLS\FV\AMIROM.fd -s -m Build\RomLayoutEx.bin
@echo ----sign BIOS image using external rom map
AmiCryptoPkg\Utils\CryptoCon -r Build\RomLayoutEx.bin -y -n -c ZOEMPkg\Doc\SecureBootKeys\M16_pri_B250.bin -k ZOEMPkg\Doc\SecureBootKeys\M16_pri_B250.bin -q -f Build\Kabylake\RELEASE_MYTOOLS\FV\AMIROM.fd -o IMAGEM16.rom
