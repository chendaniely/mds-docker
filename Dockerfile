FROM rocker/geospatial:latest

# rstudio disable authentication
ENV DISABLE_AUTH true

# Install base utilities
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y wget \
    && apt-get install -y \
        gdebi

# Install miniforge
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://github.com/conda-forge/miniforge/releases/download/23.3.1-0/Miniforge3-23.3.1-0-Linux-x86_64.sh -O ~/miniforge3.sh && \
    /bin/bash ~/miniforge3.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

ENV QUARTO_VERSION="1.4.388"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

RUN conda update -n base -c conda-forge conda
RUN conda init --system
RUN conda init --user
RUN . /root/.bashrc
RUN conda install -n base conda-libmamba-solver \
    && conda config --set solver libmamba

RUN conda install -n base -c conda-forge -y \
    python=3.11 \
    jupyter ipykernel jupyterlab \
    pandas numpy scipy scikit-learn

#RUN Rscript -e "install.packages('IRkernel', repos = 'https://cran.rstudio.com/')" \
#    && Rscript -e "IRkernel::installspec(user = FALSE)"

RUN quarto check

RUN whoami && pwd

ENV JUPYTER_ENABLE_LAB yes
RUN nohup jupyter-lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root --LabApp.token='' &
# http://127.0.0.1:8888/

EXPOSE 8787
EXPOSE 8888

WORKDIR ~

CMD ["/init"]
