class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :team_admin?

  private

    def team_authenticate!
      current_user && team_member?
    end

    def set_team
      @team = Team.find(params[:team_id]) 
    end

    def authenticate!
      redirect_to root_path unless current_user
    end

    def team_admin?
      @team.admin?(current_user)
    end

    def team_member?
      @team.member?(current_user)
    end

end
