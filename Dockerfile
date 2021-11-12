FROM alpine:3.3
ADD super_netperf /sbin/
ADD eagain.patch .

RUN \
	apk add --update curl build-base bash && \
        curl -LO https://github.com/HewlettPackard/netperf/archive/refs/tags/netperf-2.7.0.tar.gz && \
	tar -xzf netperf-2.7.0.tar.gz && \
	cd netperf-netperf-2.7.0 && patch -p1 < ../eagain.patch && \
        ./configure --prefix=/usr && make && make install && \
	cd .. && rm -rf netperf-netperf-2.7.0 netperf-2.7.0.tar.gz && \
	rm -f /usr/share/info/netperf.info && \
	strip -s /usr/bin/netperf /usr/bin/netserver && \
	apk del build-base && rm -rf /var/cache/apk/*
CMD ["/usr/bin/netserver", "-D"]
