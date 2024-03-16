#!/bin/bash

rm task4.csv
echo "bf, kas_bitrate, stk_bitrate" >> task5.csv

bfs=(0 2 4 8)

rf=2
gop=250
qp=20

for bf in "${bfs[@]}"
do
  ffmpeg -i ../KristenAndSara_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $qp -g $gop -keyint_min $gop -refs $rf -bf $bf kas.mp4
  ffmpeg -i ../Stockholm_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $qp -g $gop -keyint_min $gop -refs $rf -bf $bf stk.mp4

  kas_size=$(du -b kas.mp4 | awk '{print $1}')
  kas_duration=$(ffprobe -i kas.mp4 -show_entries format=duration -v quiet -of csv="p=0")
  stk_size=$(du -b stk.mp4 | awk '{print $1}')
  stk_duration=$(ffprobe -i stk.mp4 -show_entries format=duration -v quiet -of csv="p=0")

  kas_bitrate=$(python3 -c "print(int($kas_size / $kas_duration))")
  stk_bitrate=$(python3 -c "print(int($stk_size / $stk_duration))")

  echo "$bf, $kas_bitrate, $stk_bitrate" >> task5.csv
done