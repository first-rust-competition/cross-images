FROM rustembedded/cross:arm-unknown-linux-gnueabi-0.1.16
COPY ./ /
RUN mkdir -p /var/volatile/tmp
RUN chmod a+rwx /tmp
ENV RUSTFLAGS "-L /usr/local/natinst/lib"
