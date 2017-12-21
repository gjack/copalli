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

  describe "#update_single" do
    let(:old_date3) { Time.local(2018, 1, 3).beginning_of_day }
    let(:new_date3) { Time.local(2018, 1, 5).beginning_of_day }
    let(:subject3) { DateRescheduler.new(meeting_schedule: meeting_schedule, initial_date: old_date3, new_date: new_date3) }

    it "updates meeting with new date" do
      original_meeting = meeting_schedule.meetings.find_by(date: old_date3)
      subject3.update_single
      expect(original_meeting.reload.date).to eq(new_date3)
    end

    it "keeps all other dates in schedule untouched" do
      expected = [
        Time.local(2017, 12, 20).beginning_of_day,
        Time.local(2018, 1, 5).beginning_of_day,
        Time.local(2018, 1, 17).beginning_of_day,
        Time.local(2018, 1, 31).beginning_of_day,
      ]

      subject3.update_single
      expect(meeting_schedule.reload.schedule.next_occurrences(4)).to match_array(expected)
    end
  end

  describe "#update_all_future" do
    before do
      Timecop.freeze(Time.local(2017, 12, 18))
    end

    context "when updating all after some date after upcoming" do
      let(:old_date4) { Time.local(2018, 1, 3).beginning_of_day }
      let(:new_date4) { Time.local(2018, 1, 5).beginning_of_day }
      let(:subject4) { DateRescheduler.new(meeting_schedule: meeting_schedule, initial_date: old_date4, new_date: new_date4) }

      it "updates meeting with future date" do
        original_meeting = meeting_schedule.meetings.find_by(date: old_date4)
        subject4.update_all_future
        expect(original_meeting.reload.date).to eq(new_date4)
      end

      it "updates all future dates in the schedule" do
        expected = [
          Time.local(2018, 1, 5).beginning_of_day,
          Time.local(2018, 1, 19).beginning_of_day,
          Time.local(2018, 2, 2).beginning_of_day,
          Time.local(2018, 2, 16).beginning_of_day,
        ]
        subject4.update_all_future
        expect(meeting_schedule.reload.schedule.next_occurrences(4)).to match_array(expected)
      end

      it "leaves upcoming meeting with the same date" do
        subject4.update_all_future
        expect(meeting_schedule.reload.upcoming_meeting.date).to eq(start_date)
      end
    end

    context "when updating all dates including upcoming" do
      let(:old_date5) { Time.local(2017, 12, 20).beginning_of_day }
      let(:new_date5) { Time.local(2017, 12, 25).beginning_of_day }
      let(:subject5) { DateRescheduler.new(meeting_schedule: meeting_schedule, initial_date: old_date5, new_date: new_date5) }

      it "updates meeting with future date" do
        original_meeting = meeting_schedule.meetings.find_by(date: old_date5)
        subject5.update_all_future
        expect(original_meeting.reload.date).to eq(new_date5)
      end

      it "updates all future dates in the schedule" do
        expected = [
          Time.local(2017, 12, 25).beginning_of_day,
          Time.local(2018, 1, 8).beginning_of_day,
          Time.local(2018, 1, 22).beginning_of_day,
          Time.local(2018, 2, 5).beginning_of_day,
        ]
        subject5.update_all_future
        expect(meeting_schedule.reload.schedule.next_occurrences(4)).to match_array(expected)
      end

      it "updates dates for upcoming and next meeting" do
        subject5.update_all_future
        expect(meeting_schedule.reload.upcoming_meeting.date).to eq(new_date5)
        expect(meeting_schedule.reload.next_meeting.date).to eq(Time.local(2018, 1, 8).beginning_of_day)
      end
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
