.PHONY: test
test: compile_test
	@echo
	@echo
	haxelib run munit test -cpp -result-exit-code | tail -n 50

.PHONY: js
js: compile_test
	@echo
	@echo
	haxelib run munit test -js

.PHONY: neko
neko: compile_test
	@echo
	@echo
	haxelib run munit test -neko

compile_test_file := test/CompileTest.hx

compile_test:
	@mkdir -p $(dir ${compile_test_file})
	@echo "Create ${compile_test_file}"
	@echo "package;" > ${compile_test_file}
	@echo $(addprefix "import ",$(addsuffix ";\n",\
		$(filter-out Main,\
			$(shell find src -name "*.hx" | cut -d/ -f2- | cut -d. -f1 | tr '/' '.')))) >> ${compile_test_file}
	@echo "class CompileTest {" >> ${compile_test_file}
	@echo "    @Test public function test():Void {}" >> ${compile_test_file}
	@echo "}" >> ${compile_test_file}

.PHONY: watch
watch:
	react $(shell git ls) $(shell find src test -name "*.hx") -- make ${WATCH}

.PHONY: clean
clean:
	rm -rf build

