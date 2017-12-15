class ScheduleCreator
  FREQUENCY_RULES = {
    "week" => -> (n) { IceCube::Rule.weekly(n) },
    "month" => -> (n) { IceCube::Rule.monthly(n) }
  }

  def initialize(start_time:, every:, frequency:)
    @start_time = start_time
    @every = every
    @frequency = FREQUENCY_RULES[frequency]
  end

  def create_schedule
    schedule = IceCube::Schedule.new(@start_time)
    schedule.add_recurrence_rule @frequency.call(@every)
    schedule.to_hash
  end
end
