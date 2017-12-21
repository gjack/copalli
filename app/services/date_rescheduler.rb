class DateRescheduler
  def initialize(meeting_schedule:, initial_date:, new_date:)
    @meeting_schedule = meeting_schedule
    @initial_date = initial_date
    @new_date = new_date
  end

  def preview_single
    schedule = @meeting_schedule.schedule
    upcoming = @meeting_schedule.upcoming_meeting.date
    if schedule.occurs_at?(upcoming) || @initial_date > upcoming
      schedule.add_exception_time(@initial_date)
      schedule.add_recurrence_time(@new_date.in_time_zone("UTC"))
      schedule.next_occurrences(4, @new_date - 1.day)
    else
      schedule.next_occurrences(3, @new_date - 1.day).unshift(upcoming)
    end
  end

  def preview_all_future
    new_schedule = calculate_new_schedule
    new_schedule.next_occurrences(4, @new_date - 1.day)
  end

  def update_single
    schedule = @meeting_schedule.schedule
    upcoming = @meeting_schedule.upcoming_meeting.date
    if schedule.occurs_at?(upcoming) || @initial_date > upcoming
      schedule.add_exception_time(@initial_date)
      schedule.add_recurrence_time(@new_date.in_time_zone("UTC"))
    end

    rescheduled_meeting = @meeting_schedule.meetings.find_by(date: @initial_date)
    rescheduled_meeting.update_attributes({ date: @new_date })
    @meeting_schedule.recurring = schedule.to_hash
    @meeting_schedule.save!
  end

  def update_all_future
    schedule = @meeting_schedule.schedule
    upcoming = @meeting_schedule.upcoming_meeting.date
    new_schedule = calculate_new_schedule
    if @initial_date > upcoming
      rescheduled_meeting = @meeting_schedule.meetings.find_by(date: @initial_date)
      rescheduled_meeting.update_attributes({ date: @new_date })
    else
      rescheduled_meetings = @meeting_schedule.meetings.where("date >= ?",  @initial_date)
      new_dates = new_schedule.next_occurrences(2, @new_date - 1.day)
      rescheduled_meetings.each.with_index do |meeting, index|
        meeting.update_attributes(date: new_dates[index])
      end
    end
    @meeting_schedule.recurring = new_schedule.to_hash
    @meeting_schedule.save!
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
