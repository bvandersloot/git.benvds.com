FROM ubuntu:16.04

ENV GO_VERSION=1.8.1 \
    GOROOT=/goroot \
    GOPATH=/gopath 
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
ENV GIT_PROJECT_ROOT /srv
ENV GIT_HTTP_EXPORT_ALL yes

RUN apt-get update 
RUN apt-get install -y \
        git \
        openssh-server \
	curl \
	bzr \
	sudo

RUN mkdir /goroot && \
    curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1 && \
    mkdir /gopath 

RUN git clone https://github.com/mholt/caddy /gopath/src/github.com/mholt/caddy \
    && cd /gopath/src/github.com/mholt/caddy \
    && GOOS=linux GOARCH=amd64 go get -v github.com/abiosoft/caddyplug/caddyplug \
    && alias caddyplug='GOOS=linux GOARCH=amd64 caddyplug' \
    && go get -v $(caddyplug package cgi) \
    && printf "package caddyhttp\nimport _ \"$(caddyplug package cgi)\"" > \
    /gopath/src/github.com/mholt/caddy/caddyhttp/cgi.go  \
    && git clone https://github.com/caddyserver/builds /gopath/src/github.com/caddyserver/builds \
    && cd /gopath/src/github.com/mholt/caddy/caddy \
    && git checkout -f \
    && GOOS=linux GOARCH=amd64 go run build.go -goos=$GOOS -goarch=$GOARCH -goarm=$GOARM \
    && mv caddy /usr/bin

EXPOSE 80 443 2015 22
VOLUME /caddyfolder /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY builder.sh /usr/bin/builder.sh
COPY users.sh /usr/bin/users.sh
COPY sshd_config /etc/ssh/sshd_config
COPY keys/id_server /etc/ssh/ssh_host_ed25519_key
COPY keys/id_server.pub /etc/ssh/ssh_host_ed25519_key.pub
COPY keys/ /keys/
COPY users /keys/userlist
CMD ["/bin/sh", "/usr/bin/builder.sh"]
