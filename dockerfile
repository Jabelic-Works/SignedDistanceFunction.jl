FROM julia:1.5.3

RUN apt-get update
RUN apt-get -yq install git make

# 論理プロセッサ数
WORKDIR /workdir
RUN julia -e 'using Pkg; Pkg.add("PackageCompiler")'
