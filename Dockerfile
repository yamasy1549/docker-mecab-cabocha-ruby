FROM centos:centos7

ENV LANG=C.UTF-8

########################
## Ruby
########################

FROM ruby:2.5

########################
## MeCab
########################

RUN mkdir tools

RUN cd tools \
      && curl -L -o mecab-0.996.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" \
      && tar zxfv mecab-0.996.tar.gz \
      && rm mecab-0.996.tar.gz \
      && cd mecab-0.996 \
      && ./configure --with-charset=utf-8 \
      && make \
      && make install

RUN ldconfig

RUN cd tools \
      && curl -L -o mecab-ipadic-2.7.0-20070801.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" \
      && tar zxfv mecab-ipadic-2.7.0-20070801.tar.gz \
      && rm mecab-ipadic-2.7.0-20070801.tar.gz \
      && cd mecab-ipadic-2.7.0-20070801 \
      && ./configure --with-charset=utf8 \
      && make \
      && make install

RUN ldconfig

RUN cd tools \
      && curl -L -o mecab-ruby-0.996.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7VUNlczBWVDZJbE0" \
      && tar zxfv mecab-ruby-0.996.tar.gz \
      && rm mecab-ruby-0.996.tar.gz \
      && cd mecab-ruby-0.996 \
      && sed -i -e "/CFLAGS/a \$LDFLAGS\ =\ '-L/usr/local/lib'" extconf.rb \
      && ruby extconf.rb \
      && make \
      && make install

RUN ldconfig

########################
## CaboCha
########################

#RUN cd tools \
#      && curl -L -o CRF++-0.58.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ" \
#      && tar zxfv CRF++-0.58.tar.gz \
#      && rm CRF++-0.58.tar.gz \
#      && cd CRF++-0.58 \
#      && ./configure \
#      && make \
#      && make install
#
#RUN ldconfig
#
#RUN cd tools \
#      && curl -c /tmp/cookie.txt -s -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU" | grep confirm |  sed -e "s/^.*confirm=\(.*\)&amp;id=.*$/\1/" | xargs -I{} \
#         curl -b /tmp/cookie.txt  -L -o cabocha-0.69.tar.bz2 "https://drive.google.com/uc?confirm={}&export=download&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU" \
#      && tar jxvf cabocha-0.69.tar.bz2 \
#      && rm cabocha-0.69.tar.bz2 \
#      && cd cabocha-0.69 \
#      && ./configure --with-charset=utf8 \
#      && make \
#      && make install
#
#RUN ldconfig
#
#RUN cd tools \
#      && curl -L -o pcre-8.41.tar.gz "https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.gz" \
#      && tar zxfv pcre-8.41.tar.gz \
#      && rm pcre-8.41.tar.gz \
#      && cd pcre-8.41 \
#      && ./configure \
#      && make \
#      && make install
#
#RUN ldconfig
#
#RUN cd tools \
#      && curl -L -o swig-3.0.12.tar.gz "http://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz" \
#      && tar zxfv swig-3.0.12.tar.gz \
#      && rm swig-3.0.12.tar.gz \
#      && cd swig-3.0.12 \
#      && ./configure \
#      && make \
#      && make install
#
#RUN ldconfig
#
#RUN cd tools \
#      && cd cabocha-0.69/swig \
#      && make ruby \
#      && cd ../ruby/ \
#      && ruby extconf.rb \
#      && make \
#      && make install
#
#RUN ldconfig

########################
## Python
########################

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
RUN git clone https://github.com/yyuu/pyenv.git $HOME/.pyenv
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
      && eval "$(pyenv init -)"
RUN CONFIGURE_OPTS="--enable-shared" pyenv install 3.6.3 && \
    pyenv global 3.6.3

########################
## PyCall
########################

RUN gem install pry
RUN gem install --pre pycall
