# unraid-tools.sh
#  just random scripts or one off commands I use for maintenance

#find all rars and rar parts and remove them, .rar and .r0-r999 that are 30 days or older
find /mnt/user/media/ -type f -regextype posix-extended -regex ".*\.r([0-9]{1,}|ar)$" -mtime +30 -exec rm {} \;

#find sample mkv files under 500Mb and get total size
find /mnt/user/media/ -type f -regextype posix-extended -regex ".*sample.*\.mkv$" -mtime +15 -size -500M -print0 | xargs -0 du -hc | grep total
find /mnt/user/media/ -type f -regextype posix-extended -regex ".*sample.*\.mkv$" -mtime +15 -size -500M -exec rm {} \;
