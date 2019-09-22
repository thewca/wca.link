def parse_route(location)
    case location 
    when "/"
      "https://www.worldcubeassociation.org/"
    when /^\/([0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z][A-Z][0-9][0-9])$/ #WCA ID
      "https://www.worldcubeassociation.org/persons/#{$1}"
    when /^\/([^\/]+)([0-9][0-9][0-9][0-9])$/ # Competition ID
      "https://www.worldcubeassociation.org/competitions/#{$1}#{$2}"
    when /^\/(.*)$/
      "https://www.worldcubeassociation.org/#{$1}"
    end
end

def lambda_handler(event:, context:)
    { statusCode: 302, headers: { Location: parse_route(event["path"]) } }
end

