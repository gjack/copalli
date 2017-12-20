require "rails_helper"

describe DateRescheduler do
  let(:start_date) { Time.local(2017, 12, 20).beginning_of_day }
  let(:old_date) { Time.local(2018, 1, 17).beginning_of_day }
  let(:new_date) { Time.local(2018, 1, 23).beginning_of_day }
  let(:organization) { create(:organization) }
  let(:person) { create(:user, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:team_member) { create(:team_member, user: person, organization: organization, team: team) }
  let(:meeting_schedule) { create_meeting_schedule }

  let(:subject) { DateRescheduler.new(meeting_schedule: meeting_schedule, initial_date: old_date, new_date: new_date) }

  before do
    Timecop.freeze(Time.local(2017, 12, 18))
  end

  describe "#preview_single" do
    it "substitutes the old date for the new one" do
      preview_dates = subject.preview_single
      expect(preview_dates).to_not include(old_date)
      expect(preview_dates).to include(new_date)
    end
  end

  describe "#preview_all_future" do
    it "updates all future dates after upcoming one" do
      expected = [
        Time.local(2018, 1, 23).beginning_of_day,
        Time.local(2018, 2, 6).beginning_of_day,
        Time.local(2018, 2, 20).beginning_of_day,
        Time.local(2018, 3, 6).beginning_of_day
      ]

      expect(subject.preview_all_future).to match_array(expected)
    end

    let(:old_date2) { Time.local(2017, 12, 20).beginning_of_day }
    let(:new_date2) { Time.local(2017, 12, 19).beginning_of_day }
    let(:new_subject) { DateRescheduler.new(meeting_schedule: meeting_schedule, initial_date: old_date2, new_date: new_date2) }

    it "updates all future dates including upcoming" do
      expected = [
        Time.local(2017, 12, 19).beginning_of_day,
        Time.local(2018, 1, 2).beginning_of_day,
        Time.local(2018, 1, 16).beginning_of_day,
        Time.local(2018, 1, 30).beginning_of_day
      ]

      expect(new_subject.preview_all_future).to match_array(expected)
    end
  end

  def create_meeting_schedule
    create(
      :meeting_schedule,
      start_time: start_date,
      every: 2,
      frequency: "week",
      day_of_week: nil,
      team_member: team_member
    )
  end
end
