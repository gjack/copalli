class MeetingSchedule < ApplicationRecord
  serialize :recurring, Hash

  belongs_to :team_member
  has_many :meetings, dependent: :destroy
  before_create :set_recurrence_schedule
  after_create :set_first_meetings

  def upcoming_meeting
    meeting_date = schedule.next_occurrence(Time.now.beginning_of_day - 1.day)
    meeting_for_date(meeting_date)
  end

  def next_meeting
    meeting_date = schedule.next_occurrence
    meeting_for_date(meeting_date)
  end

  def previous_meeting
    meeting_date = schedule.previous_occurrence(Time.now.beginning_of_day - 1.day)
    meetings.find_by(date: meeting_date)
  end

  def previous_meetings
    previous_meeting.present? ? meetings.where("date < ?", previous_meeting.date) : Meeting.none
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

  def schedule
    IceCube::Schedule.from_hash(recurring)
  end

  def set_first_meetings
    dates = schedule.first(2)
    dates.each do |date|
      team_member.meetings.create({
        date: date,
        meeting_schedule_id: self.id,
        organization_id: team_member.organization_id,
        })
    end
  end

  def meeting_for_date(meeting_date)
    meeting = meetings.find_or_initialize_by(date: meeting_date)
    if meeting.new_record?
      meeting.team_member_id = team_member_id
      meeting.organization_id = team_member.organization.id
      meeting.save
    end
    meeting
  end
end
