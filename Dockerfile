FROM golang:1.13.11

# Required for building the Oracle DB driver
ADD oci8.pc /usr/lib/pkgconfig/oci8.pc

# Install Oracle Client (all commands in one RUN to save image size)
RUN apt-get update && apt-get install -y --no-install-recommends \
	unzip \
	libaio1 \
	telnet \

	&& apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/zqiushi/oracle-instantclient/raw/master/instantclient-basic-linux.x64-12.2.0.1.0.zip -O /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip && \
    wget https://github.com/zqiushi/oracle-instantclient/raw/master/instantclient-sdk-linux.x64-12.2.0.1.0.zip -O /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip && \
    unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/

RUN ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
    ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so


# The package config doesn't seem to be enough, this is also required
ENV LD_LIBRARY_PATH /usr/local/instantclient

# Get ora dep
RUN go get -d -v gopkg.in/rana/ora.v4
