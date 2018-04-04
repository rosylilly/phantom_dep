require 'rubygems'
require 'bundler'
require 'phantom_dep/version'
require 'phantom_dep/collector'
require 'phantom_dep/formatter'

class PhantomDep
  DEFAULT_IGNORED_GEMS = %w[bundler rake].freeze

  def self.instance
    @instance ||= new
  end

  def self.start(&block)
    instance.start(&block)
  end

  attr_accessor :ignored_gem_names, :include_dependencies, :formatters, :auto_report
  def initialize
    @ignored_gem_names = DEFAULT_IGNORED_GEMS.dup
    @include_dependencies = false
    @formatters = [PhantomDep::Formatter::TextFormatter.new]
    @auto_report = true
  end

  def ignore(*gem_names)
    @ignored_gem_names.push(*gem_names)
  end

  def start
    yield(self) if block_given?
    collector.enable
    at_exit do
      break unless @auto_report
      report
    end
  end

  def report
    gems = gems_not_in_use
    @formatters.each do |formatter|
      formatter.output(gems)
    end
  end

  protected

  def collector
    @collector ||= PhantomDep::Collector.new
  end

  def gems_by_dependencies
    Bundler.locked_gems.dependencies.keys
  end

  def gems_by_bundler
    Bundler.locked_gems.specs.select { |spec| @include_dependencies || gems_by_dependencies.include?(spec.name) }.map(&:full_name).sort
  end

  def loaded_gemspecs
    Gem.loaded_specs.values
  end

  def ignored_gems
    @ignored_gem_names.map { |name| Gem.loaded_specs.values.find { |gem| gem.name == name } }.map(&:full_name).sort
  end

  def gems_in_use
    paths_of_gems = _paths_of_gems
    gems_in_called = []
    collector.paths.each do |file|
      paths_of_gems.each_pair do |prefix, gem|
        if file.start_with?(prefix)
          gems_in_called << gem
          break
        end
      end
    end
    gems_in_called.uniq.sort
  end

  def gems_not_in_use
    (gems_by_bundler - ignored_gems - gems_in_use).map do |gem_name|
      loaded_gemspecs.detect { |gemspec| gemspec.full_name == gem_name }
    end
  end

  def _paths_of_gems
    paths = loaded_gemspecs.map do |gem|
      gem.full_require_paths.map { |path| [path, gem.full_name] }.flatten
    end
    Hash[*paths.flatten]
  end
end
