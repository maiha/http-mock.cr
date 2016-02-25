class Handler::Feeder
  include Handler

  getter! feeder
  
  def initialize(@feeder : ::Feeder)
  end

  def handle(context)
    feed = feeder.feed
    context.response.headers["Content-Type"] = feed.type
    context.response.status_code = feed.code
    context.response.print(feed.body)
  end
end
