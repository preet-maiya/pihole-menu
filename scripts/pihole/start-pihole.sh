cd /Users/preethammaiya/projects/pihole

docker compose up -d

sudo networksetup -setdnsservers Wi-Fi 127.0.0.1
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
