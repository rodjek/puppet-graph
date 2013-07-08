require 'spec_helper'
require 'puppet-graph/cli'
require 'fileutils'

class CommandRun
  attr_reader :stdout, :stderr, :exitstatus

  def initialize(args)
    out = StringIO.new
    err = StringIO.new

    $stdout = out
    $stderr = err

    @exitstatus = PuppetGraph::CLI.run(args)
    @stdout = out.string.strip
    @stderr = err.string.strip

    $stdout = STDOUT
    $stderr = STDERR
  end
end

describe PuppetGraph::CLI do
  subject do
    if args.is_a? Array
      sane_args = args
    else
      sane_args = [args]
    end

    CommandRun.new(sane_args)
  end

  context 'when passed --version' do
    let(:args) { '--version' }

    its(:exitstatus) { should eq(0) }
    its(:stdout) { should eq("puppet-graph v#{PuppetGraph::VERSION}") }
    its(:stderr) { should eq('') }
  end

  context 'when passed --help' do
    let(:args) { '--help' }

    its(:exitstatus) { should eq(0) }
    its(:stderr) { should eq('') }
    its(:stdout) { should include('Usage: puppet-graph [options]') }
  end

  context 'when generating PNG graphs' do
    let(:args) { [
      '--modulepath', 'spec/fixtures/modules',
      '--code', 'include test',
      '--output', 'test.png'
    ] }

    its(:exitstatus) { should eq(0) }

    it 'should create a PNG image' do
      subject
      expect(`file test.png`).to include('PNG image data')
    end
  end

  context 'when generating DOT graphs' do
    let(:args) { [
      '--modulepath', 'spec/fixtures/modules',
      '--code', 'include test',
      '--output', 'test.dot',
    ] }

    its(:exitstatus) { should eq(0) }

    it 'should create an ASCII file' do
      subject
      expect(`file test.dot`).to include('ASCII text')
    end
  end

  context 'when overriding output format' do
    let(:args) { [
      '--modulepath', 'spec/fixtures/modules',
      '--code', 'include test',
      '--format', 'dot',
      '--output', 'test.png',
    ] }

    its(:exitstatus) { should eq(0) }

    it 'should create an ASCII file' do
      subject
      expect(`file test.png`).to include('ASCII text')
    end
  end

  context 'when specifying a fact' do
    let(:args) { [
      '--modulepath', 'spec/fixtures/modules',
      '--code', 'include test::facter',
      '--fact', 'operatingsystem=foo',
      '--output', 'test.dot',
    ] }

    its(:exitstatus) { should eq(0) }

    it 'should contain Notify[foo]' do
      subject
      contents = File.read('test.dot')
      expect(contents).to include('Notify[foo]')
      expect(contents).to_not include('Notify[other]')
    end
  end

  context 'when you dont provide --code' do
    let(:args) { [
      '--modulepath', 'spec/fixtures/modules',
      '--output', 'test.png',
    ] }

    its(:exitstatus) { should eq(1) }
    its(:stdout) { should eq('') }
    its(:stderr) { should include('Error: No Puppet code') }
    its(:stderr) { should include('Usage: puppet-graph') }
  end

  context 'when you specify an invalid output format' do
    let(:args) { [
      '--modulepath', 'spec/fixtures/modules',
      '--code', 'include test',
      '--output', 'test.foo',
    ] }

    its(:exitstatus) { should eq(1) }
    its(:stdout) { should eq('') }
    its(:stderr) { should include('Error: Invalid format') }
    its(:stderr) { should include('Usage: puppet-graph') }
  end
end
