all:
	docker build -t git .

run:
	docker run -i -t  -p 22:22 -p 80:80 -p 443:443 -v $(CURDIR)/caddyfolder:/caddyfolder -v $(CURDIR)/data:/srv git
