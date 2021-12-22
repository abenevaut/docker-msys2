ARG VERSION=20H2
FROM amitie10g/chocolatey:$VERSION

RUN choco install msys2 -y --params "/NoUpdate /InstallDir:C:\msys2"
