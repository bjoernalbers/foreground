require 'spec_helper'

module Foreground
  describe Daemon do
    before do
      Process.stub(:kill)
      @cmd = ['some_daemon', '--with', 'arguments']
      @pid_file = 'some_daemon.pid'
      @pid = 42
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
      it 'should run and watch the daemon' do
        @daemon.should_receive(:system).with(*@cmd).ordered
        @daemon.should_receive(:watch).ordered
        @daemon.run
      end
    end

    describe '#kill' do
      it 'should send the daemon a SIGTERM' do
        @daemon.stub(:pid).and_return(42)
        Process.should_receive(:kill).with(:TERM, 42)
        @daemon.kill
      end
    end

    describe '#pid' do
      it 'should return the daemons PID by PID file' do
        File.should_receive(:read).with(@pid_file).and_return("#{@pid}\n")
        @daemon.pid.should eql(@pid)
      end
    end
  end
end
