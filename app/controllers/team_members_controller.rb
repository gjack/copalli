class TeamMembersController < ApplicationController
  before_action :authenticate_user!
  def new
    @organization = current_user.organization
    @team = @organization.teams.find_by(id: params[:team_id])
    @available_people = @organization.users.where.not(id: @team.team_members.pluck(:user_id))
    @team_member = TeamMember.new
  end

  def create
    @organization = current_user.organization
    @team = @organization.teams.find_by(id: params[:team_id])
    @team_member = @team.team_members.new(team_member_params.merge(organization_id: @organization.id))
    if @team_member.save
      redirect_to @team, notice: "Your team member was successfully saved!"
    else
      render :new
    end
  end

  private

  def team_member_params
    params.require(:team_member).permit(:email, :first_name, :last_name, :role, :user_id, :team_id)
  end
end
