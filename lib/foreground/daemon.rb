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
      system(*@cmd)
      watch # TEST THIS!
    end

    #TODO: Test this!
    def log(msg)
      puts msg
    end

    def watch
      ### <proof_of_concept>
      #TODO: Unhackify this block of code!
      STDOUT.sync = true
      log "hi, there (foreground #{Foreground::VERSION})!"
      trap(:TERM) do
        log "Inside trap..."
        sleep 0.1 # Give the daemon time to write its PID file.
        if File.exists?(@pid_file)
          log "pid file >#{@pid_file} exists."
          pid = File.read(@pid_file).chomp.to_i
          log "killing process with PID >#{pid}<"
          Process.kill(:TERM, pid)
          log "after kill"
        end
        log "running exit"
        exit
      end
      ### </proof_of_concept>

      #TODO: Implement watch feature!
      loop { sleep 1 }
    end
  end
end
