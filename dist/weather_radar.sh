#!/bin/bash
cd /home/homeassistant/.homeassistant/www/weather_card

curl -s -o "dmv-weather.png" "https://s.w-x.co/staticmaps/wu/wu/wxtype1200_cur/usshd/animate.png"
curl -s -o "sat-weather.png" "https://s.w-x.co/staticmaps/wu/wu/wxtype1200_cur/ussat/animate.png"

#create the gif
/home/homeassistant/.homeassistant/gifsicle-static -O3 --colors 132 --lossy=1500 -o /home/homeassistant/.homeassistant/www/weather_card/weather_map_sat.gif sat-weather.png
/home/homeassistant/.homeassistant/gifsicle-static -O3 --colors 132 --lossy=1500 -o /home/homeassistant/.homeassistant/www/weather_card/weather_map_dmv.gif dmv-weather.png

#reduce the size of gif
mogrify -size 1200x875 -resize 492x359 *.gif

#create mp4
ffmpeg -f gif -i sat-weather.png -pix_fmt yuv420p -c:v libx264 -preset veryslow -tune animation -profile:v baseline -crf 34 -movflags +faststart -filter:v crop='floor(in_w/2)*2:floor(in_h/2)*2' weather_map_sat.mp4 -y

ffmpeg -f gif -i dmv-weather.png -pix_fmt yuv420p -c:v libx264 -preset veryslow -tune animation -profile:v baseline -crf 34 -movflags +faststart -filter:v crop='floor(in_w/2)*2:floor(in_h/2)*2' weather_map_dmv.mp4 -y


#remove the original files
rm sat-weather.png
rm dmv-weather.png


#return the original folder
cd /home/homeassistant/.homeassistant/includes/