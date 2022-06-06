FROM debian:latest

# Install dependencies
RUN apt update && apt install git curl gcc xz-utils -y
RUN curl --create-dirs -O --output-dir /tmp/choosenim https://nim-lang.org/choosenim/init.sh && cd /tmp/choosenim && bash ./init.sh -y

# Add choosenim to path
ENV PATH "$PATH:/root/.nimble/bin"

# Build
WORKDIR /nimg
COPY . .
RUN nimble build -d:release -Y

# Run
CMD ["./nimg"]
