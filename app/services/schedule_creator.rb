class ScheduleCreator
  FREQUENCY_RULES = {
    "week" => -> (n, d = nil) { IceCube::Rule.weekly(n) },
    "month" => -> (n, d) { IceCube::Rule.monthly.count(1).day_of_week(d => [n]) }
  }

  def initialize(start_time:, every:, frequency:, day_of_week: nil)
    @start_time = start_time
    @every = every
    @frequency = FREQUENCY_RULES[frequency]
    @day_of_week = day_of_week.try(:to_sym)
  end

  def create_schedule
    schedule = IceCube::Schedule.new(@start_time)
    schedule.add_recurrence_rule @frequency.call(@every, @day_of_week )
    schedule.to_hash
  end
end
