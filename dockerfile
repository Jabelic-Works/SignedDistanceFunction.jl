FROM julia:1.5.3

RUN apt-get update
RUN apt-get -yq install git make
# RUN git config --global user.name "jabelic"
# RUN git config --global user.email "Your email"

# 論理プロセッサ数
# $ fgrep 'processor' /proc/cpuinfo | wc -l
# shellに移動？ 環境(docker, mac, ...)を調べて, dockerなら以下をecho.
WORKDIR /workdir
RUN echo "export JULIA_NUM_THREADS=8" >> ~/.bashrc
RUN julia -e 'using Pkg; Pkg.add("PackageCompiler")'
