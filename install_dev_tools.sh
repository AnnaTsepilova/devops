#!/bin/bash

sudo apt update

# --- Docker ---
if ! command -v docker &> /dev/null; then
    echo "Встановлюємо Docker..."
    sudo apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) \
      signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo usermod -aG docker "$USER"
    echo "Docker встановлено."
else
    echo "Docker вже встановлено."
fi

# --- Python 3.10+ ---
if command -v python3 &> /dev/null && [[ $(python3 -V | cut -d ' ' -f2) > 3.9 ]]; then
    echo "Python3 вже встановлено ($(python3 -V))"
else
    echo "Встановлюємо Python 3.10..."
    sudo apt install -y python3.10 python3.10-venv python3.10-distutils

    # Оновити python3 та pip на нову версію, якщо треба
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
    curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.10
    echo "Python $(python3 -V) встановлено."
fi

# --- pip ---
if ! command -v pip3 &> /dev/null; then
    echo "Встановлюємо pip..."
    sudo apt install -y python3-pip
else
    echo "pip вже встановлено."
fi

# --- Django ---
if ! python3 -m django --version &> /dev/null; then
    echo "Встановлюємо Django..."
    pip3 install --user Django
    echo "Django встановлено ($(python3 -m django --version))"
else
    echo "Django вже встановлено ($(python3 -m django --version))"
fi

echo "Успішно завершено встановлення всіх інструментів!"
