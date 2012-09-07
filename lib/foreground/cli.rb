module Foreground
  class CLI
    include Mixlib::CLI

    option :pid_file,
      :short => '-p FILE',
      :long  => '--pid_file FILE',
      :description => 'PID file for the daemon',
      :required => true

    class << self
      def run(argv=ARGV)
        new.run(argv)
      end
    end

    def run(argv)
      cmd = parse_options(argv)
      system(cmd.shelljoin)
      watch
    end

    #TODO: Test this!
    def log(msg)
      puts msg
      File.open('/tmp/foreground.log', 'a') do |f|
        f.puts msg
      end
    end

    def watch
      ### <proof_of_concept>
      #TODO: Unhackify this block of code!
      STDOUT.sync = true
      log "hi, there (foreground #{Foreground::VERSION})!"
      trap(:TERM) do
        log "Inside trap..."
        sleep 0.1 # Give the daemon time to write its PID file.
        if File.exists?(config[:pid_file])
          log "pid file >#{config[:pid_file]} exists."
          pid = File.read(config[:pid_file]).chomp.to_i
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
