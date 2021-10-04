FROM bioconductor/bioconductor_docker:RELEASE_3_13

ENV RENV_VERSION 0.14.0

# change directory
WORKDIR /home/rstudio/project

# 各種 apt パッケージと日本語フォント（IPAexフォント）をインストール
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh \
    libxt-dev \
    libxml2-dev \
    libgit2-dev \
    fonts-ipaexfont \
  && apt-get clean

# OS env JP locale (Character, DateTime)
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# install Japanese font
RUN apt-get update && apt-get install -y \
  fonts-ipaexfont \
  fonts-noto-cjk

# install {pacman}
RUN install2.r --deps --error --skipinstalled TRUE \
    BiocManager githubinstall ranger \
    pacman

# remotes と renv をインストール
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_version('renv', version = '${RENV_VERSION}')"

# renv のパッケージキャッシュおよびライブラリルート用フォルダを作成
# SSH の known_hosts に github.com を追加
RUN mkdir -p /home/rstudio/.local/share/renv/cache \
  && mkdir -p /home/rstudio/.ssh \
  && mkdir -p /home/rstudio/.renv/library \
  && ssh-keyscan -t rsa github.com > /home/rstudio/.ssh/known_hosts \
  && chown -R rstudio:rstudio /home/rstudio \
  && chmod 700 /home/rstudio/.ssh

# 設定ファイルをコピー
COPY --chown=rstudio:rstudio .Renviron /home/rstudio/.Renviron
COPY --chown=rstudio:rstudio .ssh/config /home/rstudio/.ssh/config

# 起動スクリプトをコピー
COPY startup.sh /startup

COPY setting.R
RUN Rscript setting.R

# 起動コマンドを変更
CMD [ "/startup" ]
