# MSYS2 Docker image under Windows
This is an attemp to bring the latest [MSYS2](https://www.msys2.org) base under under Microsoft® Windows® Server Docker image, intended to be used in my own projects.

Currently, only [Server Core](https://hub.docker.com/_/microsoft-windows-servercore) is supported, as MSYS executables are unable to run under [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver). 

## Tags
The tags belong to the Windows version. Available tags are:

* ``20H2``
* ``2004`` (``latest``)
* ``1909``
* ``1903``
* ``ltsc2019``

It is recommended to use the tag corresponding to your host version.

## Usage
MSYS (default) interactive shell
```
docker run -it --volume=host-src:container-dest --workdir="container-dest" amitie10g/msys2
```

MinGW64 interactive shell
```
docker run -e MSYSTEM=MINGW64 --volume=host-src:container-dest --workdir="container-dest" amitie10g/msys2
```

MinGW32 interactive shell
```
docker run -e MSYSTEM=MINGW32 --volume=host-src:container-dest --workdir="container-dest" amitie10g/msys2
```

CMD interactive shell
```
docker run --volume=host-src:container-dest --workdir="container-dest" amitie10g/msys2 cmd
```

Powershell interactive shell
```
docker run --volume=host-src:container-dest --workdir="container-dest" amitie10g/msys2 powershell
```

You may use the shell of your preference by issuing your alternative CMD. For instance, Bash (``bash``) is the default CMD and shell; you may choose the Windows CMD (``cmd``) or Powershell (``powershell``)

If you want to use the MinGW32 environment, you must append ``C:\msys64\mingw32\bin``(under CMD shell) to the PATH environment at runtime, or set in an Entrypoint script.

The default workdir is ``C:\msys64``. Set another workdir is recommended only for runing non-interactive building process like ``make``.

## Using this base image
Dockerfile
```
ARG WINDOWS_VERSION=latest
FROM amitie10g/msys2:$WINDOWS_VERSION

<your code>
```

Command line
```
docker build --build-arg WINDOWS_VERSION=20H2 -t <your tag> .
```

## Caveats
Due the Windows Server Core base image, this image is HUGE. I'm researching how to use Nano Server instead.

## Licensing
* The **Dockerfile** has been released into the **public domain** (the Unlicense)
* The Docker image usages are subjected to the **[Microsoft EULA](https://docs.microsoft.com/en-us/virtualization/windowscontainers/images-eula)**