# TODO: Turn this into a proper spec file.

debug = false

load("./lambda_function.rb")

root = lambda_handler(event: {
  "path" => "/",
  "httpMethod" => "GET"
}, context: {})
puts root if debug
puts root[:statusCode] == 302
puts root[:headers][:"Strict-Transport-Security"] == "max-age=63072000; includeSubDomains; preload"

api_get = lambda_handler(event: {
  "path" => "/api",
  "httpMethod" => "GET"
}, context: {})
puts api_get if debug
puts api_get[:statusCode] == 404

api_post = lambda_handler(event: {
  "path" => "/api",
  "httpMethod" => "POST"
}, context: {})
puts api_post if debug
puts api_post[:statusCode] == 405

A7g = lambda_handler(event: {
  "path" => "/A7g",
  "httpMethod" => "GET"
}, context: {})
puts A7g if debug
puts A7g[:statusCode] == 302
puts A7g[:headers][:Location] == "https://www.worldcubeassociation.org/regulations/#A7g"

A4b1 = lambda_handler(event: {
  "path" => "/A4b1",
  "httpMethod" => "GET"
}, context: {})
puts A4b1 if debug
puts A4b1[:statusCode] == 302
puts A4b1[:headers][:Location] == "https://www.worldcubeassociation.org/regulations/#A4b1"

r9f12c = lambda_handler(event: {
  "path" => "/9f12c",
  "httpMethod" => "GET"
}, context: {})
puts r9f12c if debug
puts r9f12c[:statusCode] == 302
puts r9f12c[:headers][:Location] == "https://www.worldcubeassociation.org/regulations/#9f12c"

E2c1__ = lambda_handler(event: {
  "path" => "/E2c1++",
  "httpMethod" => "GET"
}, context: {})
puts E2c1__ if debug
puts E2c1__[:statusCode] == 302
puts E2c1__[:headers][:Location] == "https://www.worldcubeassociation.org/regulations/guidelines.html#E2c1++"
