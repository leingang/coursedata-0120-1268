#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = coursedata-0120-1268
PYTHON_VERSION = 3.13
PYTHON_INTERPRETER = uv run python
RSYNC = rsync -avz --exclude=".*"
GIT = git
DATA_DIR=data
REPORTS_DIR=reports
SYNC_DIR = /Users/matthew/Library/CloudStorage/GoogleDrive-mpl5@nyu.edu/My Drive/Courses/MATH-UA 120 Discrete Mathematics/MATH-UA 120 Fall 2026

#################################################################################
# COMMANDS                                                                      #
#################################################################################


## Install Python dependencies
.PHONY: requirements
requirements:
	uv sync
	



## Delete all compiled Python files
.PHONY: clean
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete


## Lint using ruff (use `make format` to do formatting)
.PHONY: lint
lint:
	ruff format --check
	ruff check

## Format source code with ruff
.PHONY: format
format:
	ruff check --fix
	ruff format





## Set up Python interpreter environment
.PHONY: create_environment
create_environment:
	uv venv --python $(PYTHON_VERSION)
	@echo ">>> New uv virtual environment created. Activate with:"
	@echo ">>> Windows: .\\\\.venv\\\\Scripts\\\\activate"
	@echo ">>> Unix/macOS: source ./.venv/bin/activate"
	



#################################################################################
# PROJECT RULES                                                                 #
#################################################################################


## Make dataset
.PHONY: data
data: requirements
	$(PYTHON_INTERPRETER) coursedata_0120_1268/dataset.py


## Make "daily" datasets
## Assumes the requirements are up-to-date
.PHONY: daily
daily:
	$(PYTHON_INTERPRETER) -m coursedata.dataset daily
	$(GIT) add $(REPORTS_DIR)/enrollment
	$(GIT) commit -am "Update enrollment reports"
	$(PYTHON_INTERPRETER) -m coursedata.tasks daily	



#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys; \
lines = '\n'.join([line for line in sys.stdin]); \
matches = re.findall(r'\n## (.*)\n[\s\S]+?\n([a-zA-Z_-]+):', lines); \
print('Available rules:\n'); \
print('\n'.join(['{:25}{}'.format(*reversed(match)) for match in matches]))
endef
export PRINT_HELP_PYSCRIPT

help:
	@$(PYTHON_INTERPRETER) -c "${PRINT_HELP_PYSCRIPT}" < $(MAKEFILE_LIST)
