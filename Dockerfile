#FROM ubuntu as builder
FROM ubuntu 
#ARG DEBIAN_FRONTEND=noninteractive

#url of latest Linux 64-bit Matlab License Manager. Go to https://www.mathworks.com/support/install/license_manager_files.html
ARG LRGRD_URL=https://ssd.mathworks.com/supportfiles/downloads/R2020b/license_manager/R2020b/daemons/glnxa64/mathworks_network_license_manager_glnxa64.zip


RUN apt update && apt install wget unzip patchelf -y && mkdir /lmgrd && mkdir -p /etc/lmgrd/licenses \
	&& cd /lmgrd && wget $LRGRD_URL -O  manager.zip \
	&& unzip manager.zip \
    && rm -vf manager.zip \
	&& for file in $(ls etc/glnxa64); do patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 etc/glnxa64/${file}; done 
	# lmgrd bin files download from MATLAB website comes with wrong interprete. we do manual patch here

#FROM ubuntu
#COPY --from=builder /lmgrd /lmgrd

ENV LICENSES_URL=http://url-to-your-license-file

#VOLUME /etc/lmgrd/licenses
#VOLUME /usr/tmp
# 
ENV LMGRD_PORT=27000
ENV MLM_PORT=27001

EXPOSE $LMGRD_PORT
EXPOSE $MLM_PORT

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["npm", "start"]
CMD ["/lmgrd/etc/glnxa64/lmgrd", "-z", "-c", "/etc/lmgrd/licenses"]


#ENTRYPOINT ["/lmgrd/etc/glnxa64/lmgrd", "-z", "-c", "/etc/lmgrd/licenses"]
# 
