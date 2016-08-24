# frozen_string_literal: true

require 'time_range/core_ext/range.rb'

describe Range do
  subject { described_class.new(Time.now.getlocal, Time.now.getlocal + 5) }

  it { is_expected.to respond_to(:to_time_range) }
  it { expect(subject.to_time_range).to be_a(TimeRange) }
end
