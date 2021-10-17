# andig/beats4pi

Docker image to build elastic/beats for Raspberry Pi

## Customizing

The image has a couple of ENV vars that can be used for customizing what and how to build:

  - `GOARCH=arm` - the target architecture, arm for RaspberryPi
  - `GOARM=7` - ARM architecture version - 7 for RasperryPi 3
  - `BEATS=filebeat,metricbeat` - comma-separated list of beats to compile
  - `BEATS_VERSION=6.1.1` - version to compile

## Building images
    ARMv6 :
    docker build -t beats4pi:armv6 -f Dockerfile-armv6 .

    ARMv7 :
    docker build -t beats4pi:armv7 -f Dockerfile-armv7 .


## Building elastic beats

This command will output the build result in the `go_build` folder:

    ARMv6 (Rasp Zero) :
    docker run -it -v $(pwd)/go_src:/go -v $(pwd)/go_build:/build --rm beats4pi:armv6

    ARMv7 (Rasp 3) :
    docker run -it -v $(pwd)/go_src:/go -v $(pwd)/go_build:/build --rm beats4pi:armv7

Forked from andig/beats4pi
Adaptations :
    - go get becomes go install
    - No need to clone beats before building
    - Add another dockerfile for armv6 (can be useful to maintain two images with a tag for each architecture)
