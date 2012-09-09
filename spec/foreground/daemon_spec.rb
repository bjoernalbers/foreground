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
      it 'should run and register a new instance' do
        daemon = mock('daemon')
        daemon.should_receive(:run)
        Daemon.should_receive(:new).with(*@args).and_return(daemon)
        Daemon.daemon.should be_nil
        Daemon.run(*@args)
        Daemon.daemon.should be(daemon)
      end
    end

    describe '.kill' do
      it 'should forward signals to the daemon' do
        Daemon.daemon = mock('daemon')
        Daemon.daemon.should_receive(:kill).with(:FOO)
        Daemon.kill(:FOO)
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

    describe '#read_pid' do
      context 'with existing PID file' do
        it 'should return the PID' do
          File.should_receive(:read).with(@pid_file).and_return("#{@pid}\n")
          @daemon.send(:read_pid).should eql(@pid)
        end
      end

      context 'with unreadable PID' do
        it 'should raise error' do
          File.should_receive(:read).with(@pid_file).and_return('fortytwo')
          lambda { @daemon.send(:read_pid) }.should raise_error(DaemonError, /pid not readable from #{@pid_file}/i)
        end
      end
    end

    describe '#pid' do
      context 'with readable PID' do
        it 'should cache and return the PID' do
          @daemon.should_receive(:read_pid).once.and_return(@pid)
          2.times { @daemon.pid.should eql(@pid) }
        end
      end

      context 'with unreadable PID' do
        it 'should rescue and retry after sleep' do
          @daemon.should_receive(:read_pid).and_raise(StandardError)
          @daemon.should_receive(:sleep).with(0.1).and_return(nil)
          @daemon.pid
        end

        it 'should reraise last exception after 2 seconds' do
          @daemon.stub(:read_pid).and_raise(Errno::ENOENT)
          @daemon.should_receive(:sleep).with(0.1).exactly(20).times.and_return(true)
          lambda { @daemon.pid }.should raise_error(Errno::ENOENT)
        end
      end
    end
  end
end
