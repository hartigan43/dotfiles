#!/bin/bash
# https://openwrt.org/docs/guide-user/installation/generic.backup#create_full_mtd_backup
# https://openwrt.org/docs/guide-user/installation/generic.backup#restore_backup_from_openwrt_console
#
# https://forum.archive.openwrt.org/viewtopic.php?id=73770
# The resulting image.bin can be flashed back to this router or to another router of exactly the same model to clone it.  Treat it as a "sysupgrade" file.
# This is for NOR flash only.  It is very unlikely to work on NAND flash.  Also if you only have 32 MB RAM, the image on the RAMdisk may cause the router to run out of RAM.

set -e

function die() {
	echo "${@}"
	exit 2
}

OUTPUT_FILE="mtd_backup.tgz"
OPENWRT="root@openwrt.lan"
TMPDIR=$(mktemp -d)
BACKUP_DIR="${TMPDIR}/mtd_backup"
mkdir -p "${BACKUP_DIR}"
SSH_CONTROL="${TMPDIR}/ssh_control"

function cleanup() {
	set +e

	echo "Closing master SSH connection"
	"${SSH_CMD[@]}" -O stop

	echo "Removing temporary backup files"
	rm -r "${TMPDIR}"
}
trap cleanup EXIT

# Open master ssh connection, to avoid the need to authenticate multiple times
echo "Opening master SSH connection"
ssh -o "ControlMaster=yes" -o "ControlPath=${SSH_CONTROL}" -o "ControlPersist=10" -n -N "${OPENWRT}"

# This is the command we'll use to reuse the master connection
SSH_CMD=(ssh -o "ControlMaster=no" -o "ControlPath=${SSH_CONTROL}" -n "${OPENWRT}")

# List remote mtd devices from /proc/mtd. The first line is just a table
# header, so skip it (using tail)
"${SSH_CMD[@]}" 'cat /proc/mtd' | tail -n+2 | while read; do
	MTD_DEV=$(echo ${REPLY} | cut -f1 -d:)
	MTD_NAME=$(echo ${REPLY} | cut -f2 -d\")
	echo "Backing up ${MTD_DEV} (${MTD_NAME})"
	# It's important that the remote command only prints the actual file
	# contents to stdout, otherwise our backup files will be corrupted. Other
	# info must be printed to stderr instead. Luckily, this is how the dd
	# command already behaves by default, so no additional flags are needed.
	"${SSH_CMD[@]}" "dd if='/dev/${MTD_DEV}ro'" > "${BACKUP_DIR}/${MTD_DEV}_${MTD_NAME}.backup" || die "dd failed, aborting..."
done

# Use gzip and tar to compress the backup files
echo "Compressing backup files to \"${OUTPUT_FILE}\""
(cd "${TMPDIR}" && tar czf - "$(basename "${BACKUP_DIR}")") > "${OUTPUT_FILE}" || die 'tar failed, aborting...'

# Clean up a little earlier, so the completion message is the last thing the user sees
cleanup
# Reset signal handler
trap EXIT

echo -e "\nMTD backup complete. Extract the files using:\ntar xzf \"${OUTPUT_FILE}\""
