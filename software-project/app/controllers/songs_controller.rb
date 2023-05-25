class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]
  before_action :authenticate, only: [ :new, :edit, :destroy ]

  # GET /songs or /songs.json
  def index
    @songs = Song.all
    render 'index', layout: 'main'
  end

  # GET /songs/1 or /songs/1.json
  def show
    @collect = nil
    if current_manipulatorid
      @collect = Collect.where({"song_id": @song.id, "manipulator_id": current_manipulatorid}).first
    end
    render 'show', layout: 'main'
  end

  # GET /songs/new
  def new
    @song = Song.new
    @button_text = "创建"
    respond_to do |format|
      format.html { render 'new', layout: 'account' }
      format.json { render json: {"路径": "/songs/new"} }
    end
  end

  # GET /songs/1/edit
  def edit
    @button_text = "修改"
    @path = request.referer
    url = "/songs/" + @song.id.to_s + "/edit"
    respond_to do |format|
      format.html { render 'edit', layout: 'account' }
      format.json { render json: {"路径": url} }
    end
  end

  # POST /songs or /songs.json
  def create
    if !song_params[:演唱].blank? and !song_params[:作词].blank? and 
      !song_params[:作曲].blank? and !song_params[:名称].blank?
      @song = Song.new(song_params)
      @song.manipulator = current_manipulatorid
      respond_to do |format|
        if @song.save
          format.json { render json: {"路径": "/songs", "信息": "创建成功！"} }
        else
          format.json { render json: {"信息": "创建失败！"} }
        end
      end
    else
      render json: {"信息": "请填写完整！"}
    end
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    if !song_params[:演唱].blank? and !song_params[:作词].blank? and 
      !song_params[:作曲].blank? and !song_params[:名称].blank?
      respond_to do |format|
        if @song.update(song_params)
          format.json { render json: {"路径": params[:path], "信息": "修改成功！"} }
        else
          format.json { render json: {"信息": "修改失败！"} }
        end
      end
    else
      render json: {"信息": "请填写完整！"}
    end
  end

  # DELETE /songs/1 or /songs/1.json
  def destroy
    id = "song_" + @song.id.to_s
    @song.pictures.each do |picture|
      filename = picture.图片
      File.delete("#{Rails.root}/app/assets/images/#{filename}")
    end
    @song.destroy
    if params[:song].present? and params[:song][:ID].present?
      render json: {"信息": "删除成功！", "ID": id}
    else
      render json: {"路径": "/songs", "信息": "删除成功！"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.require(:song).permit(:演唱, :作词, :作曲, :名称, song_type_ids: [])
    end

    def authenticate
      render json: {"路径": "/manipulators/user_login", "信息": "请先登录！"}, status: :bad_request unless current_manipulatorid
      # redirect_to user_login_manipulators_url unless current_manipulatorid
    end
end
