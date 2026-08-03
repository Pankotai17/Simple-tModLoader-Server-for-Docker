#Simple tModLoader Server for Docker

![Docker Pulls](https://img.shields.io/docker/pulls/pankotai17/tmodloader-server)
![Docker Image Size](https://img.shields.io/docker/image-size/pankotai17/tmodloader-server)

A lightweight, automated Docker container for running a **tModLoader** server (Terraria). Supports auto-world creation, environment-variable configuration, and automatic mod activation.


## Quick Start

### Using Docker Compose (Recommended)

1. Create a `docker-compose.yml` file in your project directory:

```yaml
version: "3.8"

services:
  tml-server:
    image: pankotai17/tmodloader-server:latest
    container_name: tmodloader_server
    ports:
      - "7777:7777/tcp"
      - "7777:7777/udp"
    environment:
      - WORLD_NAME=MyWorld # if set the server will auto start the world with that name, also will use it with autocreate
      - AUTOCREATE=2       # 1=Small, 2=Medium, 3=Large
      - DIFFICULTY=1       # 0=Classic, 1=Expert, 2=Master, 3=Journey
      - MAX_PLAYERS=16
      - MOTD=Welcome to the server!
      - PASSWORD=PASSWORD  
      - LANGUAGE=en-US
    volumes:
      - /WORLDS_FOLDER/CHANGE_ME:/usr/local/tml-server/worlds
      - /MODS_FOLDER/CHANGE_ME:/usr/local/tml-server/mods
    restart: unless-stopped
    stdin_open: true
    tty: true
```
Alternatively if you don't include any of the environment variables, the server will guide you through making a world. Add WORLD_NAME= and the worlds name you just created for it to auto start after every restart

2. Start the server:

```bash
docker compose up -d
```

3. View live logs:

```bash
docker compose logs -f
```

---

### Using Docker CLI

```bash
docker run -d \
  --name tmodloader_server \
  -p 7777:7777/tcp \
  -p 7777:7777/udp \
  -e WORLD_NAME="MyWorld" \
  -e AUTOCREATE="2" \
  -e DIFFICULTY="1" \
  -v "$(pwd)/worlds:/usr/local/tml-server/worlds" \
  -v "$(pwd)/mods:/usr/local/tml-server/mods" \
  pankotai17/tmodloader-server:latest
```

---

## Environment Variables

| Variable | Default | Description |
| :--- | :--- | :--- |
| `WORLD_NAME` | *None* | Name of the world to load or auto-create. |
| `AUTOCREATE` | *None* | World size if creation is triggered: `1` (Small), `2` (Medium), `3` (Large). |
| `SEED` | *None* | World generation seed. |
| `DIFFICULTY` | `0` | World difficulty: `0` (Classic), `1` (Expert), `2` (Master), `3` (Journey). |
| `MAX_PLAYERS` | `16` | Maximum number of connected players. |
| `PASSWORD` | *None* | Server password (leave blank for no password). |
| `MOTD` | *None* | Message of the Day shown to joining players. |
| `LANGUAGE` | `en-US` | Server language settings. English = en-US, German = de-DE, Italian = it-IT, French = fr-FR, Spanish = es-ES, Russian = ru-RU, Chinese = zh-Hans, Portuguese = pt-BR, Polish = pl-PL |

---

## Managing Mods

1. Drop your `.tmod` files directly into the mapped `./mods` volume on your host.
2. When the server boots up, it checks if `enabled.json` exists. If not, it automatically registers and enables all `.tmod` files inside the folder.

---

## License

Distributed under the [MIT License](LICENSE).
