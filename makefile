brewfile:=Brewfile
python_version:=3.9.1
terraform_version:=1.1.2
current:=$(shell cat .python-version)
repo:=$(shell basename $(CURDIR))
layer=component

requirements:
	@echo
	@brew bundle list --file=$(brewfile)

--install:
	@echo
	@brew bundle install --file=$(brewfile)

--venv:
	@echo
	@pyenv install $(python_version) -s
	@pyenv virtualenv -f -q $(python_version) $(repo) 1> /dev/null
	@pyenv local $(repo)
	@pip install -q --upgrade pip
	@pip install -Uqr requirements.txt
	@echo $(terraform_version) > .terraform-version

--hooks:
	@git add .
	@pre-commit autoupdate
	@pre-commit install
	@echo
	@-pre-commit

--references:
	@sed -i '' s/$(current)/$(repo)/g README.md
	@sed -i '' s/$(current)/$(repo)/g .python-version

init: --install rename --hooks

rename: --venv --references

--cloud-init:
	@terraform -chdir=ops/cloud/$(layer) init

cloud-plan: --cloud-init
	@terraform -chdir=ops/cloud/$(layer) plan

cloud-apply: --cloud-init
	@terraform -chdir=ops/cloud/$(layer) apply -auto-approve

local-up:
	@docker-compose -f ops/local/stack.yaml up --build --remove-orphans --quiet-pull --detach

local-down:
	@docker-compose -f ops/local/stack.yaml down
