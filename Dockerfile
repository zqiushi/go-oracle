FROM golang:1.13.11

# Required for building the Oracle DB driver
ADD oci8.pc /usr/lib/pkgconfig/oci8.pc

# Install Oracle Client (all commands in one RUN to save image size)
RUN apt-get update && apt-get install -y --no-install-recommends \
	unzip \
	libaio1 \

	&& apt-get clean \
        && rm -rf /var/lib/apt/lists/* \

        && wget https://github.com/zqiushi/oracle-instantclient/blob/master/instantclient-basic-linux.x64-12.2.0.1.0.zip \
	&& wget https://github.com/zqiushi/oracle-instantclient/blob/master/instantclient-sdk-linux.x64-12.2.0.1.0.zip 


RUN  unzip instantclient-basic-linux.x64-12.2.0.1.0.zip -d / \
    	&& unzip instantclient-sdk-linux.x64-12.2.0.1.0.zip -d / \

	&& rm instantclient-*-linux.x64-*.zip \
		&& ln -s /instantclient_12_2/libclntsh.so.12.1 /instantclient/libclntsh.so

    	# && ln -s /instantclient_11_2/libclntsh.so.11.1 /instantclient_11_2/libclntsh.so

# The package config doesn't seem to be enough, this is also required
ENV LD_LIBRARY_PATH /instantclient_12_2

# Get ora dep
RUN go get -d -v gopkg.in/rana/ora.v4
