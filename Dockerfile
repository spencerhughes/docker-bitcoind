FROM debian:stretch-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
	apt-get -qq upgrade && \
	apt-get -qq install \
		curl \
		gnupg2 \
		apt-utils \
		apt-transport-https \
	&& \
	apt-get -qq autoremove && \
	apt-get -qq clean

ARG BTC_VERSION=0.17.1
ARG BTC_ARCH=x86_64
ARG LND_VERSION=v0.5.2-beta
ARG LND_ARCH=linux-amd64
ARG LND_ARCHIVE=lnd-${ARCH}-${LND_VERSION}.tar.gz

RUN cd /tmp && \
	curl -O https://bitcoin.org/bin/bitcoin-core-${BTC_VERSION}/bitcoin-${BTC_VERSION}-${BTC_ARCH}-linux-gnu.tar.gz && \
	curl -O https://bitcoin.org/bin/bitcoin-core-${BTC_VERSION}/SHA256SUMS.asc && \
	curl -O https://bitcoin.org/laanwj-releases.asc && \
	sha256sum --check SHA256SUMS.asc --ignore-missing && \
	gpg ./laanwj-releases.asc && \
	gpg --import ./laanwj-releases.asc && \
	gpg --verify SHA256SUMS.asc && \
	tar xzf bitcoin-${BTC_VERSION}-${BTC_ARCH}-linux-gnu.tar.gz && \
	install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${BTC_VERSION}/bin/* && \
	bitcoind --version && \
	rm bitcoin-${BTC_VERSION}-${BTC_ARCH}-linux-gnu.tar.gz && \
	rm SHA256SUMS.asc && \
	rm laanwj-releases.asc

COPY bitcoin.conf /opt/bitcoind/bitcoin.conf

CMD ["bitcoind","-datadir=/opt/bitcoind"]