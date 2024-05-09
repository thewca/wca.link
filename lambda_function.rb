# Returns a URL (as string) or `nil`.
def parse_route(location)
  case location
  when "/"
    "https://www.worldcubeassociation.org/"
  # Denylist (Reserved)
  # These resources should be accessed at the canonical WCA website URL.
  when /^\/(api|oauth)(\/.*)?$/
    return nil
  # Website (Reserved)
  when /^\/(about|admin|competitions|contact|delegates|documents|faq|notifications|organizations|panel|persons|privacy|profile|regulations|search|teams-committees|tutorial|users).*$/
    "https://www.worldcubeassociation.org/#{$1}"
  when /^\/(records|rankings).*$/
    "https://www.worldcubeassociation.org/results/#{$1}"
  # Website
  when /^\/([0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z][A-Z][0-9][0-9])$/ #WCA ID
    "https://www.worldcubeassociation.org/persons/#{$1}"
  # Competitions
  when /^\/([^\/]+)([0-9][0-9][0-9][0-9])$/
    "https://www.worldcubeassociation.org/competitions/#{$1}#{$2}"
  when /^\/live\/([^\/]+)([0-9][0-9][0-9][0-9])$/
    "https://live.worldcubeassociation.org/link/competitions/#{$1}#{$2}"
  when /^\/([^\/]+)([0-9][0-9][0-9][0-9])\/live$/
    # Note: `/live/CompetitionName2019` is the canonical short link, recommended
    # over `/CompetitionName2019/live` when posting a link.
    #
    # But we support the latter, just in case someone types that. (This could
    # happen if they're going by vague memory rather than reading the URL
    # directly.) That way, we take them where they're clearly trying to go,
    # instead of causing confusion or annoyance.
    "https://live.worldcubeassociation.org/link/competitions/#{$1}#{$2}"
  # Regulations and Guidelines
  when /^\/([0-9]{1,2}[a-z]([0-9]{1,2}[a-z]?)?|[A-Z][0-9]{1,2}([a-z]([0-9]{1,2})?)?)(\+*)$/
    guidelines_page = "#{$5}" == "" ? "" : "guidelines.html"
    "https://www.worldcubeassociation.org/regulations/#{guidelines_page}\##{$1}#{$5}"
  # Social Media
  when /^\/(instagram|ig)$/
    "https://www.instagram.com/thewcaofficial/"
  when /^\/(facebook|fb)$/
    "https://www.facebook.com/WorldCubeAssociation/"
  when /^\/twitter$/
    "https://www.twitter.com/theWCAofficial/"
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
  # Shop
  when /^\/shop$/
    "https://shop.worldcubeassociation.org"
  when /^\/newcomer$/
    "https://linktr.ee/newcomermonth"
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

def get_response(event)
  # Only allow GET requests, to discourage sending sensitive data.
  return { statusCode: 405 } unless event["httpMethod"] == "GET"
  
  redirect_url = parse_route(event["path"])

  # If the path was on the denylist, deny access.
  return { statusCode: 404 } if redirect_url.nil?
  
  # Redirect!
  { statusCode: 302, headers: { Location: redirect_url } }
end

def lambda_handler(event:, context:)
  response = get_response(event)

  # Add unconditional headers.
  response[:headers] = (response[:headers] || {}).merge({
    "Strict-Transport-Security": "max-age=63072000; includeSubDomains; preload"
  })

  response
end
