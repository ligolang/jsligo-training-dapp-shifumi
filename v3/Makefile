ligo_compiler=docker run --rm -v "$$PWD":"$$PWD" -w "$$PWD" ligolang/ligo:0.42.0

all: 
	@echo "[Testing] v3"
	@$(ligo_compiler) run test test/t01_action.jsligo
	@$(ligo_compiler) run test test/t02_round_value.jsligo
	@$(ligo_compiler) run test test/t03_round.jsligo
	@$(ligo_compiler) run test test/t04_storage.jsligo
	@$(ligo_compiler) run test test/t05_shifumi.jsligo
