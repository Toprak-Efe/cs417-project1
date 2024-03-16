#!/bin/bash

rm task4.csv
echo "method, range, kas_bitrate, stk_bitrate" >> task4.csv

rf=2
gop=250
qp=20

for me_method in "dia" "esa"
do
  for me_range in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
  do
    ffmpeg -i ../KristenAndSara_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $qp -g $gop -keyint_min $gop -me_method $me_method -me_range $me_range -refs $rf kas.mp4
    ffmpeg -i ../Stockholm_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $qp -g $gop -keyint_min $gop -me_method $me_method -me_range $me_range -refs $rf stk.mp4

    kas_size=$(du -b kas.mp4 | awk '{print $1}')
    kas_duration=$(ffprobe -i kas.mp4 -show_entries format=duration -v quiet -of csv="p=0")
    stk_size=$(du -b stk.mp4 | awk '{print $1}')
    stk_duration=$(ffprobe -i stk.mp4 -show_entries format=duration -v quiet -of csv="p=0")

    kas_bitrate=$(python3 -c "print(int($kas_size / $kas_duration))")
    stk_bitrate=$(python3 -c "print(int($stk_size / $stk_duration))")

    echo "$me_method, $me_range, $kas_bitrate, $stk_bitrate" >> task4.csv
  done
done