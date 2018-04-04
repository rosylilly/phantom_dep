require 'phantom_dep'

class PhantomDep::Collector
  attr_reader :paths

  def initialize
    @paths = []

    enable
  end

  def call(tp)
    @paths << tp.path unless @paths.include?(tp.path)
  end

  def enable
    disable
    @tracepoint = TracePoint.new(:call, :line) do |tp|
      call(tp)
    end
    @tracepoint.enable
  end

  def disable
    return if @tracepoint.nil?
    @tracepoint.disable
    @tracepoint = nil
  end
end
