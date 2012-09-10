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
      Foreground.config = config
      Daemon.run(cmd, config[:pid_file])
    end
  end
end
