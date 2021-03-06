class AccessesController < TeamController
  
  before_action :set_access, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :index, :create]
  before_action :team_authenticate!

  # GET /accesses
  # GET /accesses.json
  def index
    @accesses = @team.accesses
  end

  # GET /accesses/1
  # GET /accesses/1.json
  def show
  end

  # GET /accesses/new
  def new
    @access = Access.new(project_id: params[:project_id])
  end

  # GET /accesses/1/edit
  def edit
  end

  # POST /accesses
  # POST /accesses.json
  def create
    @access = Access.new(access_params)
    @project = @access.project
    respond_to do |format|
      if @access.save
        format.html { redirect_to project_path(@project), notice: 'Access was successfully created.' }
        format.json { render :show, status: :created, location: @access }
      else
        format.html { render :new }
        format.json { render json: @access.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accesses/1
  # PATCH/PUT /accesses/1.json
  def update
    respond_to do |format|
      if @access.update(access_params)
        format.html { redirect_to project_path(@project), notice: 'Access was successfully updated.' }
        format.json { render :show, status: :ok, location: @access }
      else
        format.html { render :edit }
        format.json { render json: @access.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accesses/1
  # DELETE /accesses/1.json
  def destroy
    @access.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Access was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access
      @access = Access.find(params[:id])
      @project = @access.project
      @team = @project.team
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_params
      params.require(:access).permit(:user_id, :project_id, :team_id, :role)
    end
end
