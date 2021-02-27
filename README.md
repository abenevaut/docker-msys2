# MSYS2 Docker image under Windows
This is an attemp to bring the latest [MSYS2](https://www.msys2.org) base under under Microsoft Windows Server Docker image, intended to be used in my own projects.

Currently, only [Server Core](https://hub.docker.com/_/microsoft-windows-servercore) is supported, as MSYS executables are unable to run under [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver). 

## Usage
MSYS (default) interactive shell
```
docker run -it --volume=host-src:container-dest --workdir="container-dest" amitie10g/mingw-w64-toolchain
```

MinGW64 interactive shell
```
docker run -e MSYSTEM=MINGW64 --volume=host-src:container-dest --workdir="container-dest" amitie10g/mingw-w64-toolchain
```

MinGW32 interactive shell
```
docker run -e MSYSTEM=MINGW32 --volume=host-src:container-dest --workdir="container-dest" amitie10g/mingw-w64-toolchain
```

CMD interactive shell
```
docker run --volume=host-src:container-dest --workdir="container-dest" amitie10g/mingw-w64-toolchain cmd
```

Powershell interactive shell
```
docker run --volume=host-src:container-dest --workdir="container-dest" amitie10g/mingw-w64-toolchain powershell
```

You may use the shell of your preference by issuing your alternative CMD. For instance, Bash (``bash``) is the default CMD and shell; you may choose the Windows CMD (``cmd``) or Powershell (``powershell``)

If you want to use the MinGW32 environment, you must append ``C:\msys64\mingw32\bin``(under CMD shell) to the PATH environment at runtime, or set in an Entrypoint script.

The default workdir is ``C:\msys64``. Set another workdir is recommended only for runing non-interactive building process like ``make``.

## Using this base image
If you're want to install packages under mingw32 or mingw64 environment, add the following in your Dockerfile, in order to set the proper PATH environment:

```RUN setx path "C:\msys64\mingw64\bin;%PATH%"```

If you prefer to use an Entrypoint script, set the PATH environment as following:

```setx path "C:\msys64\mingw64\bin;%PATH%"```

## Windows Server version tags:

* ``latest`` (20H2-KB4601319)
* ``20H2`` (20H2)
* ``ltsc`` (ltsc2019)
* <s>``insider`` (10.0.20295.1)</s>

## Licensing
* The **Dockerfile** has been released into the **public domain** (the Unlicense)
* The Docker image usages are subjected to the **[Microsoft EULA](https://docs.microsoft.com/en-us/virtualization/windowscontainers/images-eula)**