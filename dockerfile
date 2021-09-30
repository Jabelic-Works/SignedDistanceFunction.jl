FROM julia:1.5.3

RUN apt-get update
# PackageCompiler needs gcc
RUN apt-get -yq install git make gcc

# 論理プロセッサ数
WORKDIR /workdir
RUN julia -e 'using Pkg; Pkg.add("PackageCompiler")'
