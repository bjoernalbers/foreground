require 'logger'
require 'mixlib/cli'
require 'foreground/version'
require 'foreground/daemon'
require 'foreground/cli'

module Foreground
  class << self
    # The global configuration based on command line options.
    attr_accessor :config
  end

  def logger
    @logger ||= create_logger
  end

  private

  def create_logger
    STDOUT.sync = true
    l = Logger.new(STDOUT)
    #TODO: Test this!
    l.formatter = proc do |severity, datetime, progname, msg|
      "#{progname} [#{severity}]: #{msg}\n"
    end
    l
  end
end
