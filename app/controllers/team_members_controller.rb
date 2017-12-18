class TeamMembersController < ApplicationController
  before_action :authenticate_user!
  def new
    @organization = current_user.organization
    @team = @organization.teams.find_by(id: params[:team_id])
    @available_people = @organization.users.where.not(id: @team.team_members.pluck(:user_id))
    @team_member = TeamMember.new
  end

  def create
    Rails.logger.info(params)
  end
end
