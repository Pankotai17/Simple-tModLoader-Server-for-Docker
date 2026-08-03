FROM ubuntu:24.04

WORKDIR /usr/local/tml-server

COPY . .

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    ca-certificates \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

RUN chmod u+x server.sh

CMD ["./server.sh"]

