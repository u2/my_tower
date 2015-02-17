class TeamController < ApplicationController

  helper_method :team_admin?

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def team_admin?
    @team.admin?(current_user)
  end

end