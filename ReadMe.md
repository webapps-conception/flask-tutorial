# flask-tutorial

/home/user/Projects/flask-tutorial
├── flaskr/
│   ├── __init__.py
│   ├── db.py
│   ├── schema.sql
│   ├── auth.py
│   ├── blog.py
│   ├── templates/
│   │   ├── base.html
│   │   ├── auth/
│   │   │   ├── login.html
│   │   │   └── register.html
│   │   └── blog/
│   │       ├── create.html
│   │       ├── index.html
│   │       └── update.html
│   └── static/
│       └── style.css
├── tests/
│   ├── conftest.py
│   ├── data.sql
│   ├── test_factory.py
│   ├── test_db.py
│   ├── test_auth.py
│   └── test_blog.py
├── venv/
├── setup.py
└── MANIFEST.in

* Tutorial : https://flask-fr.readthedocs.io/tutorial/
* Github : https://github.com/pallets/flask/tree/main/examples/tutorial

## Installation de virtualenv
```bash
sudo apt-get install python3-venv
```

## Création de l'environnement virtuel
```bash
make venvBuild
```

Usage :
Charger le fichier venv_aliases.sh afin de pouvoir utiliser les alias **venv-start** et **venv-stop** pour activer et desactiver l'environnement virtuel python :
```bash
. venv_aliases.sh
```

## Mise à jour de l'environnement
```bash
make pipUpgrade
```

## Installer l'environnement de développement
```bash
pipInstallDev
```

## Executer l'application flaskr
Pour une première exécution, il faut initialiser la base de données :
```bash
initdbDev
```

Lancement du serveur flask :
```bash
runDev
```

## Setup du projet
```bash
make setup
```

## Couverture des tests
Exécution de la commande **pytest** :
```bash
make test
```

Pour mesurer la couverture de code des tests :
```bash
make coverage
```

Afficher un simple rapport de couverture dans le terminal :
```bash
make coverageReport
```

Un rapport HTML vous permet de voir quelles lignes ont été couvertes dans chaque fichier :
```bash
make coverageHtml
```

## Déployer en production
### Construction et installation
Lorsque vous voulez déployer votre application ailleurs, vous construisez un fichier de distribution. Le standard actuel pour la distribution Python est le format wheel, avec l’extension .whl. Assurez-vous que la bibliothèque wheel est installée en premier :
```bash
pip install wheel
```

L’exécution de setup.py avec Python vous donne un outil de ligne de commande pour lancer des commandes liées à la construction. La commande bdist_wheel va construire un fichier de distribution wheel.
```bash
make wheelBuild
```

Vous pouvez trouver le fichier dans dist/flaskr-1.0.0-py3-none-any.whl. Le nom du fichier est au format {nom du projet}-{version}-{balises python} -{balise abi}-{balise plateforme}.

Copiez ce fichier sur une autre machine, mettez en place un nouveau virtualenv, puis installez le fichier avec pip.
```bash
make wheelInstallProd
```

Pip installera votre projet ainsi que ses dépendances.

Comme il s’agit d’une machine différente, vous devez relancer init-db pour créer la base de données dans le dossier de l’instance.
```bash
make initdbProd
```

Lorsque Flask détecte qu’il est installé (pas en mode modifiable), il utilise un répertoire différent pour le dossier de l’instance. Vous pouvez le trouver dans venv/var/flaskr-instance à la place.

### Configurer la clé secrète
Au début du tutoriel, vous avez donné une valeur par défaut pour SECRET_KEY. Cette valeur doit être remplacée par des octets aléatoires en production. Sinon, les attaquants pourraient utiliser la clé publique 'dev' pour modifier le cookie de session, ou tout autre élément qui utilise la clé secrète.

Vous pouvez utiliser la commande suivante pour générer une clé secrète aléatoire :
```bash
make genereCleSecrete
```

Créez le fichier config.py dans le dossier de l’instance, que la fabrique lira s’il existe. Copiez la valeur générée dans ce fichier.

venv/var/flaskr-instance/config.py :
```python
SECRET_KEY = b'_5#y2L"F4Q8z\n\xec]/'
```

Vous pouvez également définir toute autre configuration nécessaire ici, bien que SECRET_KEY soit la seule nécessaire pour Flaskr.

### Exécution avec un serveur de production
Lorsque vous exécutez publiquement plutôt qu’en développement, vous ne devriez pas utiliser le serveur de développement intégré (flask run). Le serveur de développement est fourni par Werkzeug pour des raisons pratiques, mais il n’est pas conçu pour être particulièrement efficace, stable ou sécurisé.

A la place, utilisez un serveur WSGI de production. Par exemple, pour utiliser Waitress, installez-le d’abord dans l’environnement virtuel :
```bash
make pipInstallProd
```

Vous devez informer Waitress de votre application, mais il n’utilise pas FLASK_APP comme le fait flask run. Vous devez lui dire d’importer et d’appeler la fabrique d’applications pour obtenir un objet d’application.
```bash
make waitressRunProd
```

