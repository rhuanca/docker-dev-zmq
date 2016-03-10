FROM debian:stable

RUN apt-get update --fix-missing

# install curl
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y cmake

# install build-essential (c compiler and tools)
RUN apt-get install -y build-essential

# install zmq
RUN git clone https://github.com/zeromq/libzmq
RUN cd libzmq && mkdir cmake-build && cd cmake-build && cmake .. && make -j 4 && make install && ldconfig

# RUN cmake .. && make -j 4
#RUN make test && make install && sudo ldconfig
#RUN make install && ldconfig

# setup sshd
RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd
# Important Note: Change password here when necessary.
RUN echo 'root:root123' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
