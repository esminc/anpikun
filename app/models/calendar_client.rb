require 'yaml'

module CalendarClient
  extend self

  def get_body(client, email, time_min = Time.now.beginning_of_day.iso8601, time_max = Time.now.end_of_day.iso8601)
    client.execute(
      api_method: client.discovered_api('calendar', 'v3').events.list,
      parameters: {
        'calendarId' => email.to_s,
        'timeMin' => time_min,
        'timeMax' => time_max
      }
    )
  end
end
