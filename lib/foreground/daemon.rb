require 'foreground'

module Foreground
  class Daemon
    class << self
      def run(*args)
        new(*args).run
      end
    end

    def initialize(cmd, pid_file)
      @cmd = cmd
      @pid_file = pid_file
    end

    def run
      STDOUT.sync = true
      puts "hi, there (foreground #{Foreground::VERSION})!"

      #TODO: Move signal handling into separate file!
      trap(:TERM) do
        #Process.kill(:TERM, pid)
        kill
        exit
      end

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
