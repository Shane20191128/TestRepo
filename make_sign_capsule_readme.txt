=============================================================
=== EXAMPLE OF SIGNING APTIO FW IMAGE USING CRYPTOCON.EXE ===
=============================================================
1. Use Aptio FW image 'AMIROM.fd' created on
    06/14/2016 at 20:25:00 and including:
    a)Platform Key ffs with a public key to verify signed BIOS updates;
    b)FwCapsule Hdr ffs populated with Capsule signing parameters:
      -m -r RomLayoutEx.bin -c M16_pri_B250.bin -k M16_pri_B250.bin -q

2. Provide 2048bit RSA Key file in PKCS#1v2.1 DER (PEM)format.
    Root Key Certificate key (full RSA key)  - M16_pri_B250.bin
    Signing Certificate key (full RSA key) - M16_pri_B250.bin
    Signing Certificate key (public key part) - M16_pub_B250.bin

=============================================================
=== Run Cryptocon.exe script to generate Signed FwCapsule
=============================================================

 CryptoCon -y -n -c M16_pri_B250.bin -k M16_pri_B250.bin -q -f file_in -o file_out

=============================================================
=== Common Cryptocon FwCapsule build instructions 
=============================================================
 -c'FWrootPriv' -k'FWsignPriv' Create PKCS#1v1.5 signed FwCapsule (Note1)
 -c2 -x 'FWpriv'[,'pswd']      Create PKCS#7 signed FwCapsule (Note2, Note3)
 -f'file' input, un-signed BIOS image
 -o'file' output, signed FwCapsule image
 -y update an embedded FwCapsule Header, default-Hdr attached on top of BIOS
 -l'value' max size of a FwCapsule Header (file alignment)
 -n -k'key' insert Signer public 'key' into a signed image
 -r'rom.map' use a rom map from the external file
 -m embed the FwCapsule Sign parameters without creating a signed image

Note1. -c'key1'-k'key2'    :take PKCS#1v2.1 DER(PEM) encoded RSA2048 keys
Note2. -c2 -x'key1'-k'key2':key1-PKCS#12(PFX) with optional PFX password;
                            key2-X.509(DER) with public 'key1'
Note3. -c2 -x command invokes external Msft signtool.exe
=============================================================
=== Extended Cryptocon FwCapsule build instructions
=============================================================
 -c2 -s Create serialized data block based on the rom map info
 -c2 -s -x'p7.sig' import PKCS#7 signed data from file into a FwCapsule
 -r2 use embedded rom map data
