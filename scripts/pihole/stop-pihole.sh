cd /Users/preethammaiya/projects/pihole

docker compose down

sudo networksetup -setdnsservers Wi-Fi
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
