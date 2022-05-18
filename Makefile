ligo_compiler=docker run --rm -v "$$PWD":"$$PWD" -w "$$PWD" ligolang/ligo:0.42.0

help:
	@echo  'Usage:'
	@echo  '  all - Execute all tests'
	@echo  '  v1  - Play'
	@echo  '  v2  - Play & Reveal'
	@echo  '  v3  - Play & Reveal & Gain'
	@echo  ''

all: v1 v2 v3

v1:
	@echo "[Testing] v1"
	@$(ligo_compiler) run test test/v1/t01_action.jsligo
	@$(ligo_compiler) run test test/v1/t02_round_value.jsligo
	@$(ligo_compiler) run test test/v1/t03_round.jsligo
	@$(ligo_compiler) run test test/v1/t04_storage.jsligo
	@$(ligo_compiler) run test test/v1/t05_shifumi.jsligo

v2: 
	@echo "[Testing] v2"
	@$(ligo_compiler) run test test/v2/t01_action.jsligo
	@$(ligo_compiler) run test test/v2/t02_round_value.jsligo
	@$(ligo_compiler) run test test/v2/t03_round.jsligo
	@$(ligo_compiler) run test test/v2/t04_storage.jsligo
	@$(ligo_compiler) run test test/v2/t05_shifumi.jsligo

v3: 
	@echo "[Testing] v3"
	@$(ligo_compiler) run test test/v3/t01_action.jsligo
	@$(ligo_compiler) run test test/v3/t02_round_value.jsligo
	@$(ligo_compiler) run test test/v3/t03_round.jsligo
	@$(ligo_compiler) run test test/v3/t04_storage.jsligo
	@$(ligo_compiler) run test test/v3/t05_shifumi.jsligo
