class EventsController < ApplicationController

  before_action :set_team, only: [:index]
  before_action :team_authenticate!

  # GET /events
  # GET /events.json
  def index
    @projects = current_user.projects.where(team_id: @team.id)
    @events = Event.includes(:project).where(project_id: @projects.map(&:id))
    @events = @events.where("id < ?", params[:till_id]) if params[:till_id]
    @events = @events.order("id DESC").paginate(page: 1, :per_page => 50) 
    respond_to do |format|
      format.html
      format.js
    end
  end
    
end
