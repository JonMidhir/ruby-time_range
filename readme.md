## TimeRange

Enhance your Ruby project with time-based ranges.

## Installation

Install the `time_range` gem and require it in your project.

```shell
gem install ruby-time_range
```

or include the gem in your Gemfile and `bundle install`.

```ruby
gem 'ruby-time_range'
```

## About

`TimeRange` extends the regular `Range` with useful methods that apply to time-based objects. Where appropriate, it reimplements `Range` methods as they should apply to Time-based ranges.

`TimeRange`s can be compared and examined in useful ways.

- `TimeRange#duration` The duration of the TimeRange in seconds.
- `TimeRange#encapsulates?` Check if one TimeRange encapsulates another entirely.
- `TimeRange#encapsulated_by?` Check if one TimeRange is encapsulated by another entirely...
- `TimeRange#overlaps?` Check if one TimeRange overlaps another in any way.
- `TimeRange#overlap_with` Returns the overlap between two TimeRanges, as a new TimeRange.
- `TimeRange#dates` Returns a range of dates in the TimeRange.

Existing Range methods; such as `#max`, `#min`, `#cover?`, `#==`, etc, are still available, having been reimplemented where appropriate to maintain consistency in a temporal context.

TimeRanges can be easily created by calling `#to_time_range` on any normal Range of Times.

```ruby
  (Time.now .. (Time.now + 60)).to_time_range
```

For full API documentation see the [rubydocs](http://www.rubydoc.info/gems/ruby-time_range/0.1.0/TimeRange).

## Contributing
- Fork and clone the project.
- `git checkout master`.
- `git checkout -b ` a topic branch for your fix/addition.
- Run `bundle`.
- Make and commit your changes.
- Push to your fork and pull request against master.

#### Note:
- Contributions will not be accepted without tests.
- Please read and check Github issues and pending pull requests before submitting new code.
- If adding a feature please post a new issue for discussion first.

Thanks for taking the time to contribute!

## License

ruby-time_range is Copyright ©2016 Jon Hope. It is free software, and may be redistributed under the terms specified in the [LICENSE](https://github.com/jonmidhir/ruby-time_range/blob/master/LICENSE) file.
