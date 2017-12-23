# Use ubuntu 16.04 as the parent image
FROM ubuntu:xenial

WORKDIR /usr/local/src

# Install the Lmod modules system for package managmenet since
# the GEV workflow expects it
RUN apt-get update \
  && apt-get install -y lua5.2 liblua5.2-dev libtool-bin lua-posix lua-filesystem lua-filesystem-dev git \
  && git clone https://github.com/TACC/Lmod.git --branch 7.7.13 \
  && cd Lmod \
  && ./configure --prefix=/usr/local \
  && sudo make install \
  && ln -s /usr/local/lmod/lmod/init/profile /etc/profile.d/z00_lmod.sh \
  && ln -s /usr/local/lmod/lmod/init/cshrc /etc/profile.d/z00_lmod.csh \
  && mkdir /usr/local/modulefiles 

