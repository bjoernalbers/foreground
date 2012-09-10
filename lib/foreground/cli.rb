module Foreground
  class CLI
    include Mixlib::CLI

    option :pid_file,
      :short => '-p FILE',
      :long  => '--pid_file FILE',
      :description => 'PID file for the daemon',
      :required => true

    option :command,
      :short => '-c COMMAND',
      :long  => '--command COMMAND',
      :description => 'Daemon command line',
      :required => true

    option :timeout,
      :short => '-t SECONDS',
      :long  => '--timeout SECONDS',
      :description => 'Timeout for the daemon to generate a valid PID file',
      :required => false,
      :default => 2,
      :proc => Proc.new { |t| t.to_i }

    class << self
      def run(argv=ARGV)
        new.run(argv)
      end
    end

    def run(argv)
      cmd = parse_options(argv)
      Foreground.config = config
      Daemon.run(config[:command], config[:pid_file])
    end
  end
end
