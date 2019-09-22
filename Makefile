.PHONY: test
test: build/lambda_function_payload.zip
	terraform plan

.PHONY: deploy
deploy: build/lambda_function_payload.zip
	terraform apply

build/lambda_function_payload.zip: lambda_function.rb
	mkdir -p build
	zip $@ $^
