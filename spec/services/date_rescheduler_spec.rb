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

  describe "#preview_single" do
    it "substitutes the old date for the new one" do
      preview_dates = subject.preview_single
      expect(preview_dates).to_not include(old_date)
      expect(preview_dates).to include(new_date)
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
