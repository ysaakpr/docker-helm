########################
# "builder", fetch helm from release page
########################
FROM alpine:edge as builder

# variable "VERSION" must be passed as docker environment variables during the image build
# docker build --no-cache --build-arg VERSION=2.12.0 -t alpine/helm:2.12.0 .

ENV VERSION=3.0.0-beta.3

# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${VERSION}-linux-amd64.tar.gz"

RUN apk add --update --no-cache curl ca-certificates && \
    curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm

WORKDIR /apps

############
# final image
############

FROM alpine:3.10
COPY --from=builder /usr/bin/helm /usr/bin/helm
#FROM alpine/helm:3.0.0-beta.1
LABEL maintainer="peter.niederlag@datenbetrieb.de"
#RUN apk add --update --no-cache jq
RUN apk add --update --no-cache curl && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    apk del curl

ENTRYPOINT ["helm"]
CMD ["--help"]
