class Handler::Group
  getter handlers

  def initialize(@handlers : Array(Handler))
  end

  def handle(context : HTTP::Server::Context)
    each(&.handle(context))
  end

  def start
    each &.start
  end

  def stop
    each &.stop
  end

  private def each(&block)
    handlers.each do |h|
      yield h
      sleep 0
    end
  end
end
