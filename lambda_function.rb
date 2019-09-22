def parse_route(location)
    case location 
    when "/"
      "https://www.worldcubeassociation.org/"
    # Website (Reserved)
    when /^\/(about|admin|api|competitions|contact|delegates|documents|faq|notifications|organizations|panel|persons|privacy|profile|regulations|results|search|teams-committees|tutorial|users).*$/
      "https://www.worldcubeassociation.org/#{$1}"
    # Website
    when /^\/([0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z][A-Z][0-9][0-9])$/ #WCA ID
      "https://www.worldcubeassociation.org/persons/#{$1}"
    # Competitions
    when /^\/([^\/]+)([0-9][0-9][0-9][0-9])$/
      "https://www.worldcubeassociation.org/competitions/#{$1}#{$2}"
    when /^\/live\/([^\/]+)([0-9][0-9][0-9][0-9])$/
      "https://live.worldcubeassociation.org/competitions/#{$1}#{$2}"
    when /^\/([^\/]+)([0-9][0-9][0-9][0-9])\/live$/
      "https://live.worldcubeassociation.org/competitions/#{$1}#{$2}"
    # Social Media
    when /^\/(instagram|ig)$/
      "https://www.instagram.com/thewcaofficial/"
    when /^\/(facebook|fb)$/
      "https://www.facebook.com/WorldCubeAssociation/"
    when /^\/reddit$/
      "https://www.reddit.com/r/TheWCAOfficial/"
    when /^\/twitch$/
      "https://www.twitch.tv/worldcubeassociation/"
    when /^\/weibo$/
      "https://www.weibo.com/theWCA/"
    when /^\/(youtube|yt)$/
      "https://www.youtube.com/channel/UC5OUMUnS8PvY1RvtB1pQZ0g"
    # Software
    when /^\/(github|gh)$/
      "https://github.com/thewca/"
    # Domain
    when /^\/staging$/
      "https://staging.worldcubeassociation.org"
    when /^\/(cubecomps|cc)$/
      "https://www.cubecomps.com"
    when /^\/live$/
      "https://live.worldcubeassociation.org"
    # Communication
    when /^\/slack$/
      "https://worldcubeassociation.slack.com"
    when /^\/forum$/
      "https://forum.worldcubeassociation.org"
    when /^\/groups$/
      "https://groups.google.com/a/worldcubeassociation.org/"
    # Default
    when /^\/(.*)$/
      "https://www.worldcubeassociation.org/#{$1}"
    end
end

def lambda_handler(event:, context:)
    { statusCode: 302, headers: { Location: parse_route(event["path"]) } }
end

