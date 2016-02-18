class Feeder::Always200
  include Feeder

  def feed
    Feeder::Feed.new
  end
end
