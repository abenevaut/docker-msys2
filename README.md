# MSYS2 Docker image under Windows
Latest [MSYS2](https://www.msys2.org) based under Microsoft® Windows® Server Docker image (servercore `ltsc2019` & `ltsc2022`).

Currently, only [Server Core](https://hub.docker.com/_/microsoft-windows-servercore) is supported, as MSYS executables are unable to run under [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver); please see [this issue](https://github.com/msys2/MSYS2-packages/issues/1493) for further information.

## Release
| servercore tag | release tag          |
|----------------|----------------------|
| ltsc2022   | latest OR latest-w11 |
| ltsc2019   | latest-w10           |

- [All release](https://hub.docker.com/r/abenevaut/msys2/tags)

## Usage
MSYS (default) interactive shell

The default workdir is `C:\msys64\home\ContainerUser\`. Set another workdir is recommended only for running non-interactive building process like `make`.
```
docker run -it abenevaut/msys2
docker run -it --volume=C:\\path\\to\\project:C:\\msys64\\home\\ContainerUser\\project --workdir="C:\\msys64\\home\\ContainerUser\\project" abenevaut/msys2 make
```

MinGW64 interactive shell
```
docker run -it -e MSYSTEM=MINGW64 abenevaut/msys2
```

MinGW32 interactive shell

If you want to use the MinGW32 environment, you must append `C:\msys64\mingw32\bin` (under CMD shell) to the PATH environment at runtime, or set in an Entrypoint script.
```
docker run -it -e MSYSTEM=MINGW32 abenevaut/msys2
```

You may use the shell of your preference by issuing your alternative CMD. For instance, Bash (`bash`) is the default CMD and shell; you may choose the Windows CMD (`cmd`) or Powershell (`powershell`)

CMD interactive shell
```
docker run -it abenevaut/msys2 cmd
```

Powershell interactive shell
```
docker run -it abenevaut/msys2 powershell
```

## Extending base image
Servercore `ltsc2022` - Windows 11 compatible build
```
FROM abenevaut/msys2:latest

RUN bash -l -c "pacman -S base-devel msys2-devel mingw-w64-{i686,x86_64}-toolchain --needed --noconfirm --noprogressbar"
```

Servercore `ltsc2019` - Windows 10 compatible build
```
FROM abenevaut/msys2:latest-w10

RUN bash -l -c "pacman -S base-devel msys2-devel mingw-w64-{i686,x86_64}-toolchain --needed --noconfirm --noprogressbar"
```

See also:
- [Install Build Tools into a container](https://learn.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2022)
- [MSYS2 Pacman package management](https://www.msys2.org/docs/package-management/)

## Build

- build arguments:
  - SERVERCORE_TAG: ltsc2019 OR ltsc2022, default: ltsc2022

```
docker build --build-arg SERVERCORE_TAG=ltsc2019 -t <your tag> .
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
# OR
SERVERCORE_TAG=ltsc2019 DOCKER_HOST=tcp://127.0.0.1:2375 bundle exec rspec
```

## Licensing
* The **Dockerfile** has been released into the **public domain** (the Unlicense)
* The MSYS2 packages are licensed under several licenses. Please refer to them
* The Windows-based container base image usage is subjected to the **[Microsoft EULA](https://docs.microsoft.com/en-us/virtualization/windowscontainers/images-eula)**

## Note
- https://github.com/mizzy/serverspec/blob/master/WINDOWS_SUPPORT.md
- https://stackoverflow.com/a/62773023/2090870
- https://docs.docker.com/engine/security/protect-access/
