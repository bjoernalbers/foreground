require 'foreground'

module Foreground
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

    def pid
      #TODO: Replace sleep with timeout!
      sleep 0.1 # Give the daemon time to write its PID file.
      File.read(@pid_file).chomp.to_i
    end

    def watch
      #TODO: Implement watch feature!
      loop { sleep 1 }
    end
  end
end
