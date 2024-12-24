#!/bin/bash
echo "checking sudo"
if [ $? -eq 0 ]; then
  # exit code of sudo-command is 0
  echo "has_sudo__pass_set"
elif echo $prompt | grep -q '^sudo:'; then
  echo "has_sudo__needs_pass"
else
  echo "no_sudo"
fi


echo Installing dependencies ...
echo Intalling os 

echo Formating

echo "1"
sleep 1
echo "1..2"
sleep 2
echo "1..2..3"
sleep 3
echo "1..2..3..4"
sleep 4
echo "1..2..3..4..5"
sleep 5

echo "FORMAT DESTROYING PARTION NO TURRNING BACK"


echo "⢀⡴⠑⡄⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
⠸⡇⠀⠿⡀⠀⠀⠀⣀⡴⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠑⢄⣠⠾⠁⣀⣄⡈⠙⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⢀⡀⠁⠀⠀⠈⠙⠛⠂⠈⣿⣿⣿⣿⣿⠿⡿⢿⣆⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⢀⡾⣁⣀⠀⠴⠂⠙⣗⡀⠀⢻⣿⣿⠭⢤⣴⣦⣤⣹⠀⠀⠀⢀⢴⣶⣆ 
⠀⠀⢀⣾⣿⣿⣿⣷⣮⣽⣾⣿⣥⣴⣿⣿⡿⢂⠔⢚⡿⢿⣿⣦⣴⣾⠁⠸⣼⡿ 
⠀⢀⡞⠁⠙⠻⠿⠟⠉⠀⠛⢹⣿⣿⣿⣿⣿⣌⢤⣼⣿⣾⣿⡟⠉⠀⠀⠀⠀⠀ 
⠀⣾⣷⣶⠇⠀⠀⣤⣄⣀⡀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 
⠀⠉⠈⠉⠀⠀⢦⡈⢻⣿⣿⣿⣶⣶⣶⣶⣤⣽⡹⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠉⠲⣽⡻⢿⣿⣿⣿⣿⣿⣿⣷⣜⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣶⣮⣭⣽⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⣀⣀⣈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⠿⠿⠿⠛⠉"
#!/bin/bash

# Script to extract 85% of the current partition, format a new partition, 
# and backup the partition data (without bootloader installation).

# Variables
BOOT_DIR="/boot"             # The boot directory (no copying feature)
NEW_PARTITION="/dev/sdXY"   # The new partition (replace with the partition you wish to format, e.g., /dev/sdb1)
NEW_PARTITION_MOUNT="/mnt/newboot"  # Mount point for the new partition
FILESYSTEM_TYPE="ext4"      # Filesystem type (can be ext4, xfs, etc.)

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Find the current partition where /boot is located
CURRENT_PARTITION=$(findmnt -n -o SOURCE "$BOOT_DIR")

if [ -z "$CURRENT_PARTITION" ]; then
  echo "Could not determine the current partition where /boot is located."
  exit 1
fi

echo "Current /boot partition: $CURRENT_PARTITION"

# Get the size of the current partition
PARTITION_SIZE=$(blockdev --getsize64 "$CURRENT_PARTITION")
EXTRACT_SIZE=$((PARTITION_SIZE * 85 / 100))

echo "Current partition size: $PARTITION_SIZE bytes"
echo "Extracting 85% of the current partition: $EXTRACT_SIZE bytes"

# Create a backup of 85% of the current partition (simulate with dd)
BACKUP_FILE="/tmp/boot_partition_backup.img"
echo "Backing up 85% of the current partition to $BACKUP_FILE..."
dd if="$CURRENT_PARTITION" of="$BACKUP_FILE" bs=1M count=$((EXTRACT_SIZE / 1024 / 1024)) status=progress

# Check if backup was successful
if [ $? -ne 0 ]; then
  echo "Error creating the backup of the partition."
  exit 1
fi

echo "85% of the current partition has been backed up."

# Check if the new partition is already mounted
if mountpoint -q "$NEW_PARTITION_MOUNT"; then
  echo "The partition is already mounted at $NEW_PARTITION_MOUNT."
else
  # Format the new partition
  echo "Formatting $NEW_PARTITION with $FILESYSTEM_TYPE..."
  mkfs.$FILESYSTEM_TYPE "$NEW_PARTITION"

  # Mount the new partition
  echo "Mounting the new partition at $NEW_PARTITION_MOUNT..."
  mount "$NEW_PARTITION" "$NEW_PARTITION_MOUNT"
fi

# Final message
echo "Process completed: 85% of the current partition backed up, and the new partition formatted."


mkdir -pv ./{bin ,sbin ,etc ,lib ,lib64 ,var ,dev ,proc ,sys ,run ,tmp}

mknod -m 600 ./dev/console c 5 1
mknod -m 666 ./dev/null c 5 1

# Copy bootloader files from /boot to the new partition
echo "Copying bootloader files from $BOOT_DIR to $NEW_PARTITION_MOUNT..."
rsync -avh --progress "$BOOT_DIR/" "$NEW_PARTITION_MOUNT/"

# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Bootloader files successfully copied to $NEW_PARTITION_MOUNT."
else
  echo "An error occurred while copying bootloader files."
  exit 1
fi

# Install GRUB bootloader on the new partition
echo "Installing the bootloader on the new partition ($NEW_PARTITION)..."
grub-install $NEW_PARTITION_MOUNT --skip-fs-probe --boot-directory=$NEW_PARTITION_MOUNT/boot/
cat grub.cfg >> $NEW_PARTITION_MOUNT/boot/grub/grub.cfg

# Check if GRUB installation was successful
if [ $? -eq 0 ]; then
  echo "Bootloader successfully installed on $DISK."
else
  echo "Failed to install the bootloader."
  exit 1
fi

# Final message
echo "Bootloader copied and installed successfully on the new partition. Partition formatted with $FILESYSTEM_TYPE."



#compling lanuch

gcc  --nostdlib --ffreestanding -no-pie init.c start.s -o a.out

#CREating new dir

mkdir $NEW_PARTITION_MOUNT/src
#copying files
sudo cp a.out $NEW_PARTITION_MOUNT/src/
sudo cp init.c $NEW_PARTITION_MOUNT/src/
sudo cp start.S $NEW_PARTITION_MOUNT/src/