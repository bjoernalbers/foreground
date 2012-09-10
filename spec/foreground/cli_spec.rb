require 'spec_helper'

module Foreground
  describe CLI do
    before do
      Daemon.stub(:run)
      @cmd = 'foreground_sample_daemon --with "some arguments"'
      @argv = ['--pid_file', '/tmp/foreground_sample_daemon.pid', '--command', @cmd]
      @cli = CLI.new
    end

    describe '.run' do
      it 'should run a new instance' do
        cli = mock('cli')
        cli.should_receive(:run).with(@argv)
        CLI.should_receive(:new).and_return(cli)
        CLI.run(@argv)
      end
    end

    describe '#run' do
      it 'should parse argv' do
        @cli.should_receive(:parse_options).with(@argv).and_return(@argv)
        @cli.run(@argv)
      end

      it 'should make the config globally available' do
        @cli.run(@argv)
        Foreground.config.should eql(@cli.config)
      end

      it 'should run the daemon' do
        Daemon.should_receive(:run).with(@cmd, '/tmp/foreground_sample_daemon.pid')
        @cli.run(@argv)
      end
    end
  end
end
