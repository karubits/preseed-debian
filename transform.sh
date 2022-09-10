#!/usr/bin/env bash

echo 
# Create directory to hold extracted iso
ISO="$PWD/iso/$1"
WD="$(mktemp -d)"

echo "Using ISO image: $ISO"
echo "Using temp directory: $WD"

echo
echo "🔷 Extracting the iso image to $WD...."
xorriso -osirrox on -indev $ISO -extract / $WD

echo
echo "🔷 Make initrd writeable.."
chmod +w -R $WD/install.amd/

echo
echo "🔷 Unzip initrd..."
gunzip $WD/install.amd/initrd.gz
gunzip $WD/install.amd/gtk/initrd.gz

echo 
echo "🔷 Disable install menu for BIOS mode"
sudo sed -i 's/default/#default/' $WD/isolinux/isolinux.cfg

echo
echo "🔷 Disable install menu for UEFI mode"
echo "set timeout_style=hidden" | sudo tee -a $WD/boot/grub/grub.cfg
echo "set timeout=0" | sudo tee -a $WD/boot/grub/grub.cfg
echo "set default=1" | sudo tee -a $WD/boot/grub/grub.cfg

echo
echo "🔷 Add the preseed to the initrd"
echo preseed.cfg | cpio -H newc -o -A -F $WD/install.amd/initrd
echo preseed.cfg | cpio -H newc -o -A -F $WD/install.amd/gtk/initrd

echo
echo "🔷 Re-Zip initrd.."
gzip $WD/install.amd/initrd
gzip $WD/install.amd/gtk/initrd

echo
echo "🔷 Remove write abilities of initrd"
chmod -w -R $WD/install.amd

echo
echo "🔷 Enter the $WD directory"
cd $WD || exit

echo
echo "🔷 Generate new md5sum.txt"
chmod 666 md5sum.txt
find -follow -type f -exec md5sum {} \; > md5sum.txt
chmod 444 md5sum.txt

echo
echo "🔷 Move back a directory"
cd .. || exit

echo
echo "🔷 Generate a new iso with the preseed file inside..."
xorriso -as mkisofs \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -c isolinux/boot.cat \
    -b isolinux/isolinux.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    -e boot/grub/efi.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -o $ISO-preseed $WD/

