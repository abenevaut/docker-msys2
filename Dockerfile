ARG VERSION=ltsc2022
FROM mcr.microsoft.com/windows/servercore:$VERSION

# Set environment
RUN	setx path "C:\msys64\usr\local\bin;C:\msys64\usr\bin;C:\msys64\bin;C:\msys64\usr\bin\site_perl;C:\msys64\usr\bin\vendor_perl;C:\msys64\usr\bin\core_perl;%PATH%"	

# Download msys2
SHELL ["powershell", "-Command"]  
RUN curl.exe -L $(Invoke-RestMethod -UseBasicParsing https://api.github.com/repos/msys2/msys2-installer/releases/latest | \
			Select -ExpandProperty "assets" | \
			Select -ExpandProperty "browser_download_url" | \
			Select-String -Pattern '.sfx.exe$').ToString() \
		--output C:\\windows\\temp\\msys2-base.exe ; \
	C:\\windows\\temp\\msys2-base.exe ; \
	Remove-Item –path C:\Windows\Temp\*

SHELL ["bash", "-l", "-c"]
RUN "pacman -Syuu --needed --noconfirm --noprogressbar"
RUN "pacman -Syu --needed --noconfirm --noprogressbar"
RUN "rm -fr /C/Users/ContainerUser/* /var/cache/pacman/pkg/*"

SHELL ["cmd", "/S", "/C"]
RUN mklink /J C:\\msys64\\home\\ContainerUser C:\\Users\\ContainerUser && \
	setx HOME  "C:\msys64\home\ContainerUser"

WORKDIR C:\\msys64\\home\\ContainerUser\\
ENV MSYSTEM=MSYS
CMD ["bash", "-l"]
