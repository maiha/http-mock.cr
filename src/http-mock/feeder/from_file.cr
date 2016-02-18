class Feeder::FromFile
  include Feeder

  getter pointer, lines
  
  def initialize(@file_name)
    @lines = File.read_lines(@file_name).map(&.chomp)
    @pointer = 0

    if lines.empty?
      raise "no lines found: file:`#{@file_name}'"
    end
  end

  def feed
    Feed.new.tap{|f| f.body = get!}
  end

  private def get! : String
    lines[pointer].tap{ succ! }
  end

  private def succ!
    unless last?
      @pointer += 1
    end
  end

  private def last?
    pointer == lines.size - 1
  end
end
