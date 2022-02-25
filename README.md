# Session IQ

## Dependency and Reproducibility

Our aim is to deliver reproducible results. All software needed for this session will be built in a virtual machine based on docker.

If Docker is already installed on your machine, build the VM:

```bash
docker compose build
```

## Debug environment

If you want to explore and test code, use the RStudio environment of the virtual machine:

```bash
RSTUDIO_IMAGE=rstudio:latest
docker run --rm --detach --volume=$PWD:/home/ubuntu --publish=8787:8787 $RSTUDIO_IMAGE && open http://localhost:8787
```

It will open your favorite browser and ask you for username (ubuntu) and password (ubuntu).

## Export the final file

```bash
RSTUDIO_IMAGE=rstudio:latest
docker run --rm --detach --volume=$PWD:/home/ubuntu --publish=8787:8787 $RSTUDIO_IMAGE 
```

