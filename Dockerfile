FROM ubuntu:16.04

ENV GO_VERSION=1.9.4 \
    GOROOT=/goroot \
    GOPATH=/gopath 
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
ENV GIT_PROJECT_ROOT /srv
ENV GIT_HTTP_EXPORT_ALL yes

RUN apt-get update -y 
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
    && go get -v $(caddyplug package git) \
    && printf "package caddyhttp\nimport _ \"$(caddyplug package git)\"" > \
    /gopath/src/github.com/mholt/caddy/caddyhttp/git.go  \
    && git clone https://github.com/caddyserver/builds /gopath/src/github.com/caddyserver/builds \
    && cd /gopath/src/github.com/mholt/caddy/caddy \
    && git checkout -f \
    && GOOS=linux GOARCH=amd64 go run build.go -goos=$GOOS -goarch=$GOARCH -goarm=$GOARM \
    && mv caddy /usr/bin

RUN mkdir -vp /var/run/sshd

COPY ssh_start /usr/bin/ssh_start
RUN chmod -v 755 /usr/bin/ssh_start

EXPOSE 80 443 2015 2222
VOLUME /caddyfolder /srv
WORKDIR /srv
ENV CADDYPATH /caddyfolder

RUN apt-get install -y make ruby-dev build-essential --fix-missing
RUN gem install jekyll

COPY Caddyfile /tmp/Caddyfile
COPY hook /tmp/hook
RUN cat /tmp/Caddyfile | sed "s/REPLACEME/$(cat /tmp/hook)/g" > /etc/Caddyfile
RUN rm /tmp/hook
COPY builder.sh /usr/bin/builder.sh
COPY pullsite.sh /usr/bin/pullsite.sh
COPY users.sh /usr/bin/users.sh
COPY sshd_config /etc/ssh/sshd_config
RUN chmod -v 644 /etc/ssh/sshd_config
COPY keys/id_server /etc/ssh/ssh_host_ed25519_key
COPY keys/id_server.pub /etc/ssh/ssh_host_ed25519_key.pub
COPY keys/ /keys/
COPY users /keys/userlist
COPY known_hosts /tmp/known_hosts
COPY README.public /srv/README
COPY README.user /tmp/README
#RUN /usr/bin/pullsite.sh
CMD ["/bin/sh", "/usr/bin/builder.sh"]
