# Alpine xfce4 noVNC

[![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0/)

Simple and minimal Alpine Docker Image providing XFCE4 through html5 noVNC connection.

## Build Container

```bash
docker compose build
```

Optionally an user and password can be passed when building the image. Simply update the `.env` file with the desired username and password.

```sh
USERNAME=<some username>
PASSWORD=<some password>
```

## Start Container

```bash
docker compose up
```

## Connect With noVNC

Use modern browser to connect to `http://localhost:6080/vnc.html`. 

The pre-defined username and password are `user` and `p@ssw0rd123` respectively. These are used if no username and password are passed when building the image. If you would like to set your own username and password, simply update the `.env` file with the desired username and password as mentioned above.

## LICENCE

MIT
