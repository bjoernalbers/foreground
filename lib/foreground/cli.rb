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

    def watch
      ### <proof_of_concept>
      #TODO: Unhackify this block of code!
      STDOUT.sync = true
      puts "hi, there!"
      trap(:TERM) do
        sleep 3 # Give the daemon time to write its PID file.
        if File.exists?(config[:pid_file])
          pid = File.read(config[:pid_file]).chomp.to_i
          Process.kill(:TERM, pid)
        end
      end
      ### </proof_of_concept>

      #TODO: Implement watch feature!
      loop { sleep 1 }
    end
  end
end
