FROM alpine:3.16.0 AS build

# Install dependencies
RUN apk update && apk add nim nimble git gcc musl-dev

# Build
WORKDIR /target
COPY . .
RUN nimble build -d:release -Y

# Run
FROM alpine:3.16.0
COPY --from=build /target/nimg /
ENV NIMG_ENVIRONMENT=production
CMD ["./nimg"]
