FROM ubuntu as builder
ARG DEBIAN_FRONTEND=noninteractive

#url of latest Linux 64-bit Matlab License Manager. Go to https://www.mathworks.com/support/install/license_manager_files.html
ARG LRGRD_URL=https://ssd.mathworks.com/supportfiles/downloads/R2020b/license_manager/R2020b/daemons/glnxa64/mathworks_network_license_manager_glnxa64.zip

RUN apt update && apt install wget unzip patchelf -y && mkdir /lmgrd \
	&& cd /lmgrd && wget $LRGRD_URL \
	&& unzip mathworks_network_license_manager_glnxa64.zip \
	# lmgrd bin files download from MATLAB website comes with wrong interprete. we do manual patch here
	&& for file in $(ls etc/glnxa64); do patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 etc/glnxa64/${file}; done \
	&& rm -vf mathworks_network_license_manager_glnxa64.zip

FROM ubuntu
COPY --from=builder /lmgrd /lmgrd
VOLUME /etc/lmgrd/licenses
VOLUME /usr/tmp
COPY licenses/* /etc/lmgrd/licenses/
ENV LMGRD_PORT=27000
ENV MLM_PORT=27001
EXPOSE $LMGRD_PORT
EXPOSE $MLM_PORT

ENTRYPOINT ["/lmgrd/etc/glnxa64/lmgrd", "-z", "-c", "/etc/lmgrd/licenses"]
