require 'spec_helper'

module Foreground
  describe CLI do
    before do
      CLI.stub(:system)
      @argv = ['--pid_file', '/tmp/foreground_sample_daemon.pid', 'foreground_sample_daemon']
      @cli = CLI.new
      @cli.stub(:watch) # ...or we'll wait forever.
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

      it 'should run the daemon' do
        @cli.should_receive(:system).with('foreground_sample_daemon')
        @cli.run(@argv)
      end

      it 'should watch the daemon' do
        @cli.should_receive(:watch)
        @cli.run(@argv)
      end
    end
  end
end
