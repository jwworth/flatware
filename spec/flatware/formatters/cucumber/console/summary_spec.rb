require 'spec_helper'
require 'flatware/formatters/cucumber/console/summary'

describe Flatware::Formatters::Cucumber::Console::Summary do
  let(:summary) { described_class.new steps, scenarios, io }
  let(:io) { StringIO.new }
  let(:passed) { double 'passed step', status: :passed, failed?: false, failed_outside_step?: false }
  let(:failed) { double 'failed step', status: :failed, failed?: true, exception: exception, file_colon_line: "features/failed.feature:3", name: "failed", failed_outside_step?: false  }
  let(:failed2) { double 'failed step 2', status: :failed, failed?: true, exception: exception, file_colon_line: "features/failed_2.feature:8", name: "failed_2", failed_outside_step?: false }

  let(:exception) do
    double 'Exception',  backtrace: %w'backtrace', message: 'message', class: 'class'
  end

  let(:steps) { [] }
  let(:scenarios) { [] }

  before { summary.summarize }
  subject { io.tap(&:rewind).read.gsub /\e[^m]+m/, '' }

  context 'with a passed scenario' do
    let(:scenarios) { [passed] }
    it { should include %[1 scenario (1 passed)] }
  end

  context 'with 2 failed scenarios' do
    let(:scenarios) { [failed, failed2] }
    it 'displays a list of failed scenarios' do
      should include 'Failing Scenarios:'
      should include 'features/failed.feature'
      should include 'features/failed_2.feature'
    end
  end

  context 'with one passed and one failed scenario' do
    let(:scenarios) { [passed, failed] }
    it 'displays the count' do
      should include %[2 scenarios (1 passed, 1 failed)]
    end
  end

  context 'with a passed step' do
    let(:steps) { [passed] }
    it 'displays the count' do
      should include %[1 step (1 passed)]
    end
  end

  context 'with a failed step' do
    let(:steps) { [failed] }
    it 'contains the backtrace' do
      should include 'backtrace'
    end
  end

end


