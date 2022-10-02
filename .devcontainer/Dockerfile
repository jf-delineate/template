# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/alpine/.devcontainer/base.Dockerfile
ARG VARIANT="3.16"

FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-${VARIANT}

ENV PYTHONUNBUFFERED=1
ENV TFENV_DIR /installs/tfenv
ENV TFENV_VERSION 1.3.1

# program installs ----------------------------------------------------------------

RUN apk update \
    && apk add --no-cache go-task python3-dev nodejs npm gcc musl-dev acl
RUN curl -fLSs https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh | bash
RUN python3 -m ensurepip


#  renames ------------------------------------------------------------------------

RUN ln -sf go-task /usr/bin/task
RUN ln -sf python3 /usr/bin/python
RUN ln -sf pip3 /usr/bin/pip
RUN ln -s $TFENV_DIR/bin/tfenv /usr/local/bin
RUN ln -s $TFENV_DIR/bin/terraform /usr/local/bin

#  pip installs -------------------------------------------------------------------

COPY ./requirements.txt /usr/
RUN pip install --no-cache --upgrade pip setuptools
RUN pip install -r /usr/requirements.txt

#  tfenv --------------------------------------------------------------------------
RUN mkdir -p $TFENV_DIR
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git $TFENV_DIR
RUN setfacl -R -m u:vscode:rwx $TFENV_DIR
RUN tfenv install $TFENV_VERSION
RUN tfenv use $TFENV_VERSION

#  init ---------------------------------------------------------------------------

RUN echo "task init" | tee -a /home/vscode/.bashrc >> /home/vscode/.zshrc
