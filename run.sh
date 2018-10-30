if [ -z "$1" ]
  then
    echo "Please supply your username which will be used as the container name"
    exit 1
fi
docker run -d --name $1 -it \
  --env="DISPLAY" \
  --workdir="/root" \
  --volume="/home/$USER/data:/root/data:ro" \
  --volume="/home/$USER/data/mask_rcnn_coco.h5:/root/.ros/mask_rcnn_coco.h5:ro" \
  --volume="/etc/group:/etc/group:ro" \
  --volume="/etc/passwd:/etc/passwd:ro" \
  --volume="/etc/shadow:/etc/shadow:ro" \
  --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --env QT_X11_NO_MITSHM=1 \
  ${2:-theredcomputer/fetch_melodic:latest}
