# Usa l'immagine di base Debian Buster
FROM debian:buster

# Aggiorna i repository e installa i pacchetti necessari
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        perl \
        nginx \
        bash \
        openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crea la directory per i socket di nginx
RUN mkdir -p /run/nginx  

# Copia il file di configurazione nginx personalizzato nella directory appropriata
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Crea directory per i certificati SSL
RUN mkdir /etc/nginx/ssl

# Genera un certificato SSL autofirmato per HTTPS
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/vpescete.crt \
       -keyout /etc/nginx/ssl/vpescete.key \
       -subj "/C=IT/ST=Rome/L=Rome/O=42 School/OU=vpescete/CN=vpescete/"

# Espone la porta 443 per le connessioni HTTPS
EXPOSE 443

# Avvia il server nginx in primo piano (foreground)
CMD ["nginx", "-g", "daemon off;"]
