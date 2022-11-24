FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade && \
    apt-get install -y curl

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs make g++

RUN npm install hardhat -g

EXPOSE 8545 8546

ENTRYPOINT [ "bash" ]
