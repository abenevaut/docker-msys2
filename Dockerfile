ARG WINDOWS_VERSION=20H2-KB4601319
FROM mcr.microsoft.com/windows/servercore:$WINDOWS_VERSION

# Download msys2
SHELL ["powershell"]
ARG MSYS_DOWNLOAD_URL
RUN curl.exe -L $(Invoke-RestMethod -UseBasicParsing https://api.github.com/repos/msys2/msys2-installer/releases/latest | \
		Select -ExpandProperty "assets" | \
		Select -ExpandProperty "browser_download_url" | \
		Select-String -Pattern '.sfx.exe$').ToString() \
		--output C:\\windows\\temp\\msys2-base.exe ; \
	C:\\windows\\temp\\msys2-base.exe ; \
	del C:\\windows\\temp\\msys2-base.exe

SHELL ["cmd", "/S", "/C"]
WORKDIR C:\\msys64
RUN setx path "C:\msys64\usr\local\bin;C:\msys64\usr\bin;C:\msys64\bin;C:\msys64\usr\bin\site_perl;C:\msys64\usr\bin\vendor_perl;C:\msys64\usr\bin\core_perl;%PATH%"
RUN bash -l -c "pacman -Syuu --needed --noconfirm --noprogressbar" && \
	bash -l -c "pacman -Syu --needed --noconfirm --noprogressbar" && \
	bash -l -c "pacman -Sy --needed --noconfirm --noprogressbar" && \
	bash -l -c "pacman --noconfirm -S tar zip unzip && rm -r /var/cache/pacman/pkg/*"

ENV MSYSTEM=MSYS
CMD ["bash"]