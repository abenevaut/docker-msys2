ARG SERVERCORE_TAG=ltsc2022

FROM mcr.microsoft.com/windows/servercore:$SERVERCORE_TAG

LABEL maintainer="Antoine Benevaut <me@abenevaut.dev>"

RUN	powershell -Command "curl.exe -L \
    $(Invoke-RestMethod \
      -UseBasicParsing https://api.github.com/repos/msys2/msys2-installer/releases/latest | \
      Select -ExpandProperty "assets" | \
      Select -ExpandProperty "browser_download_url" | \
      Select-String -Pattern '.sfx.exe$' \
    ).ToString() \
    --output C:\\Windows\\Temp\\msys2-base.exe" \
  && C:\\Windows\\Temp\\msys2-base.exe

RUN mklink /J C:\\msys64\\home\\ContainerUser C:\\Users\\ContainerUser \
  && setx CHERE_INVOKING "1" \
  && setx MSYS2_PATH_TYPE "inherit" \
  && setx HOME "C:\msys64\home\ContainerUser" \
  && setx /M path "%PATH%;C:\msys64\usr\local\bin;C:\msys64\usr\bin;C:\msys64\bin;C:\msys64\usr\bin\site_perl;C:\msys64\usr\bin\vendor_perl;C:\msys64\usr\bin\core_perl"

RUN	bash -l -c "pacman -Syuu --needed --noconfirm" \
  && bash -l -c "pacman -Syu --needed --noconfirm" \
  && bash -l -c "rm -fr /c/Users/ContainerUser/* /var/cache/pacman/pkg/* /c/Windows/Temp/msys2-base.exe"

WORKDIR C:\\msys64\\home\\ContainerUser\\

SHELL ["C:\\msys64\\usr\\bin\\bash.exe", "--login", "-i", "-l", "-c"]

CMD ["C:\\msys64\\usr\\bin\\bash.exe", "--login", "-i", "-l"]
