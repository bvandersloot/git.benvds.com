all:
	docker build -t git .

run:
	docker run -i -t  -p 2222:2222 -p 2015:2015 -v $(CURDIR)/caddyfolder:/caddyfolder -v $(CURDIR)/data:/srv git
