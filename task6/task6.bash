rm task6.csv
echo "qp, kas4_bitrate, kas4_psnr, kas5_bitrate, kas5_psnr, stk4_bitrate, stk4_psnr, stk5_bitrate, stk5_psnr" >> task6.csv

for qp in 30 40 50
do
  ffmpeg -i ../KristenAndSara_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $qp kas_h264.mp4
  ffmpeg -i ../Stockholm_720p.y4m -y -c:v libx264 -pix_fmt yuv420p -an -qp $qp stk_h264.mp4
  ffmpeg -i ../KristenAndSara_720p.y4m -y -c:v libx265 -pix_fmt yuv420p -an -x265-params qp=$qp kas_h265.mp4
  ffmpeg -i ../Stockholm_720p.y4m -y -c:v libx265 -pix_fmt yuv420p -an -x265-params qp=$qp stk_h265.mp4

  kas_h264_size=$(du -b kas_h264.mp4 | awk '{print $1}')
  kas_h264_duration=$(ffprobe -i kas_h264.mp4 -show_entries format=duration -v quiet -of csv="p=0")
  stk_h264_size=$(du -b stk_h264.mp4 | awk '{print $1}')
  stk_h264_duration=$(ffprobe -i stk_h264.mp4 -show_entries format=duration -v quiet -of csv="p=0")
  kas_h265_size=$(du -b kas_h265.mp4 | awk '{print $1}')
  kas_h265_duration=$(ffprobe -i kas_h265.mp4 -show_entries format=duration -v quiet -of csv="p=0")
  stk_h265_size=$(du -b stk_h265.mp4 | awk '{print $1}')
  stk_h265_duration=$(ffprobe -i stk_h265.mp4 -show_entries format=duration -v quiet -of csv="p=0")

  kas_h264_psnr=$(ffmpeg -i kas_h264.mp4 -i ../KristenAndSara_720p.y4m -lavfi psnr -f null - 2>&1 | grep "PSNR" | awk '{print $5}' | cut -c 3-)
  kas_h265_psnr=$(ffmpeg -i kas_h265.mp4 -i ../KristenAndSara_720p.y4m -lavfi psnr -f null - 2>&1 | grep "PSNR" | awk '{print $5}' | cut -c 3-)
  stk_h264_psnr=$(ffmpeg -i stk_h264.mp4 -i ../Stockholm_720p.y4m -lavfi psnr -f null - 2>&1 | grep "PSNR" | awk '{print $5}' | cut -c 3-)
  stk_h265_psnr=$(ffmpeg -i stk_h265.mp4 -i ../Stockholm_720p.y4m -lavfi psnr -f null - 2>&1 | grep "PSNR" | awk '{print $5}' | cut -c 3-)

  kas_h264_bitrate=$(python3 -c "print(int($kas_h264_size / $kas_h264_duration))")
  stk_h264_bitrate=$(python3 -c "print(int($stk_h264_size / $stk_h264_duration))")
  kas_h265_bitrate=$(python3 -c "print(int($kas_h265_size / $kas_h265_duration))")
  stk_h265_bitrate=$(python3 -c "print(int($stk_h265_size / $stk_h265_duration))")

  echo "$qp, $kas_h264_bitrate, $kas_h264_psnr, $kas_h265_bitrate, $kas_h265_psnr, $stk_h264_bitrate, $stk_h264_psnr, $stk_h265_bitrate, $stk_h265_psnr" >> task6.csv
done