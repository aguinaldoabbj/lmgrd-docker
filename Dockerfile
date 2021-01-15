FROM ubuntu 

#url of latest Linux 64-bit Matlab License Manager. Go to https://www.mathworks.com/support/install/license_manager_files.html
ARG LMGRD_URL=https://ssd.mathworks.com/supportfiles/downloads/R2020b/license_manager/R2020b/daemons/glnxa64/mathworks_network_license_manager_glnxa64.zip

ENV LICENSE_DIR=/etc/lmgrd/licenses

RUN apt update && apt install -y \
	file \ 
	wget \
	unzip \
	patchelf \
	&& mkdir /lmgrd && mkdir -p $LICENSE_DIR \
    	&& chmod -R 777 /lmgrd \
    	&& chmod -R 777 $LICENSE_DIR \
	&& cd /lmgrd && wget $LMGRD_URL -O manager.zip \
	&& unzip manager.zip \
    && rm -vf manager.zip \
	&& for file in $(ls etc/glnxa64); do patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 etc/glnxa64/${file}; done \
	&& apt purge patchelf -y \
	# lmgrd bin files download from MATLAB website comes with wrong interpreter. we do manual patch with patchelf
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/tmp/ # For (MLM) Can't make directory /usr/tmp/.flexlm, errno: 2(No such file or directory) error

ENV LICENSE_URL=http://example.com/license.lic

ENV LMGRD_PORT=27000
ENV MLM_PORT=27001

EXPOSE $LMGRD_PORT
EXPOSE $MLM_PORT

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["npm", "start"]
CMD ["/lmgrd/etc/glnxa64/lmgrd", "-z", "-c", "/etc/lmgrd/licenses"]

