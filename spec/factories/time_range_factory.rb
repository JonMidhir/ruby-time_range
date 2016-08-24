# frozen_string_literal: true

require 'time_range'

class TimeRangeFactory
  def initialize(*args)
    @b, @e, @exclude_end = args
  end

  def [](type)
    public_send(type)
  end

  def base_range
    @base_range ||= TimeRange.new(@b, @e, @exclude_end)
  end

  def contained
    TimeRange.new(@b + 10, @e - 10, @exclude_end)
  end

  def containing
    TimeRange.new(@b - 10, @e + 10, @exclude_end)
  end

  def before
    TimeRange.new(@b - 60, @b - 1, @exclude_end)
  end

  def after
    TimeRange.new(@e + 1, @e + 60, @exclude_end)
  end

  def overlapping_start
    TimeRange.new(@b - 20, @e - 20, @exclude_end)
  end

  def overlapping_end
    TimeRange.new(@b + 20, @e + 20, @exclude_end)
  end

  def bordering_start
    TimeRange.new(@b - 60, @b, @exclude_end)
  end

  def bordering_end
    TimeRange.new(@e, @e + 60, @exclude_end)
  end
end
