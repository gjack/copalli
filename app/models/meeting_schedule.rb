class MeetingSchedule < ApplicationRecord
  serialize :recurring, Hash

  belongs_to :team_member
  has_many :meetings, dependent: :destroy
  before_create :set_recurrence_schedule
  after_create :set_first_meetings

  def upcoming_meeting
    upcoming = meetings.scheduled_meetings.where("date > ?", Time.now.beginning_of_day - 1.day).first
    return upcoming if upcoming.present?
    meeting_date = schedule.next_occurrence(Time.now.beginning_of_day - 1.day)
    meeting_for_date(meeting_date)
  end

  def next_meeting
    next_meet = meetings.scheduled_meetings.where("date > ?", upcoming_meeting.date).first
    return next_meet if next_meet.present?
    meeting_date = schedule.next_occurrence(upcoming_meeting.date)
    meeting_for_date(meeting_date)
  end

  def previous_meeting
    previous_meetings.last
  end

  def previous_meetings
    meetings.scheduled_meetings.where("date < ?", Time.now.beginning_of_day - 1.day)
  end

  def past_meetings
    past = meetings.where("date < ?", Time.now.beginning_of_day - 1.day)
    previous_meeting.present? ? past.where.not(id: previous_meeting.id) : past
  end

  def schedule
    IceCube::Schedule.from_hash(recurring)
  end

  private

  def set_recurrence_schedule
    self.recurring = ScheduleCreator.new(
      start_time: start_time,
      every: every,
      frequency: frequency,
      day_of_week: day_of_week
    ).create_schedule
  end

  def set_first_meetings
    dates = schedule.first(2)
    dates.each do |date|
      team_member.meetings.create({
        date: date,
        meeting_schedule_id: self.id,
        organization_id: team_member.organization_id,
        scheduled: true
        })
    end
  end

  def meeting_for_date(meeting_date)
    meeting = meetings.scheduled_meetings.find_or_initialize_by(date: meeting_date)
    if meeting.new_record?
      meeting.team_member_id = team_member_id
      meeting.organization_id = team_member.organization.id
      meeting.scheduled = true
      meeting.save
    end
    meeting
  end
end
