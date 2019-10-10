# frozen_string_literal: true

##
# Class is used to build the list of available dates
# and display them on +app/views/charges/dates.html.haml+
#
class Dates
  # date format, e.g. 'Friday 11 October 2019'
  DATE_FORMAT = '%A %d %B %Y'
  ##
  #
  #
  # ==== Attributes
  # * +today+ - current date
  # * +dates+ - array
  #
  def initialize
    @today = Date.current
    @dates = []
  end

  # Build the list of dates and return them, e.g.
  # [{:value=>"2019-10-11", :name=>"Friday 11 October 2019"},...]
  def build
    add_previous_working_days
    add_today_and_next_six_days
    dates
  end

  private

  # today and dates getters
  attr_reader :today, :dates

  # Add previous working days.
  # If yesterday was Sunday, add Friday, Saturday and Sunday
  # If yesterday was Saturday, add Friday and Saturday
  # If yesterday was working day, add only that day
  def add_previous_working_days
    prev_day = today.yesterday
    if prev_day.wday.zero?
      add_three_days(prev_day)
    elsif prev_day.wday == 6
      add_two_days(prev_day)
    else
      add_one_day(prev_day)
    end
  end

  # Add today and next six days to +dates+
  def add_today_and_next_six_days
    today.upto(today + 6.days) do |date|
      @dates << {
        value: date.strftime('%F'),
        name: date.strftime(DATE_FORMAT)
      }
    end
  end

  # Add last three days to +dates+ in case when yesterday was Sunday
  def add_three_days(monday)
    friday = monday - 2.days
    friday.upto(friday + 2.days) do |date|
      @dates << {
        value: date.strftime('%F'),
        name: date.strftime(DATE_FORMAT)
      }
    end
  end

  # Add last two days to +dates+ in case when yesterday was Saturday
  def add_two_days(sunday)
    friday = sunday - 1.day
    friday.upto(friday + 1.day) do |date|
      @dates << {
        value: date.strftime('%F'),
        name: date.strftime(DATE_FORMAT)
      }
    end
  end

  # Add yesterday day to +dates+ in case when yesterday was not Sunday or Saturday
  def add_one_day(working_day)
    @dates << {
      value: working_day.strftime('%F'),
      name: working_day.strftime(DATE_FORMAT)
    }
  end
end
