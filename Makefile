.PHONY: test
test: compile_test
	haxelib run munit test -result-exit-code | tail -n 50

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
	react $(shell git ls) $(shell find src -name "*.hx") -- make ${WATCH}

.PHONY: clean
clean:
	rm -rf build

