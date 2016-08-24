# frozen_string_literal: true

require 'spec_helper.rb'
require 'time_range.rb'

describe TimeRange do
  let(:beginning) { Time.now.getlocal }
  let(:ending) { beginning + 60 }
  let(:time_range) { TimeRangeFactory.new(beginning, ending) }

  subject { time_range[:base_range] }

  it { is_expected.to be_a(Range) }
  it { is_expected.to be_a(TimeRange) }

  describe '#initialize' do
    context 'with non-Time element' do
      let(:ending) { 10 }

      it { expect { subject }.to raise_error TypeError }
    end

    context 'with negative time span' do
      let(:ending) { beginning - 10 }

      it { expect { subject }.to raise_error ArgumentError }
    end

    context 'with valid elements' do
      it { expect(subject.begin).to eq beginning }
      it { expect(subject.end).to eq ending }
      it { is_expected.not_to be_exclude_end }
    end
  end

  # Overridden methods
  describe '#==' do
    context 'when ranges match in contents' do
      context 'when exclude_end matches' do
        let(:new_range) { described_class.new(beginning, ending) }

        it { expect(subject.==(new_range)).to be true }
      end

      context 'when exclude_end does not match' do
        let(:new_range) { described_class.new(beginning, ending + 1, true) }

        it { expect(subject.==(new_range)).to be true }
      end
    end

    context 'when ranges do not match in contents' do
      context 'when exclude_end matches' do
        let(:new_range) { described_class.new(beginning, ending + 1) }

        it { expect(subject.==(new_range)).to be false }
      end

      context 'when exclude_end does not match' do
        let(:new_range) { described_class.new(beginning, ending, true) }

        it { expect(subject.==(new_range)).to be false }
      end
    end
  end

  describe '#eql?' do
    it { expect(subject.method(:==)).to eql(subject.method(:eql?)) }
  end

  describe '#cover?' do
    context 'when subject range includes end' do
      it { is_expected.to cover(Time.now.getlocal + 15) }
      it { is_expected.not_to cover(Time.now.getlocal + 65) }
    end

    context 'when subject range excludes end' do
      let(:time_range) { TimeRangeFactory.new(beginning, ending, true) }

      it { is_expected.to cover(Time.now.getlocal + 15) }
      it { is_expected.not_to cover(Time.now.getlocal + 65) }
    end
  end

  describe '#max' do
    context 'when range includes end' do
      it { expect(subject.max).to eq ending }
    end

    context 'when range excludes end' do
      subject { described_class.new(beginning, ending, true) }

      it { expect(subject.max).to eq(ending - 1) }
    end
  end

  # These are new instance methods introduced by TimeRange
  describe '#duration' do
    context 'when includes end' do
      it { expect(subject.duration).to eq(ending - beginning) }
    end

    context 'when excludes end' do
      subject { described_class.new(beginning, ending, true) }

      it { expect(subject.duration).to eq(ending - beginning - 1) }
    end
  end

  describe '#overlaps?' do
    context 'when not given a TimeRange as argument' do
      it { expect { subject.overlaps?(1..5) }.to raise_error TypeError }
    end

    context 'when given a TimeRange as argument' do
      context 'when test range does not overlap subject' do
        [:after, :before].each do |test_position|
          it { is_expected.not_to be_overlaps(time_range[test_position]) }
        end
      end

      context 'when test range does overlap subject' do
        [:overlapping_start, :bordering_start, :overlapping_end, :bordering_end,
         :contained, :containing].each do |test_position|
          it { is_expected.to be_overlaps(time_range[test_position]) }
        end
      end
    end
  end

  describe '#encapsulates?' do
    context 'when not given a TimeRange as argument' do
      it { expect { subject.encapsulates?(1..5) }.to raise_error TypeError }
    end

    context 'when given a TimeRange as argument' do
      context 'when test range is fully contained' do
        it { expect(subject).to be_encapsulates(time_range[:contained]) }
      end

      context 'when subject does not encapsulate test range' do
        [:containing, :before, :overlapping_start, :bordering_start, :after,
         :overlapping_end, :bordering_end].each do |test_position|
          it { is_expected.not_to be_encapsulates(time_range[test_position]) }
        end
      end
    end
  end

  describe '#encapsulated_by?' do
    context 'when not given a TimeRange as argument' do
      it { expect { subject.encapsulated_by?(1..5) }.to raise_error TypeError }
    end

    context 'when given a TimeRange as argument' do
      context 'when test range fully contains subject' do
        it { expect(subject).to be_encapsulated_by(time_range[:containing]) }
      end

      context 'when subject is not encapsulated by test range' do
        [:contained, :before, :overlapping_start, :bordering_start, :after,
         :overlapping_end, :bordering_end].each do |test_pos|
          it { is_expected.not_to be_encapsulated_by(time_range[test_pos]) }
        end
      end
    end
  end

  describe '#overlap_with' do
    context 'when not given a TimeRange as argument' do
      it { expect { subject.overlap_with(1..5) }.to raise_error TypeError }
    end

    context 'when given a TimeRange as argument' do
      let(:result_range) { subject.overlap_with(test_range) }

      context 'when test range does not overlap subject' do
        [:after, :before].each do |test_position|
          let(:test_range) { time_range[test_position] }

          it { expect(result_range).to be_nil }
        end
      end

      context 'when test range does overlap subject' do
        describe 'type returned' do
          let(:test_range) { time_range[:overlapping_start] }

          it { expect(result_range).to be_a(TimeRange) }
        end

        context 'when overlapping the start' do
          let(:test_range) { time_range[:overlapping_start] }

          it { expect(result_range.begin).to eq(subject.begin) }
          it { expect(result_range.max).to eq(test_range.max) }
        end

        context 'when overlapping the end' do
          let(:test_range) { time_range[:overlapping_end] }

          it { expect(result_range.begin).to eq(test_range.begin) }
          it { expect(result_range.max).to eq(subject.max) }
        end

        context 'when contained within subject range' do
          let(:test_range) { time_range[:contained] }

          it { expect(result_range.begin).to eq(test_range.begin) }
          it { expect(result_range.max).to eq(test_range.max) }
        end

        context 'when containing subject range' do
          let(:test_range) { time_range[:containing] }

          it { expect(result_range.begin).to eq(subject.begin) }
          it { expect(result_range.max).to eq(subject.max) }
        end

        context 'when bordering the start' do
          let(:test_range) { time_range[:bordering_start] }

          it { expect(result_range.begin).to eq(subject.begin) }
          it { expect(result_range.max).to eq(test_range.max) }
        end

        context 'when bordering the end' do
          let(:test_range) { time_range[:bordering_end] }

          it { expect(result_range.begin).to eq(test_range.begin) }
          it { expect(result_range.max).to eq(subject.max) }
        end
      end
    end
  end

  describe '#dates' do
    to_date = lambda { |t| Date.civil(t.year, t.month, t.day) }

    let(:result_range) { to_date.call(beginning)..to_date.call(ending) }

    context 'when range includes one day' do
      let(:beginning) { Time.new(2002, 10, 31).utc }
      let(:ending) { beginning + 60 }

      it { expect(subject.dates).to eq(result_range) }
    end

    context 'when range includes multiple days' do
      let(:beginning) { Time.new(2002, 10, 31).utc }
      let(:ending) { beginning + 1_000_000 }

      it { expect(subject.dates).to eq(result_range) }
    end
  end
end
