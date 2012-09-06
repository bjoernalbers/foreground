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
      #TODO: Implement watch feature!
      loop { sleep 1 }
    end
  end
end
