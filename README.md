# Docker

## Написать Docker-compose для приложения Redmine

Был написан файл [docker-compose.yml)](redmine/docker-compose.yml) для запуска **Redmine** и [Dockerfile](redmine/Dockerfile) для добавления темы **Bleuclair** в **Redmine**.

Запустить **Redmine** в первый раз можно следующими командами:

```shell
cd redmine
./gen-passwd.sh
docker compose up -d
```

**Redmine** будет доступен по адресу [127.0.0.1:8080](http://127.0.0.1:8080/). Для входа необходимо использовать имя пользователя **admin** и пароль **admin**. Тема **Bleuclair** будет доступна в [Administration -> Settings -> Display](http://127.0.0.1:8080/settings?tab=display).

Вся необходимая информация сохраняется на томах **redmine_files**, **redmine_plugin_assets** и **redmine_dbdata**, присутствующих в выводе `docker volume ls`.

## Создайте свой кастомный образ nginx на базе alpine

Вместо **nginx** взят **angie**. Написан [Dockerfile](nginx/Dockerfile) и кастомная страница [index.html](nginx/index.html). Для того, чтобы собрать образ необходимо выполнить:

```shell
cd nginx
docker build . --tag abegorov/angie:1.6.2-alpine --tag abegorov/angie:latest
docker login
docker push abegorov/angie:1.6.2-alpine
docker push abegorov/angie:latest
```

После этого образ **angie** будет доступен по ссылке [hub.docker.com/r/abegorov/angie](https://hub.docker.com/r/abegorov/angie). Запустить его можно командами:

```shell
docker run -d -p 127.0.0.1:8080:80 --rm abegorov/angie
```

Кастомная страница будет доступна по адресу [localhost:8080](http://localhost:8080/).

## Определите разницу между контейнером и образом

**Контейнер** - это экземпляр запущенного из образа приложения. Он может быть запущен, остановлен и перезапущен. **Образ** представляет из себя приложение со всеми своими зависимостями. Он не может быть запущен непосредственно, однако из него можно создать и запустить несколько контейнеров.
Список всех образов доступен по команде `docker images`. Список контейнеров доступен по команде `docker ps -a`.

## Можно ли в контейнере собрать ядро?

Соберём ядро в контейнере. Для этого соберём свой образ контейнера из [Dockerfile](linux-builder/Dockerfile) и запустим его:

```shell
docker run -it --rm abegorov/linux-builder
download 6.11-rc7
make defconfig
make -j $(nproc)
make bindeb-pkg
make binrpm-pkg
```

Ядро успешно собралось:

```text
root@99c3a626bf7e:/build/linux# ls -la /build
total 23988
drwxr-xr-x 1 root root      436 Sep 11 11:15 .
drwxr-xr-x 1 root root       30 Sep 11 11:11 ..
drwxr-xr-x 1 root root     2108 Sep 11 11:18 linux
-rw-r--r-- 1 root root  9078308 Sep 11 11:15 linux-headers-6.11.0-rc7_6.11.0-rc7-2_amd64.deb
-rw-r--r-- 1 root root 14079496 Sep 11 11:15 linux-image-6.11.0-rc7_6.11.0-rc7-2_amd64.deb
-rw-r--r-- 1 root root  1385684 Sep 11 11:15 linux-libc-dev_6.11.0-rc7-2_amd64.deb
-rw-r--r-- 1 root root     6116 Sep 11 11:15 linux-upstream_6.11.0-rc7-2_amd64.buildinfo
-rw-r--r-- 1 root root     1894 Sep 11 11:15 linux-upstream_6.11.0-rc7-2_amd64.changes
root@99c3a626bf7e:/build/linux# ls -la /build/linux/rpmbuild/RPMS/x86_64/
total 28740
drwxr-xr-x 1 root root      208 Sep 11 11:15 .
drwxr-xr-x 1 root root       12 Sep 11 11:15 ..
-rw-r--r-- 1 root root 14543760 Sep 11 11:15 kernel-6.11.0_rc7-3.x86_64.rpm
-rw-r--r-- 1 root root 12987076 Sep 11 11:15 kernel-devel-6.11.0_rc7-3.x86_64.rpm
-rw-r--r-- 1 root root  1895319 Sep 11 11:15 kernel-headers-6.11.0_rc7-3.x86_64.rpm
```

А вот поставить его в контейнер нельзя, так как контейнер использует ядро хостовой системы.
