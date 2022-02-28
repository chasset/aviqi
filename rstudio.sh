#!/usr/bin/bash
docker run --rm --detach --volume=$PWD:/home/ubuntu --publish=8787:8787 rstudio:latest && open http://localhost:8787
