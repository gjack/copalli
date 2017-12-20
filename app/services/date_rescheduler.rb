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
end
