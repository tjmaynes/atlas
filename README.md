# Atlas
> Configuration files and automation (install, backup, and restore) scripts for my home server.

| Program                                                    | Usage                              | Tools                      | Status |
| :--------------------------------------------------------- | :--------------------------------: | :------------------------: | :----: |
| [gitea](https://gitea.io/en-us/)                           | git server                         | docker-compose             | ✅ |
| [jellyfin](https://jellyfin.org/)                          | media server                       | docker-compose             | ✅ |
| [tinyMediaManager](https://www.tinymediamanager.org/)      | media management server            | docker-compose             | 🚧 |
| [bitwarden](https://bitwarden.com/)                        | password-manager                   | docker-compose             | 🚧 |
| [calibre-web](https://github.com/janeczku/calibre-web)     | web-based ebook-reader             | docker-compose             | 🚧 |

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Docker](https://www.docker.com/#)
- [Vagrant](https://www.vagrantup.com/)

## Usage
To start the home server, run the following command:
```bash
make start
```

To backup the home server, run the following command:
```bash
make backup
```

To stop the home server, run the following command:
```bash
make stop
```

To test everything works via Vagrant, run the following command:
```bash
make dev
```