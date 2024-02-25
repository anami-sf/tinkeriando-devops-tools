# tinkeriando-devops-tools

## 1. Bootstrap raspberry-pi with SSH and home directory

Copy file `ubuntu-initialization/bootstrap-pi.sh` to raspberry pi with a usb drive

```
$ cp -R <file> /Volumes/<USB_device_name>

$ cp -R ~/code/devops/tinkeriando-devops-tools/ubuntu-initialization/bootsrap-pi.sh /Volumes/USB20FD/bootstrap-pi
``````

### Find USB drive in Ubuntu
>$ sudo fdisk -l

Look for the device size and and type matching the USB drive - for example "Disk model: USB 2.0 FD". The device name would look like `/dev/sda1`

``` 
$ cd / && sudo mkdir --parents code/devops-tools
$ sudo mount <device_name> <directory>
$ sudo mount /dev/sda1 /code/devops-tools
```

Make script executable
```
chmod u+x <path_to_sctipt>`
```

Run script with sudo
```
$ sudo ./<script>
$ sudo ./bootstrap.sh
```

### Unmount USB drive

Remove USB drive then run umount command below

```
$ umount <device> <directory>
$ unmount /dev/sda1 /code/scripts
```
GOTCHA: "Umount" not "UNmount"

## 2. Generate ssh key-pair for local machine

Run the `generate-keys.sh` script as sudo
```
$ chmod u+x generate-keys.sh
$ sudo ./generate-keys.sh
```



