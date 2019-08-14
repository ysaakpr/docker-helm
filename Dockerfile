FROM alpine/helm:3.0.0-alpha.2
LABEL maintainer="peter.niederlag@datenbetrieb.de"
#RUN apk add --update --no-cache jq
RUN apk add --update --no-cache curl && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    apk del curl
CMD ["--help"]
