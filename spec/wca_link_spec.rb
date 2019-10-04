require './lambda_function'

RSpec.describe "wca.link" do
  it "root path" do
    root = lambda_handler(event: {
      "path" => "/",
      "httpMethod" => "GET"
    }, context: {})
    expect(root[:statusCode]).to eq 302
    expect(root[:headers][:"Strict-Transport-Security"]).to eq "max-age=63072000; includeSubDomains; preload"
  end
end

