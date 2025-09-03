# Select the OS
FROM ubuntu:20.04

# Make some updates
RUN apt-get update && apt-get -y install nmap wget nano vim

# Create the kite user
RUN useradd -m -d /home/kite kite
RUN echo "kite" > pwd
RUN echo "kite" >> pwd
RUN passwd -q kite < pwd
RUN rm pwd

RUN mkdir /home/kite/howto-howto
WORKDIR /home/kite

# Copy Kite content
COPY ./tmp /home/kite/howto-howto

# Update .bashrc
RUN echo "" >> /home/kite/.bashrc
RUN echo "PATH=\$PATH:/home/kite/howto-howto/Script" >> /home/kite/.bashrc
RUN chown -R kite:kite /home/kite
RUN chown kite:kite /home/kite/.bashrc

CMD /bin/bash
