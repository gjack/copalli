class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @organization = current_user.organization
    @teams = @organization.teams
  end

  def show
    @organization = current_user.organization
    team = @organization.teams.find_by(id: params[:id])
    @team = Teams::TeamSerializer.new(team)
  end

  def new
    @organization = current_user.organization
    @team = @organization.teams.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @team = Team.new(team_params)
    if @team.save!
      redirect_to teams_path, notice: "Your team was successully created!"
    else
      render :new
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :organization_id)
  end
end
