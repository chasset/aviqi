#!/usr/bin/bash
docker run --rm --volume=$PWD:/home/ubuntu r:latest Rscript -e "aviqi::monthReport()"
