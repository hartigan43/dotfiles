# unraid-tools.sh
#  just random scripts or one off commands I use for maintenance

# find all rars and rar parts and remove them, .rar and .r0-r999 that are 30 days or older
find /mnt/user/media/ -type f -regextype posix-extended -regex ".*\.r([0-9]{1,}|ar)$" -mtime +30 -exec rm {} \;

# find sample mkv files under 500Mb and get total size
find /mnt/user/media/ -type f -regextype posix-extended -regex ".*sample.*\.mkv$" -mtime +15 -size -500M -print0 | xargs -0 du -hc | grep total
find /mnt/user/media/ -type f -regextype posix-extended -regex ".*sample.*\.mkv$" -mtime +15 -size -500M -exec rm {} \;

#find directories with total contents smaller than given size
find DIR -mindepth 1 -maxdepth 1 -type d -exec du -ks {} + | awk '$1 <= 50' | cut -f 2-
# pipe into | xargs -d \\n rm -rf to remove

# cleanup multipart rars
alias rarcleanup='find ./ -regextype posix-egrep -iregex ".*\.r(ar|[0-9]*)$" -exec rm {} \;'

# find all hardlinks
find /path/to/directory -type f -links +1

# find and remove all files and directories under 500M
# these are dubious
find /path/to/directory -type f -size -500M -exec rm {} \;
find /path/to/directory -type d -size -500M -exec rm -r {} \;
