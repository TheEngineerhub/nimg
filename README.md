# nimg

**nimg** is a simple (~100 lines) self-hosted image hosting service written in [nim](https://nim-lang.org). I created this initally to store my screenshots captured with Flameshot.

## How to use

It's basically a RESTful service. There is no complex auth mechanism such as JWT or a database. You just set a token with environment variable to manage assets.

#

- Get image:

`GET: http://localhost:8080/i/image.png`

- Upload image:

`POST: http://localhost:8080/u?token=super-secret`.

- Delete image:

`GET: http://localhost:8080/d/image.png?token=super-secret`

#

- **token** query string is always required for **delete image**.
- If public upload is disabled you also need to use your token.

## How to setup

Easiest way to install nimg is using [docker-compose](https://docs.docker.com/compose/).

- Download the [compose file](./docker-compose.yml).
- Edit environment variables.
- Run:

```sh
$ docker-compose up
```

- After that you should use reverse proxy to expose nimg to world. Such as [Nginx Proxy Manager](https://nginxproxymanager.com/), it's a easy to use, well known solution.

#

> Build from source.

- Install nim and nimble and command below should do the trick. Make sure to create [.env](.env.example).

```sh
$ export NIMG_ENVIRONMENT=development
$ nimble run
```

## License

This repository is licensed under [GPLv3 License](LICENSE.md).
