all:
	@echo "make buildPackage clean coverage coverageHtml coverageReport genereCleSecrete initdbDev initdbProd pipFreeze pipInstallDev pipInstallProd pipList pipSetup pipUpgrade runDev test venvBuild venvInstall wheelBuild wheelInstallProd waitressRunProd"

buildPackage:
	. ./venv/bin/activate && \
	make wheelBuild && \
	deactivate

clean:
	rm -rf build dist flaskr.egg-info instance

coverage:
	@echo "Mesure de couverture de code des tests"
	coverage run -m pytest

coverageHtml:
	@echo "Rapport de couverture HTML sous htmlcov/index.html"
	coverage html

coverageReport:
	@echo "Simple rapport de couverture"
	coverage report

genereCleSecrete:
	@echo "Generation d'une cle secrete"
	python3 -c 'import os; print(os.urandom(16))'

initdbDev:
	. ./env.sh && flask init-db

initdbProd:
	. ./env.sh && cd ./venv/var && flask init-db

pipFreeze:
	pip freeze > requirements.txt

pipInstallDev:
	pip install -r requirements_dev.txt

pipInstallProd:
	pip install -r requirements_prod.txt

pipList:
	pip list

pipSetup:
	@echo "Creation du package flaskr a partir du fichier setup.py"
	pip install -e .

pipUpgrade:
	pip install python-upgrade

pipUninstallAll:
	pip freeze --user | xargs pip uninstall -y

runDev:
	. ./venv/bin/activate && \
	. ./env.sh && flask run
	deactivate

test:
	pytest

venvBuild:
	[ ! -d ./venv ] && mkdir venv
	python3 -m venv ./venv

venvInstall:
	make clean venvBuild && \
	. ./venv/bin/activate && \
	make pipUpgrade pipInstallDev && \
	make pipList && \
	make initdbDev && \
	deactivate

wheelBuild:
	@echo "Construction du fichier dist/flaskr-1.0.0-py3-none-any.whl"
	. ./venv/bin/activate && \
	python3 setup.py bdist_wheel && \
	deactivate
	@echo "Fichier dist/flaskr-1.0.0-py3-none-any.whl a copier sur la machine de production avec un nouveau virtualenv"

wheelInstallProd:
	@echo "Installation du fichier dist/flaskr-1.0.0-py3-none-any.whl sur la machine de production"
	pip install dist/flaskr-1.0.0-py3-none-any.whl

waitressRunProd:
	waitress-serve --call 'flaskr:create_app'
