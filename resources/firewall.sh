#!/bin/sh
###
# Script Pare-feu pour Linux utilisant iptables
# Le script est commenté mais n'offre aucune garantie
# A vous de l'adapter à vos besoins !
###
# Mise à 0
iptables -t filter -F
iptables -t nat -F
iptables -t mangle -F
iptables -t filter -X
iptables -t nat -X
iptables -t mangle -X
echo "Mise à 0 faite"
# On bloque tout
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP
# On drop les scans XMAS et NULL
# La premiere partie de tcp-flags = les flags à vérifier, la deuxième partie = les flages qui doivent être à un
# xmas :
iptables -A INPUT -p tcp --tcp-flags FIN,URG,PSH FIN,URG,PSH -j DROP
# null scan : "tous les flags" (ALL) nuls (NONE)
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
# autres configurations bizarres... :
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
# Rejette silencieusement tous les paquets broadcastés (pkttype définit un type de paquets)
iptables -A INPUT -m pkttype --pkt-type broadcast -j DROP
echo "Interdiction générale faite"
# Ne pas casser les connexions établies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# Autorise le loopback (127.0.0.1)
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
echo "Loopback autorisé"
# Autorise ICMP (le ping) via toutes les interfaces
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
echo "Ping autorisé"
# Autorise SSH (si connexion SSH à une machine distante), port TCP 22 par défaut, sinon à adapter
iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
echo "SSH autorisé"
# Autorise DNS (port TCP ou UDP 53)
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
echo "DNS autorisé"
# Autorise NTP, synchronisation de l'horloge via le réseau (port 123)
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
echo "NTP autorisé"
# Autorise HTTP et HTTPS (ports par défaut 80 et 443) vers un serveur distant
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
# Autorise HTTP + HTTPS en entrée si un serveur web existe
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
# + si besoin le port 8443 ou d'autres...
iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT
echo "HTTP(S) autorisé"
# Autorise FTP en sortie (ports par défaut 20 et 21)
iptables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 20 -j ACCEPT
# Autorise FTP en entrée 
iptables -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
# Garde les connexions existantes
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
echo "FTP autorisé"
# Mail SMTP (port 25)
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
# Mail POP3 (port 110)
iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
# Mail IMAP (port 143)
iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
# Mail POP3S (port 995)
iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT
echo "Mail autorisé"
# On enregistre (log) les paquets en entrée
iptables -A INPUT -j LOG
# On log les paquets forward
iptables -A FORWARD -j LOG 

# AUTRE (optionnel et à modifier au besoin)
#iptables -t filter -A INPUT -p tcp --dport AUTRE_PORT -j ACCEPT
# exemple :
# Mysql
#iptables -t filter -A INPUT -p tcp --dport 3306 -j ACCEPT

# Notes :
# -A ajoute une règle sous les autres
# -I permet à la place de l'ajouter avant les autres (traitement prioritaire)
#
# pour sauvegarder :
# iptables-save -c > /etc/iptables-save

# pour restaurer une sauvegarde :
# iptables-restore -c < /etc/iptables-save
#
# pour rendre les règles permanentes au redémarrage :
# nano /etc/network/if-pre-up.d/iptables
# puis taper les lignes suivantes :
# #!/bin/sh
# iptables-restore < /etc/iptables-save
# puis rendre le fichier exécutable :
# chmod +x /etc/network/if-pre-up.d/iptables
# (ou utiliser le service iptables-persitent)