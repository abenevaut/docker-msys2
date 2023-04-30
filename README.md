# MSYS2 Docker image under Windows
Latest [MSYS2](https://www.msys2.org) based under Microsoft® Windows® Server Docker image (servercore `ltsc2019` & `ltsc2022`).

Currently, only [Server Core](https://hub.docker.com/_/microsoft-windows-servercore) is supported, as MSYS executables are unable to run under [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver); please see [this issue](https://github.com/msys2/MSYS2-packages/issues/1493) for further information.

## Usage
MSYS (default) interactive shell

The default workdir is `C:\msys64\home\ContainerUser\`. Set another workdir is recommended only for running non-interactive building process like `make`.

Note: no toolchain are included in that image

```
docker run -it abenevaut/msys2
docker run -it --volume=host-src:container-dest --workdir="container-dest" abenevaut/msys2 make
```

MinGW64 interactive shell
```
docker run -e MSYSTEM=MINGW64 abenevaut/msys2
```

MinGW32 interactive shell

If you want to use the MinGW32 environment, you must append ``C:\msys64\mingw32\bin``(under CMD shell) to the PATH environment at runtime, or set in an Entrypoint script.

```
docker run -e MSYSTEM=MINGW32 abenevaut/msys2
```

You may use the shell of your preference by issuing your alternative CMD. For instance, Bash (``bash``) is the default CMD and shell; you may choose the Windows CMD (``cmd``) or Powershell (``powershell``)

CMD interactive shell
```
docker run abenevaut/msys2 cmd
```

Powershell interactive shell
```
docker run abenevaut/msys2 powershell
```

## Extending base image
Servercore `ltsc2022` - Windows 11 compatible build
```
FROM abenevaut/msys2:latest-windows11

RUN bash -l -c "pacman -S base-devel msys2-devel mingw-w64-{i686,x86_64}-toolchain --needed --noconfirm --noprogressbar"
```

Servercore `ltsc2019` - Windows 10 compatible build
```
FROM abenevaut/msys2:latest-windows10

RUN bash -l -c "pacman -S base-devel msys2-devel mingw-w64-{i686,x86_64}-toolchain --needed --noconfirm --noprogressbar"
```

## Build
```
docker build --build-arg VERSION=ltsc2019 -t <your tag> .
```

## Testing
Required Ruby 2.7.
Note: in case you are using Ruby on Windows with msys2, you have to install toolchain (probably `pacman -S base-devel msys2-devel mingw-w64-x86_64-toolchain`)
```
gem install bundler
bundle config path vendor/bundle
bundle install
# Spec linter
bundle exec rubocop
# Lint Dockerfile
docker run --rm -i hadolint/hadolint < Dockerfile
# Test docker image
DOCKER_HOST=tcp://127.0.0.1:2375 bundle exec rspec
```

## Licensing
* The **Dockerfile** has been released into the **public domain** (the Unlicense)
* The MSYS2 packages are licensed under several licenses. Please refer to them
* The Windows-based container base image usage is subjected to the **[Microsoft EULA](https://docs.microsoft.com/en-us/virtualization/windowscontainers/images-eula)**
