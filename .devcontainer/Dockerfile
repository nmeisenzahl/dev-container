FROM ubuntu:focal

ARG TF_VERSION=0.14.10

ENV DEBIAN_FRONTEND=noninteractive

ADD ./src /home/devcontainer/

RUN apt-get update && apt-get install --yes \
    curl \
    wget \
    git \
    zsh \
    fzf \
    vim \
    jq \
    sudo \
    locales-all \
    ca-certificates \
    unzip \
    apt-transport-https \
    lsb-release \
    gnupg \
    software-properties-common \
    build-essential \
    \
    && chsh -s $(which zsh) \
    \
    && useradd -s $(which zsh) \
    -d /home/devcontainer/ \
    -m -G sudo devcontainer \
    && echo "devcontainer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && chown -R devcontainer:devcontainer /home/devcontainer \
    \
    # Oh-my-zsh \
    && /bin/su -s /bin/zsh -c "$(cd /home/devcontainer/ && curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" devcontainer \
    && /bin/su -s /bin/zsh -c "$(mv /home/devcontainer/.zshrc.pre-oh-my-zsh /home/devcontainer/.zshrc)" devcontainer \
    && /bin/su -s /bin/zsh -c "git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/devcontainer/.oh-my-zsh/custom/plugins/zsh-autosuggestions" devcontainer \
    && /bin/su -s /bin/zsh -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/devcontainer/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" devcontainer \
    && /bin/su -s /bin/zsh -c "git clone https://github.com/zsh-users/zsh-completions.git /home/devcontainer/.oh-my-zsh/custom/plugins/zsh-completions" devcontainer \
    \
    # Kubectl
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install --yes kubectl \
    && /bin/su -s /bin/zsh -c "kubectl completion zsh > /home/devcontainer/.oh-my-zsh/custom/plugins/_kubectl" devcontainer \
    \
    # az cli
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install --yes azure-cli \
    \
    # Terraform
    && curl -o tf.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip -d tf tf.zip \
    && chmod +x tf/terraform \
    && mv tf/terraform /usr/bin/ \
    && rm -rf tf* \
    \
    # Docker CLI
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install --yes docker-ce-cli \
    \
    # cleaning
    && chown -R devcontainer:devcontainer /home/devcontainer \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ 

# TODO: bat, helm, kubens, kubectx, azctx, node, gh, kubetail, dotnet, golang

USER devcontainer
