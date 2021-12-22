ARG VERSION=20H2
FROM mcr.microsoft.com/windows/servercore:$VERSION

# Set environment
RUN	setx path "C:\msys64\usr\local\bin;C:\msys64\usr\bin;C:\msys64\bin;C:\msys64\usr\bin\site_perl;C:\msys64\usr\bin\vendor_perl;C:\msys64\usr\bin\core_perl;C:\msys64\clang32\bin;C:\msys64\clang64\bin;C:\msys64\clangarm64\bin;C:\msys64\mingw32\bin;C:\msys64\mingw64\bin\bin;C:\msys64\ucrt64\bin;%PATH%"	

# Download msys2
RUN	powershell -Command " \
		curl.exe -L $(Invoke-RestMethod -UseBasicParsing https://api.github.com/repos/msys2/msys2-installer/releases/latest | \
			Select -ExpandProperty "assets" | \
			Select -ExpandProperty "browser_download_url" | \
			Select-String -Pattern '.sfx.exe$').ToString() \
			--output C:\\windows\\temp\\msys2-base.exe \
	" && \
	C:\\windows\\temp\\msys2-base.exe

RUN	bash -l -c "pacman -Syuu --needed --noconfirm --noprogressbar" && \
	bash -l -c "pacman -Syu --needed --noconfirm --noprogressbar"

# Create directories and cleanup
RUN	bash -c "rm -fr /C/Users/ContainerUser/* /var/cache/pacman/pkg/* /C/Windows/Temp/*" && \
	mklink /J C:\\msys64\\home\\ContainerUser C:\\Users\\ContainerUser && \
	setx HOME  "C:\msys64\home\ContainerUser"

WORKDIR C:\\msys64\\home\\ContainerUser\\
ENV MSYSTEM=MSYS
CMD ["bash", "-l"]
