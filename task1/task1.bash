#!/bin/bash

rm task1.csv
echo "qp, kas_bitrate, kas_psnr, kas_ssim, stk_bitrate, stk_psnr, stk_ssim" >> task1.csv

for i in {1..5}
do
  ffmpeg -i ../KristenAndSara_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $(($i*10)) kas.mp4
  ffmpeg -i ../Stockholm_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $(($i*10)) stk.mp4

  kas_size=$(du -b kas.mp4 | awk '{print $1}')
  kas_duration=$(ffprobe -i kas.mp4 -show_entries format=duration -v quiet -of csv="p=0")
  stk_size=$(du -b stk.mp4 | awk '{print $1}')
  stk_duration=$(ffprobe -i stk.mp4 -show_entries format=duration -v quiet -of csv="p=0")

  kas_bitrate=$(python3 -c "print(int($kas_size / $kas_duration))")
  stk_bitrate=$(python3 -c "print(int($stk_size / $stk_duration))")

  kas_psnr=$(ffmpeg -i kas.mp4 -i ../KristenAndSara_720p.y4m -lavfi psnr -f null - 2>&1 | grep "PSNR" | awk '{print $5}' | cut -c 3-)
  kas_ssim=$(ffmpeg -i kas.mp4 -i ../KristenAndSara_720p.y4m -lavfi ssim -f null - 2>&1 | grep "SSIM" | awk '{print $11}' | cut -c 5-)

  stk_psnr=$(ffmpeg -i stk.mp4 -i ../Stockholm_720p.y4m -lavfi psnr -f null - 2>&1 | grep "PSNR" | awk '{print $5}' | cut -c 3-)
  stk_ssim=$(ffmpeg -i stk.mp4 -i ../Stockholm_720p.y4m -lavfi ssim -f null - 2>&1 | grep "SSIM" | awk '{print $11}' | cut -c 5-)
 
  echo "$i, $kas_bitrate, $kas_psnr, $kas_ssim, $stk_bitrate, $stk_psnr, $stk_ssim" >> task1.csv
done