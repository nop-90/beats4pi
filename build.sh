#!/bin/bash
echo Target version: $BEATS_VERSION

GOARCH=amd64 go install github.com/magefile/mage@v1.11.0

BRANCH=$(echo $BEATS_VERSION | awk -F \. {'print $1 "." $2'})
echo Target branch: $BRANCH

if [ ! -d "$GOPATH/src/github.com/elastic/beats" ]; then GOARCH=arm go install github.com/elastic/beats/v7@v$BEATS_VERSION; fi

cd $GOPATH/pkg/mod/github.com/elastic/beats/v7@v$BEATS_VERSION

IFS=","
BEATS_ARRAY=($BEATS)

for BEAT in "${BEATS_ARRAY[@]}"
do
    export PATH=$GOPATH/bin:$PATH
    # build
    cd $GOPATH/pkg/mod/github.com/elastic/beats/v7@v$BEATS_VERSION/$BEAT
    make -j7
    cp $BEAT /build

    # package
    DOWNLOAD=$BEAT-$BEATS_VERSION-linux-x86.tar.gz
    if [ ! -e $DOWNLOAD ]; then wget --no-verbose https://artifacts.elastic.co/downloads/beats/$BEAT/$DOWNLOAD; fi
    tar xf $DOWNLOAD

    cp $BEAT $BEAT-$BEATS_VERSION-linux-x86
    tar zcf $BEAT-$BEATS_VERSION-linux-arm$GOARM.tar.gz $BEAT-$BEATS_VERSION-linux-x86
    cp $BEAT-$BEATS_VERSION-linux-arm$GOARM.tar.gz /build
done
