all:
	docker build -t git .

run:
	docker run -i -t -p 2015:2015 -p 2016:22 -v $(CURDIR)/caddyfolder:/caddyfolder -v $(CURDIR)/data:/srv git
