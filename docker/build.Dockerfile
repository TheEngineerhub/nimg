FROM alpine:latest AS build

# Install dependencies
RUN apk update && apk add nim nimble git gcc musl-dev

# Build
WORKDIR /target
COPY . .
RUN nimble build -d:release -Y

# Run
FROM alpine:latest
COPY --from=build /target/nimg /
CMD ["./nimg"]
