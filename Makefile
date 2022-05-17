ligo_compiler=docker run --rm -v "$$PWD":"$$PWD" -w "$$PWD" ligolang/ligo:0.42.0

help:
	@echo  'Usage:'
	@echo  '  all - Execute all tests'
	@echo  '  v1  - Play'
	@echo  '  v2  - Play & Reveal'
	@echo  '  v3  - Play & Reveal & Gain'
	@echo  ''

all: v1 v2 v3

v1: test/v1/shifumi.jsligo
	@echo "[Testing] $^"
	@$(ligo_compiler) run test $^

v2: test/v2/shifumi.jsligo 
	@echo "[Testing] $^"
	@$(ligo_compiler) run test $^

v3: test/v3/shifumi.jsligo 
	@echo "[Testing] $^"
	@$(ligo_compiler) run test $^
