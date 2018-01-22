all:
	docker build  --build-arg plugins=cgi -t git .

run:
	docker run -i -t -p 2015:2015 -v $(CURDIR)/caddyfolder:/caddyfolder -v $(CURDIR)/data:/srv git
