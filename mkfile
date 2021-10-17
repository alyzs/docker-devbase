
NAMESPACE=alyz
REPOSITORY=${BASENAME}
VERSION=bullseye

build:
    docker build -t="${NAMESPACE}/${REPOSITORY}:${VERSION}" main

rebuild:
    docker build --no-cache -t="${NAMESPACE}/${REPOSITORY}:${VERSION}" main

push:
    docker push ${NAMESPACE}/${REPOSITORY}:${VERSION}
