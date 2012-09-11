require 'spec_helper'

module Foreground
  class Foo
    include Foreground
  end

  describe '#logger' do
    before do
      @logger = double('logger')
      @logger.stub(:formatter=)
      Logger.stub(:new).and_return(@logger)
      @foo = Foo.new
    end

    it 'should initialize a new logger once' do
      Logger.should_receive(:new).once.with(STDOUT)
      2.times { @foo.logger }
    end

    it 'should return the logger' do
      @foo.logger.should eql(@logger)
    end

    it 'should flush to stdout' do
      original_sync_state = STDOUT.sync
      STDOUT.sync = false
      STDOUT.sync.should be_false
      @foo.logger
      STDOUT.sync.should be_true
      STDOUT.sync = original_sync_state
    end
  end
end
