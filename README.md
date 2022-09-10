# Debian Preseed ISO Builder

A simple shell script for generating an iso image with a preseed file to help automate the installation of Debian. 

## Prerequistes

Install the following packages. 
```shell
sudo apt install -y xorriso p7zip-full fakeroot binutils isolinux
```
A directory named iso in same folder as this script. 
```shell
mkdir iso
```

## How to Run

1. Download the latest Debien ISO from here:  ([Download Link](https://www.debian.org/CD/netinst/index.en.html)) and place it in the `\iso` directory. 
2. Then run the following shell script with the name of the iso image.
```sh
sudo ./transform.sh debian-11.4.0-amd64-netinst.iso
```
4. After the ISO image is built you will see a new ISO in the ISO folder. This is your new image. 
````
iso/preseed-debian-11.4.0-amd64-netinst.iso
````