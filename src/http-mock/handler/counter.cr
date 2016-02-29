class Handler::Counter
  include Handler

  getter! total

  class Holder
    getter! counts, reset_at
    
    def initialize
      @counts = {} of Int32 => Int32
      reset
    end

    def <<(code)
      counts[code] ||= 0
      counts[code] += 1

      tick!
    end

    protected def reset
      @counts = {} of Int32 => Int32
      @reset_at = Time.now
    end

    protected def tick!
      # update clock
    end

    def to_s
      "#{@counts.values.sum} #{@counts.inspect}"
    end
  end

  class IntervalHolder < Holder
    def initialize(@interval : Time::Span)
      super()
#      @report = Channel(String)
    end

    def start
#      spawn do
#        STDOUT.puts @report.receive
#      end

#      spawn do
#        STDOUT.puts "#{Time.now} #{@counts.inspect}"
#        reset
#        sleep 1 # @interval
#      end
    end

    protected def time_exceeded?
      reset_at + @interval <= Time.now
    end

    protected def tick!
      # report current counts when clock exceeds interval
      if time_exceeded?
        STDOUT.puts "#{Time.now} #{to_s}"
        reset
      end
    end
  end
  
  def initialize(@interval)
    @total  = Holder.new
    @report = IntervalHolder.new(@interval)
  end

  def handle(context)
    code = context.response.status_code
    @total << code
    @report << code
  end

  def stop
    puts ""
    puts "total: #{total}"
    counts = total.counts
    counts.keys.sort.each do |code|
      puts "#{code}: #{counts[code]}"
    end
  end

  def to_s
    total.to_s
  end
end
