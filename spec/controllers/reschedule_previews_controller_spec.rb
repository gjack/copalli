require "rails_helper"

describe ReschedulePreviewsController do
  include Devise::Test::ControllerHelpers

  describe "#index" do
    let(:start_date) { Time.local(2017, 12, 20).beginning_of_day }
    let(:old_date) { Time.local(2018, 1, 17).beginning_of_day.in_time_zone("UTC").strftime("%Y-%m-%dT%H:%M:%S:z") }
    let(:new_date) { Time.local(2018, 1, 23).beginning_of_day.in_time_zone("UTC").strftime("%Y-%m-%dT%H:%M:%S:z") }
    let(:organization) { create(:organization) }
    let(:person) { create(:user, organization: organization) }
    let(:team) { create(:team, organization: organization) }
    let(:team_member) { create(:team_member, user: person, organization: organization, team: team) }
    let(:meeting_schedule) { create_meeting_schedule }

    before do
      Timecop.freeze(Time.local(2017, 12, 18))
      sign_in person
    end

    it "response includes both scopes single and future" do
      get :index, params: { meeting_schedule_id: meeting_schedule.id, initial_date: old_date, new_date: new_date}
      resp = JSON.parse(response.body)

      expect(resp).to have_key("scope_single")
      expect(resp).to have_key("scope_future")
    end

    it "each scope contains an array of dates for future occurrences" do
      get :index, params: { meeting_schedule_id: meeting_schedule.id, initial_date: old_date, new_date: new_date}
      resp = JSON.parse(response.body)

      expect(resp["scope_single"]).to match_array(["1/23/2018", "1/31/2018", "2/14/2018", "2/28/2018"])
      expect(resp["scope_future"]).to match_array(["1/23/2018", "2/06/2018", "2/20/2018", "3/06/2018"])
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
