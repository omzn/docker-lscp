FROM python:3

LABEL maintainer "Osamu Mizuno <o-mizuno@kit.ac.jp>"

WORKDIR /home/work_dir

# install lscp
RUN apt update -y 
RUN apt install -y git sudo cpanminus
RUN cpanm Test::Files --force 
RUN cpanm File::Basename File::Find File::Slurp Lingua::Stem \
                FindBin Log::Log4perl Regexp::Common Exporter 
RUN git clone --depth=1 https://github.com/doofuslarge/lscp.git
RUN cd lscp \
    && perl Makefile.PL \
    && make \
    && make test \
    && sudo make install

COPY ["./lscp_templates/lscp.pl", "/usr/local/bin/lscp"]
WORKDIR /home/user_dir
CMD ["echo", "This is a base image for LSCP."]
CMD ["echo", "Use 'docker run --rm -it -v .:/home/user_dir lscp lscp -h' to see help."]

