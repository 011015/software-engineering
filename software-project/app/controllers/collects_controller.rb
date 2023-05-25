class CollectsController < ApplicationController
  before_action :set_collect, only: %i[ show edit update destroy ]
  before_action :authenticate, only: [ :create, :destroy ]

  # GET /collects or /collects.json
  def index
    @collects = Collect.all
  end

  # GET /collects/1 or /collects/1.json
  def show
  end

  # GET /collects/new
  def new
    @collect = Collect.new
  end

  # GET /collects/1/edit
  def edit
  end

  # POST /songs/:songs_id/collects
  def create
    @song = Song.find(params[:song_id])
    @collect = Collect.new()
    @collect.song = @song
    @collect.manipulator = current_manipulatorid
    url = "/songs/" + @song.id.to_s
    if @collect.save
      render json: {"路径": url, "信息": "收藏成功！"}
    else
      render json: {"路径": url, "信息": "收藏失败！"}
    end
  end

  # PATCH/PUT /collects/1 or /collects/1.json
  def update
    respond_to do |format|
      if @collect.update(collect_params)
        format.html { redirect_to collect_url(@collect), notice: "Collect was successfully updated." }
        format.json { render :show, status: :ok, location: @collect }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/:song_id/collects/1
  def destroy
    @song = Song.find(params[:song_id])
    @collect.destroy
    url = "/songs/" + @song.id.to_s
    render json: {"路径": url, "信息": "取消收藏成功！"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collect
      @collect = Collect.find(params[:id])
    end

    def authenticate
      render json: {"路径": "/manipulators/user_login", "信息": "请先登录！"}, status: :bad_request unless current_manipulatorid
      # redirect_to user_login_manipulators_url unless current_manipulatorid
    end
end
