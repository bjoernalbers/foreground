require 'foreground'

module Foreground
  class DaemonError < StandardError; end

  class Daemon
    @daemon = nil

    class << self
      attr_accessor :daemon

      def run(*args)
        @daemon = new(*args)
        @daemon.run
      end

      def kill(*args)
        @daemon.kill(*args)
      end
    end


    def initialize(cmd, pid_file)
      @cmd = cmd
      @pid_file = pid_file
    end

    def run
      STDOUT.sync = true
      puts "hi, there (foreground #{Foreground::VERSION})!"
      system(*@cmd)
      watch
    end

    def kill(signal = :TERM)
      Process.kill(signal, pid)
    end

    #TODO: Add scenario for this stuff!
    def pid
      return @pid unless @pid.nil?
      elapsed_time = 0
      sleep_time = 0.1
      begin
        break if @pid = read_pid
      rescue
        raise unless elapsed_time < Foreground.config[:timeout]
        elapsed_time += sleep_time
      end while sleep(sleep_time)
      @pid
    end

    def watch
      watch_interval = 10
      begin
        kill(0)
      rescue Errno::ESRCH
        raise DaemonError, "No process with PID #{pid} found."
      end while sleep(watch_interval)
    end

    private

    def read_pid
      pid = File.read(@pid_file).to_i
      raise DaemonError, "PID not readable from #{@pid_file}" unless pid > 0
      pid
    end
  end
end
