# frozen_string_literal: true

# Modified Formatter class to remove IPs from logging - CAZSM3
class Formatter
  FORMAT = "%s\n"

  # https://www.oreilly.com/library/view/regular-expressions-cookbook/9780596802837/ch07s16.html
  IP_REGEX = /\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/.freeze
  FILTERED_STRING = '[REDACTED]'

  def call(_severity, _time, _progname, msg)
    format(FORMAT, [msg2str(filter_ip(msg))])
  end

  private

  # Parse log messages and handle exceptions.
  def msg2str(msg)
    case msg
    when ::String
      msg
    when ::Exception
      "#{msg.message} (#{msg.class})\n" <<
        (msg.backtrace || []).join("\n")
    else
      msg.inspect
    end
  end

  # If log string contains IP address then replace it with custom string
  def filter_ip(msg)
    msg.gsub(IP_REGEX, FILTERED_STRING)
  end
end
