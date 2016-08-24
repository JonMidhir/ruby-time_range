# frozen_string_literal: true

# Reopens the Range class from the core lib to include methods to converting to
# TimeRange.
#
# @since 0.0.1
class Range
  # Converts a Range of Times into a TimeRange.
  #
  # @return [TimeRange]
  def to_time_range
    TimeRange.new(self.begin, self.end, exclude_end?)
  end
end
