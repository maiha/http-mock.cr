require "http/server"

module Feeder
  class Feed
    property code, type, body

    def initialize(@code = 200 : Int, @type = "text/plain" : String, @body = "" : String)
    end
  end
    
  abstract def feed : Feed
end
  
require "./feeder/*"
