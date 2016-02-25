module Handler
  def start
  end

  def stop
  end

  abstract def handle(context : HTTP::Server::Context)
end

require "./handler/*"
  
