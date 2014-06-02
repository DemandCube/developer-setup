FROM ubuntu:12.04
MAINTAINER Peter Jerold Leslie, jeroldleslie@gmail.com


#RUN apt-get -y update
#RUN apt-get install -y git-core
#RUN apt-get install -y sudo
#RUN apt-get install -y python3-setuptools
#RUN easy_install3 pip
#RUN apt-get install -y curl

#RUN git config --global user.email "jeroldleslie@gmail.com"
#RUN git config --global user.name "jeroldleslie"

RUN DIR=/home/developersetup;if [ -d "$DIR" ]; then printf '%s\n' "Removing DIR ($DIR)"; rm -rf "$DIR";fi
RUN mkdir /home/developersetup
RUN git clone https://git@github.com/jeroldleslie/developer-setup.git /home/developersetup

RUN cd /home/developersetup
RUN bash /home/developersetup/setup.sh
