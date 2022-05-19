ligo_compiler=docker run --rm -v "$$PWD":"$$PWD" -w "$$PWD" ligolang/ligo:0.42.0
files=test/t01_action.jsligo test/t02_round_value.jsligo test/t03_round.jsligo test/t04_storage.jsligo test/t05_shifumi.jsligos
tests=test/t01_action.dummy test/t02_round_value.dummy test/t03_round.dummy test/t04_storage.dummy test/t05_shifumi.dummy

all: ${tests}

%.dummy: %.jsligo
	@echo "[Testing] $<"
	@$(ligo_compiler) run test $<
