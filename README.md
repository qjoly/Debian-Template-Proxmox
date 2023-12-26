![Proxmox](https://img.shields.io/static/v1?style=for-the-badge&message=Proxmox&color=E57000&logo=Proxmox&logoColor=FFFFFF&label=) ![Packer](https://img.shields.io/badge/packer-%23E7EEF0.svg?style=for-the-badge&logo=packer&logoColor=%2302A8EF)

# Déploiement Packer d'une machine Debian sur Proxmox

## Qu'est ce que Packer ? 

> Packer est une solution opensource permettant de construire des images machine pour de multiples plateformes cloud. Il est utilisé dans une approche « d'infrastructure as code » afin de pouvoir maintenir facilement les logiciels déployés sur les serveurs. - Syloe 

L'objectif de ce dépôt est de déployer une template de machine virtuelle Debian pré-configurée. *(Authentification par clé SSH, ou installation d'un agent de supervision à la fin de l'installation)*

## Démarrer le projet

Pré-requis: 
- [j2cli](https://pypi.org/project/j2cli/) 
- [Packer](https://packer.io)

Editez le fichier `build.sh` pour y mettre les identifiants de votre Proxmox : 
```bash
export proxmox_url="https://IP_PROXMOX:8006/api2/json"
export proxmox_node="NOM_NOEUD"
export proxmox_username="root@pam" # packer@pve si vous créez un utilisateur "packer". 
export proxmox_password="Password"
```
*Pensez à vérifier que les noms des pools de stockages sont les mêmes que vous (local, local-zfs)*. 

Il sera **obligatoire** de fournir une clé ssh qui sera ajoutée à l'utilisateur *root* de la machine. 
```bash
export vm_keys=$(echo "$(cat ~/.ssh/id_ed25519.pub)")
```

Il est possible d'ajouter plusieurs clés de cette manière : 
```bash
export vm_keys=$(echo "$(cat ./KeyDEPLOY.id_rsa.pub)\n$(cat ./KeyINFRA.id_rsa.pub)\n$(cat ~/.ssh/id_rsa.pub)")
```

# TroubleShooting
## No matching host key type found
Si vous êtes sur Ubuntu, vous devrez ajouter le ssh-rsa en algorithme de chiffrement compatible. 
Voici l'erreur sur laquelle vous tomberez : 
```
    proxmox: fatal: [default]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Unable to negotiate with 127.0.0.1 port 32985: no matching host key type found. Their offer: ssh-rsa", "unreachable": true}
```

La solution est d'accepter cet algorithme dans votre fichier `~/.ssh/config`.
```
Host 127.0.0.1
  HostKeyAlgorithms +ssh-rsa
  PubkeyAcceptedAlgorithms +ssh-rsa
```