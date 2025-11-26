FROM debian

ARG USERNAME=kedwards
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV TZ=Canada/Mountain
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    bats \
    kcov \
    sudo \
    tzdata \
    parallel \
    build-essential \
    ca-certificates

RUN apt-get update && \
    install -dm 755 /etc/apt/keyrings && \
    curl -fSs https://mise.jdx.dev/gpg-key.pub | tee /etc/apt/keyrings/mise-archive-keyring.pub 1> /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.pub arch=amd64] https://mise.jdx.dev/deb stable main" | tee /etc/apt/sources.list.d/mise.list && \
    apt-get update && \
    apt-get install -y mise

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -G sudo -s /bin/bash \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME/.local/share/chezmoi

RUN sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

RUN mkdir -p ~/.local/share/fonts
RUN mkdir -p /tmp