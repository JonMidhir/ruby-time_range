# frozen_string_literal: true

require_relative 'time_range/core_ext/range.rb'
require 'date'

# An enhanced, Range-type class that provides useful methods that apply to
# time-based objects.
#
# @since 0.0.1
class TimeRange < Range
  def initialize(b, e, exclude_end = false)
    raise TypeError unless [b, e].all? { |arg| arg.is_a?(Time) }

    valid_time = if exclude_end
                   (e - 1) >= b
                 else
                   e >= b
                 end

    raise ArgumentError unless valid_time

    super
  end

  # Reimplementation of Range#== to account for time ranges excluding end being
  # one second shorter than their end implies.
  #
  # @param [TimeRange] time_range time range to compare for equality
  # @return [Boolean] whether contents of two TimeRanges match
  def ==(other)
    return false unless other.is_a?(self.class)

    if exclude_end? || other.exclude_end?
      return self.begin == other.begin && max == other.max
    end

    super
  end

  alias eql? ==

  # Reimplementation of Range#max. TimeRange makes one assumption; that ranges
  # excluding end should be one second shorter than those that don't.
  #
  # Normal Ranges simply TypeError when excluding_end is true. However, since
  # Ruby's Time methods assume seconds anyway, it is reasonable to use seconds
  # here.
  #
  # Doing so enables the implementation of a number of useful TimeRange methods.
  #
  # @return [Time] the highest time included in the range
  def max
    return self.end - 1 if exclude_end?

    super
  end

  # The duration of the time range in seconds.
  #
  # @return [Float] the number of seconds in the time range
  def duration
    max - self.begin
  end

  # Compares another time range for any kind of overlap; partial or complete.
  #
  # @param [TimeRange] time_range time range to compare for overlap
  # @return [Boolean] whether contents of two TimeRanges overlap
  def overlaps?(time_range)
    raise TypeError unless time_range.is_a?(TimeRange)

    %w(begins_within? ends_within? encapsulates?).any? do |condition|
      send(condition, time_range)
    end
  end

  # Compares another time range for complete encapsulation. A time range is
  # considered encapsulated if it begins and ends within this one, including if
  # the ranges match exactly.
  #
  # @param [TimeRange] time_range time range to compare for encapsulation
  # @return [Boolean] whether the target range is encapsulated
  def encapsulates?(time_range)
    raise TypeError unless time_range.is_a?(TimeRange)

    self.begin <= time_range.begin && max >= time_range.max
  end

  # Reverse of #encapsulates?, checks if the current time range is encapsulated
  # by another.
  #
  # @param [TimeRange] time_range time range to compare against encapsulation
  # @return [Boolean] whether the target range encapsulates this one
  def encapsulated_by?(time_range)
    raise TypeError unless time_range.is_a?(TimeRange)

    time_range.encapsulates?(self)
  end

  # Returns the overlap between this and the argument as a new time range.
  #
  # @param [TimeRange] time_range time range to compare for encapsulation
  # @return [TimeRange, nil] the overlap in a TimeRange or nil if none occurs
  def overlap_with(time_range)
    raise TypeError unless time_range.is_a?(TimeRange)

    self.class.new(
      [self.begin, time_range.begin].max,
      [max, time_range.max].min
    ) if overlaps?(time_range)
  end

  # Returns the dates in the current TimeRange as a Range of Dates.
  #
  # @return [Range] the dates in the current time range
  def dates
    b_date = Date.civil(self.begin.year, self.begin.month, self.begin.day)
    e_date = Date.civil(max.year, max.month, max.day)

    b_date..e_date
  end

  private

  def begins_within?(time_range)
    self.begin >= time_range.begin && self.begin <= time_range.max
  end

  def ends_within?(time_range)
    max <= time_range.max && max >= time_range.begin
  end
end
