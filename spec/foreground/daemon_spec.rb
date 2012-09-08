require 'spec_helper'

module Foreground
  describe Daemon do
    before do
      @cmd = ['some_daemon', '--with', 'arguments']
      @pid_file = 'some_daemon.pid'
      @args = [@cmd, @pid_file]
      @daemon = Daemon.new(@cmd, @pid_file)
      @daemon.stub(:watch) # ...or we'll wait forever.
      @daemon.stub(:system) # ...so that we don't run any stupid commands in our tests.
    end

    describe '.run' do
      it 'should run a new instance' do
        daemon = mock('daemon')
        daemon.should_receive(:run)
        Daemon.should_receive(:new).with(*@args).and_return(daemon)
        Daemon.run(*@args)
      end
    end

    describe '#run' do
      it 'should run the daemon' do
        @daemon.should_receive(:system).with(*@cmd)
        @daemon.run
      end
    end
  end
end
