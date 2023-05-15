# en bref

PMB est un logiciel open-source de gestion de bibliothèque édité par la société [SIGB](https://www.sigb.net/). Voici les différents liens liés au logiciel PMB

- [MUT](https://doc.sigb.net/pmb73/co/guide_complet_web_v73.html), forge Redmine dédiée au [projet](https://forge.sigb.net/projects/pmb),  [Wiki](https://forge.sigb.net/projects/pmb/wiki/Documentations_g%C3%A9n%C3%A9rales_sur_PMB), [téléchargement](https://forge.sigb.net/projects/pmb/files).
- version [dockerisée]( : [https://github.com/jperon/pmb/](https://github.com/jperon/pmb/)) ; c'est sur cette version que ce projet est basé.

on peut noter qu'il n'existe qu'une version sommaire de [l'installation](https://doc.sigb.net/doc_install_xampp/co/install_xampp_web.html) sur plateforme Windows/XAMP. Surprenant pour un logiciel de cette qualité. Avec une stack docker-compose, il semble bien plus facile d'installer/exploiter ce logiciel.

# Installation

cloner le projet

```
git clone https://github.com/mqu/pmb-ils.git
# git@github.com:mqu/pmb-ils.git
cd pmb-ils
```

procéder au build

```
docker-compose build
```

recopier le fichier `.env.tmpl` afin de satisfaire à votre environnement

```
cp .env.tmpl .env
vi .env
```

initialisation des répertoires de persistance des données

```
sudo mkdir -p ./data/mysql ; sudo chown -R 1000:1000 ./data/mysql
```

lancer l'application

```
docker-compose pull ; docker-compose up -d ; docker-compose logs -ft
```

avec les paramètres par défaut, l'application peut être configurée avec cette URL

```
http://localhost:8080/pmb/tables/install.php
```

par défaut, l'authentification est la suivante : 

- user: admin, mdp: admin
- database: pmb ; host: db

il est fortement recommandé de passer par un reverse-proxy Apache, NGINX afin de sécuriser les accès avec du HTTPS.

# Modifications

Par rapport à la version Dockerisée trouvée en [ligne](https://github.com/jperon/pmb/) (merci à lui) :

- création d'un container dédié à la base SQL avec adaptation de `l'entrypoint`,
- la stack contient maintenant 2 composants : db, app
- dans `l'entrypoint` de l'application, attente active du démarrage de l'application
- installation de 2 `healthcheck`
- configuration avec le modèle `.env` / .env.tmpl
- hardening des 2 containers :
  - `rootless` quand c'est possible
  - pas de mode `read-only` malheureusement,
  - limitation des ressources.
- un peu de doc.

# Glossaire

- ILS: Integrated Library System ([lien](https://en.wikipedia.org/wiki/Integrated_library_system))
- OPAC : Online Public Access Catalog ([lien](https://fr.wikipedia.org/wiki/Online_public_access_catalog))

# Liens connexes

- https://www.sigb.net/
- https://github.com/jperon/pmb/ : version dockerisée de PMB.
- https://hub.docker.com/r/willfarrell/autoheal : permet la relance des containers defectueux (healthcheck).

------

*gracieusement édité avec typora.*
