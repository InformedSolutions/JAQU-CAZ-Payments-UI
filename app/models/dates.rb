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
    @yesterday = Date.current.yesterday
    @tomorrow = Date.current.tomorrow
    @dates = []
  end

  # Build the list of dates and return them, e.g.
  # [{:value=>"2019-10-11", :name=>"Friday 11 October 2019"},...]
  def build
    add_previous_working_days
    add_today
    add_six_working_days
    dates
  end

  private

  # today and dates getters
  attr_reader :today, :yesterday, :tomorrow, :dates

  # Add previous working days.
  # If yesterday was Sunday, add Friday, Saturday and Sunday
  # If yesterday was Saturday, add Friday and Saturday
  # If yesterday was working day, add only that day
  def add_previous_working_days
    if yesterday.sunday? || yesterday.saturday?
      add_weekend_days
    else
      add_one_day
    end
  end

  # Add today to +dates+
  def add_today
    add_to_array(today)
  end

  # Add next six working days to +dates+ includes all weekends
  def add_six_working_days
    maximum_end_date = today + 10.days
    working_days_count = 0

    (tomorrow..maximum_end_date).each do |date|
      break if working_days_count == 6

      working_days_count += 1 if date.on_weekday?
      add_to_array(date)
    end
  end

  # Add last two or three days to +dates+ in case when yesterday was Sunday or Saturday
  def add_weekend_days
    friday = today.prev_weekday
    friday.upto(yesterday) do |date|
      add_to_array(date)
    end
  end

  # Add yesterday day to +dates+ in case when yesterday was not Sunday or Saturday
  def add_one_day
    add_to_array
  end

  # Add date to +dates+
  def add_to_array(date = yesterday)
    @dates << {
      value: date.strftime('%F'),
      name: date.strftime(DATE_FORMAT),
      today: date.today?
    }
  end
end
