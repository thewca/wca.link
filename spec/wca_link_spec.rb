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

  it "denylist" do
    api_get = lambda_handler(event: {
      "path" => "/api",
      "httpMethod" => "GET"
    }, context: {})
    expect(api_get[:statusCode]).to eq 404
    expect(api_get[:headers][:"Strict-Transport-Security"]).to eq "max-age=63072000; includeSubDomains; preload"

    api_post = lambda_handler(event: {
      "path" => "/api",
      "httpMethod" => "POST"
    }, context: {})
    expect(api_post[:statusCode]).to eq 405
    expect(api_post[:headers][:"Strict-Transport-Security"]).to eq "max-age=63072000; includeSubDomains; preload"
  end

  context "regulations" do
    it "medium" do
      A7g = lambda_handler(event: {
        "path" => "/A7g",
        "httpMethod" => "GET"
      }, context: {})
      expect(A7g[:statusCode]).to eq 302
      expect(A7g[:headers][:Location]).to eq "https://www.worldcubeassociation.org/regulations/#A7g"
    end

    it "long" do
      A4b1 = lambda_handler(event: {
        "path" => "/A4b1",
        "httpMethod" => "GET"
      }, context: {})
      expect(A4b1[:statusCode]).to eq 302
      expect(A4b1[:headers][:Location]).to eq "https://www.worldcubeassociation.org/regulations/#A4b1"
    end

    it "lots of digits" do
      r9f12c = lambda_handler(event: {
        "path" => "/9f12c",
        "httpMethod" => "GET"
      }, context: {})
      expect(r9f12c[:statusCode]).to eq 302
      expect(r9f12c[:headers][:Location]).to eq "https://www.worldcubeassociation.org/regulations/#9f12c"
    end

    it "guideline" do
      E2c1__ = lambda_handler(event: {
        "path" => "/E2c1++",
        "httpMethod" => "GET"
      }, context: {})
      expect(E2c1__[:statusCode]).to eq 302
      expect(E2c1__[:headers][:Location]).to eq "https://www.worldcubeassociation.org/regulations/guidelines.html#E2c1++"
    end
  end
end

