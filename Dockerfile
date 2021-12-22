ARG VERSION=20H2
FROM amitie10g/chocolatey:$VERSION

RUN choco install -y msys2
