RSTUDIO_IMAGE=rstudio:latest
docker run --rm --detach --volume=$PWD:/home/ubuntu --publish=8787:8787 $RSTUDIO_IMAGE && open http://localhost:8787