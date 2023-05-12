class SongsController < ApplicationController
  layout 'account', only: [:new, :edit]
  before_action :set_song, only: %i[ show edit update destroy ]

  # GET /songs or /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1 or /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
    @button_text = "创建"
  end

  # GET /songs/1/edit
  def edit
    @button_text = "修改"
    @path = request.referer
  end

  # POST /songs or /songs.json
  def create
    if !song_params[:演唱].blank? and !song_params[:作词].blank? and 
      !song_params[:作曲].blank? and !song_params[:名称].blank?
      @song = Song.new(song_params)
      @song.manipulator = current_manipulatorid
      respond_to do |format|
        if @song.save
          format.json { render json: {"路径": "/songs", "信息": "创建成功！\r\n"}, status: :created }
        else
          format.json { render json: {"路径": "/songs", "信息": @song.errors}, status: :unprocessable_entity }
        end
      end
    else
      render json: {"路径": "/songs", "信息": "请填写完整！\r\n"}, status: :bad_request
    end
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    if !song_params[:演唱].blank? and !song_params[:作词].blank? and 
      !song_params[:作曲].blank? and !song_params[:名称].blank?
      respond_to do |format|
        if @song.update(song_params)
          format.json { render json: {"路径": params[:path], "信息": "修改成功！\r\n"} }
        else
          format.json { render json: {"路径": "/songs", "信息": @song.errors}, status: :unprocessable_entity }
        end
      end
    else
      render json: {"信息": "请填写完整！\r\n"}, status: :bad_request
    end
  end

  # DELETE /songs/1 or /songs/1.json
  def destroy
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url, notice: "Song was successfully destroyed." }
      format.json { head :no_content }
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
end
