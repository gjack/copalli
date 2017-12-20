class DateRescheduler
  def initialize(meeting_schedule:, initial_date:, new_date:)
    @meeting_schedule = meeting_schedule
    @initial_date = initial_date
    @new_date = new_date
  end

  def preview_single
    schedule = @meeting_schedule.schedule
    schedule.add_exception_time(@initial_date)
    schedule.add_recurrence_time(@new_date)
    schedule.next_occurrences(4, @new_date - 1.day)
  end

  def preview_all_future
    schedule = @meeting_schedule.schedule
    upcoming = schedule.next_occurrence(Time.now.beginning_of_day - 1.day)
    if @initial_date > upcoming
      new_schedule = calculate_new_schedule
      new_schedule.add_recurrence_time(upcoming)
      new_schedule.next_occurrences(4, @new_date - 1.day)
    else
      new_schedule = calculate_new_schedule
      new_schedule.next_occurrences(4, @new_date - 1.day)
    end
  end

  private

  def calculate_new_schedule
    new_schedule_hash = ScheduleCreator.new(
      start_time: @new_date,
      frequency: @meeting_schedule.frequency,
      every: get_new_schedule_every,
      day_of_week: get_new_schedule_day_of_week,
    ).create_schedule

    IceCube::Schedule.from_hash(new_schedule_hash)
  end

  def get_new_schedule_every
    if @meeting_schedule.frequency == "week"
      @meeting_schedule.every
    else
      (@new_date.mday / 7.0).ceil
    end
  end

  def get_new_schedule_day_of_week
    @meeting_schedule.frequency == "month" ? @new_date.strftime("%A").downcase : ""
  end
end
