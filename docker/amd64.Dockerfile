FROM debian:bullseye-slim AS build

# Install dependencies
RUN apt -qq update && apt -qq -y install bash git curl gcc xz-utils && rm -rf /var/lib/apt/lists/*
RUN curl --create-dirs -O --output-dir /tmp/choosenim https://nim-lang.org/choosenim/init.sh && cd /tmp/choosenim && bash ./init.sh -y

# Add choosenim to path
ENV PATH "$PATH:/root/.nimble/bin"

# Build
WORKDIR /target
COPY . .
RUN nimble build -d:release -Y

# Run
FROM debian:bullseye-slim
COPY --from=build /target/nimg /
CMD ["./nimg"]
