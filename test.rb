# TODO: Turn this into a proper spec file.

load("./lambda_function.rb")

puts lambda_handler(event: {
  "path" => "/",
  "httpMethod" => "GET"
}, context: {})

puts lambda_handler(event: {
  "path" => "/api",
  "httpMethod" => "GET"
}, context: {})

puts lambda_handler(event: {
  "path" => "/api",
  "httpMethod" => "POST"
}, context: {})
