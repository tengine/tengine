class Tengine::Test::SshesController < ApplicationController
  # GET /tengine/test/sshes
  # GET /tengine/test/sshes.json
  def index
    @sshes = Tengine::Test::Ssh.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sshes }
    end
  end

  # GET /tengine/test/sshes/1
  # GET /tengine/test/sshes/1.json
  def show
    @ssh = Tengine::Test::Ssh.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ssh }
    end
  end

  # GET /tengine/test/sshes/new
  # GET /tengine/test/sshes/new.json
  def new
    @ssh = Tengine::Test::Ssh.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ssh }
    end
  end

  # GET /tengine/test/sshes/1/edit
  def edit
    @ssh = Tengine::Test::Ssh.find(params[:id])
  end

  # POST /tengine/test/sshes
  # POST /tengine/test/sshes.json
  def create
    @ssh = Tengine::Test::Ssh.new(params[:ssh])

    respond_to do |format|
      if @ssh.save
        format.html { redirect_to @ssh, notice: successfully_created(@ssh) }
        format.json { render json: @ssh, status: :created, location: @ssh }
      else
        format.html { render action: "new" }
        format.json { render json: @ssh.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/test/sshes/1
  # PUT /tengine/test/sshes/1.json
  def update
    @ssh = Tengine::Test::Ssh.find(params[:id])

    respond_to do |format|
      if @ssh.update_attributes(params[:ssh])
        format.html { redirect_to @ssh, notice: successfully_updated(@ssh) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ssh.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/test/sshes/1
  # DELETE /tengine/test/sshes/1.json
  def destroy
    @ssh = Tengine::Test::Ssh.find(params[:id])
    @ssh.destroy

    respond_to do |format|
      format.html { redirect_to tengine_test_sshes_url, notice: successfully_destroyed(@ssh) }
      format.json { head :ok }
    end
  end
end
