class ReschedulePreviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @organization = current_user.organization
    @meeting_schedule = MeetingSchedule.find_by(id: params[:meeting_schedule_id])
    initial_date = Time.parse(params[:initial_date]).beginning_of_day.in_time_zone("UTC")
    new_date = Time.parse(params[:new_date]).beginning_of_day.in_time_zone("UTC")

    rescheduler = DateRescheduler.new({
      meeting_schedule: @meeting_schedule,
      initial_date: initial_date,
      new_date: new_date
      })

    render json: {
      scope_single: rescheduler.preview_single_formatted,
      scope_future: rescheduler.preview_all_future_formatted
    }, status: 200
  end
end
