FROM Ubuntu:20.04
RUN /var/www/nopCommerce && \
    wget https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.0/nopCommerce_4.60.0_NoSource_linux_x64.zip && \
    apt-get install unzip && \
    unzip nopCommerce_4.60.0_NoSource_linux_x64.zip
WORKDIR /bin/lib
EXPOSE 80
CMD ["/usr/bin/dotnet", "/var/www/nopCommerce/Nop.Web.dll"]