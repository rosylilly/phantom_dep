require 'phantom_dep'

class PhantomDep::Formatter
  def initialize()
  end

  class TextFormatter < self
    def initialize(io = STDOUT)
      @io = io
    end

    def output(gems)
      return @io.puts "\nAll gems in use" if gems.empty?

      @io.puts "\nGems not in use\n"
      gems.each do |gem|
        @io.puts " * #{gem.name} (v#{gem.version})"
      end
      @io.puts
    end
  end
end
