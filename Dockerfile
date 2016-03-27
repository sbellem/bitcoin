FROM ubuntu:15.10

RUN apt-get update
#RUN apt-get install -y software-properties-common python-software-properties

# BerkeleyDB is required for the wallet. db4.8 packages are available here.
# You can add the repository and install using the following commands:
#RUN add-apt-repository -y ppa:bitcoin/bitcoin
#RUN apt-get update
#RUN apt-get -y install libdb4.8-dev libdb4.8++-dev

RUN apt-get -y install build-essential libtool autotools-dev automake \
	pkg-config libssl-dev libevent-dev bsdmainutils

# boost
RUN apt-get install -y libboost-all-dev

# https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#dependencies-for-the-gui-ubuntu--debian
#RUN apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev \
#	qttools5-dev-tools libprotobuf-dev protobuf-compiler
#RUN apt-get install -y libqrencode-dev

RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app 
RUN sh autogen.sh
RUN sh configure --disable-tests --with-incompatible-bdb
RUN make
RUN make install

RUN rm -rf /usr/src/app

EXPOSE 18333 18332
VOLUME /.bitcoin
ENTRYPOINT ["bitcoind"]

CMD ["-testnet", "-printtoconsole"]
