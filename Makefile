.PHONY: test
test:
	haxelib run munit test -result-exit-code | tail -n 50

.PHONY: watch
watch:
	react $(shell git ls) $(shell find src -name "*.hx") -- make ${WATCH}

.PHONY: clean
clean:
	rm -rf build

