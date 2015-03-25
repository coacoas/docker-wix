FROM monokrome/wine
MAINTAINER Stefan Thomas <justmoon@members.fsf.org>

# Wget is needed by winetricks
RUN apt-get update
RUN apt-get install -y curl

# Wine really doesn't like to be run as root, so let's set up a non-root
# environment
RUN useradd -d /home/wix -m -s /bin/bash wix
USER wix
ENV HOME /home/wix
ENV WINEPREFIX /home/wix/.wine
ENV WINEARCH win32

# Install .NET Framework 4.0
RUN wine wineboot && xvfb-run winetricks --unattended dotnet40 corefonts

# Install WiX
RUN mkdir /home/wix/wix
WORKDIR /home/wix/wix
RUN curl -o wix-binaries.zip "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=wix&DownloadId=1421697&FileTime=130661188723230000&Build=20959"
RUN unzip wix-binaries.zip && rm wix-binaries.zip
ENV WINEDEBUG fixme-all
