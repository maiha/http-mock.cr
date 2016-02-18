require "http"

class Feeder::Response < Feeder::FromFile
  def feed
    line = get!
    f = Feeder::Feed.new
    a = line.split(/\s/, 2)
    a.each_with_index do |val, i|
      case i
      when 0
        f.code = val.to_i
      when 1
        f.body = val
      else
        raise "[BUG] #{self.class}#feed can't parse #{line}"
      end
    end
    return f
  end
end
