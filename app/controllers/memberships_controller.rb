class MembershipsController < TeamController

  before_action :set_team
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = @team.memberships
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new(team_id: @team.id)
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @team = @membership.team
    respond_to do |format|
      if @membership.save
        format.html { redirect_to team_membership_path(@team, @membership), notice: 'Membership was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to team_membership_path(@team, @membership), notice: 'Membership was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to team_memberships_url(@team), notice: 'Membership was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params[:membership][:team_id] = @team.id if params[:membership]
      params.require(:membership).permit(:user_id, :role, :team_id)
    end
end
