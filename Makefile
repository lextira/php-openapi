
all:

check-style:
	vendor/bin/php-cs-fixer fix src/ --diff --dry-run

fix-style:
	vendor/bin/indent --tabs composer.json
	vendor/bin/indent --spaces .php_cs.dist
	vendor/bin/php-cs-fixer fix src/ --diff

install:
	composer install --prefer-dist --no-interaction

test:
	vendor/bin/phpunit

# copy openapi3 json schema
schemas/openapi-v3.0.json: vendor/oai/openapi-specification/schemas/v3.0/schema.json
	cp $< $@

schemas/openapi-v3.0.yaml: vendor/oai/openapi-specification/schemas/v3.0/schema.yaml
	cp $< $@


# find spec classes that are not mentioned in tests with @covers yet
coverage: .php-openapi-covA .php-openapi-covB
	diff $^
.INTERMEDIATE: .php-openapi-covA .php-openapi-covB
.php-openapi-covA:
	grep -rhPo '@covers .+' tests |cut -c 28- |sort > $@
.php-openapi-covB:
	grep -rhPo '^class \w+' src/spec/ | awk '{print $$2}' |grep -v '^Type$$' | sort > $@

.PHONY: all check-style fix-style install test coverage

