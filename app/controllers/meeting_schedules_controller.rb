class MeetingSchedulesController < ApplicationController
  before_action :authenticate_user!

  def create
    @organization = current_user.organization
    @team_member = @organization.team_members.find_by(id: params[:team_member_id])
    @meeting_schedule = @team_member.meeting_schedules.new(meeting_schedule_params.merge(team_member_id: @team_member.id))
    if @meeting_schedule.save
      render json: @meeting_schedule, status: :ok
    else
      render json: @meeting_schedule.errors, status: 422
    end
  end

  private

  def meeting_schedule_params
    schedule_params = params.require(:meeting_schedule).permit(:start_time, :every, :frequency, :day_of_week)
    schedule_params[:start_time] = Time.parse(schedule_params[:start_time]).in_time_zone(@organization.time_zone)
    schedule_params
  end
end
