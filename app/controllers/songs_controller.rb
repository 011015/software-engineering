class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]
  before_action :authenticate, only: [ :new, :edit, :destroy ]

  # GET /songs or /songs.json
  def index
    @text = params[:文本] if params[:文本].present?
    @collect_sort = params[:收藏数] if params[:收藏数].present?
    @created_sort = params[:发布时间] if params[:发布时间].present?
    if @collect_sort.present? && @created_sort.present?
      order_sql = "COUNT(collects.id) #{@collect_sort}, songs.created_at #{@created_sort}"
    elsif @collect_sort.present?
      order_sql = "COUNT(collects.id) #{@collect_sort}"
    elsif @created_sort.present?
      order_sql = "songs.created_at #{@created_sort}"
    else
      order_sql = "songs.created_at DESC"
    end
    if @text.present?
      @songs = Song.left_joins(:manipulator)
      .select("songs.*, manipulators.名称 AS manipulator_名称")
      .joins("LEFT JOIN collects ON collects.song_id = songs.id")
      .where("manipulator_名称 LIKE ? OR songs.名称 LIKE ? OR songs.演唱 LIKE ? OR songs.作词 LIKE ? OR songs.作曲 LIKE ?", "%#{@text}%", "%#{@text}%", "%#{@text}%", "%#{@text}%", "%#{@text}%")
      .group("songs.id")
      .order(order_sql)
    else
      @songs = Song.left_joins(:manipulator)
      .select("songs.*, manipulators.名称 AS manipulator_名称")
      .joins("LEFT JOIN collects ON collects.song_id = songs.id")
      .group("songs.id")
      .order(order_sql)
    end
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
    str = ""
    if check_length(song_params[:演唱]) and check_length(song_params[:作词]) and
      check_length(song_params[:作曲]) and check_length(song_params[:名称]) and song_params[:song_type_ids].length > 1
      @song = Song.new(song_params)
      @song.manipulator = current_manipulatorid

      if !is_empty(params[:封面])
        uploaded_io = params[:封面]
        suffix = File.extname(uploaded_io.original_filename)
        filename = "uploads/song/" + Time.now.to_i.to_s + "_0" + suffix
        if suffix == '.jpg' or suffix == '.jpeg' or suffix == '.png'
          @picture = Picture.new({"图片": filename})
          @song.封面 = @picture
          File.open(Rails.root.join('app/assets/images', filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          @picture.save
        else
          str += "图片必须为 .jpg 或 .jpeg 或 .png 格式！\r\n"
          @picture = Picture.new({"图片": "song/icon3.png"})
          @song.封面 = @picture
          @picture.save
        end
      else
        @picture = Picture.new({"图片": "song/icon3.png"})
        @song.封面 = @picture
        @picture.save
      end

      respond_to do |format|
        if @song.save
          str += "创建成功！"
          format.json { render json: {"路径": "/songs", "信息": str} }
        else
          str += "创建成功！"
          format.json { render json: {"信息": str} }
        end
      end
    else
      render json: {"信息": "请填写完整，字符需介于1~20之间！"}
    end
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    if check_length(song_params[:演唱]) and check_length(song_params[:作词]) and
      check_length(song_params[:作曲]) and check_length(song_params[:名称]) and song_params[:song_type_ids].length > 1

      str = ""
      if !is_empty(params[:封面])
        uploaded_io = params[:封面]
        suffix = File.extname(uploaded_io.original_filename)
        filename = "uploads/song/" + Time.now.to_i.to_s + "_0" + suffix
        if suffix == '.jpg' or suffix == '.jpeg' or suffix == '.png'
          if @song.封面.图片 != 'song/icon3.png'
            File.delete("#{Rails.root}/app/assets/images/#{@song.封面.图片}")
          end
          File.open(Rails.root.join('app/assets/images', filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          @song.封面.update({"图片": filename})
          str += "封面修改成功！\r\n"
        else
          str += "图片必须为 .jpg 或 .jpeg 或 .png 格式！\r\n"
        end
      end

      respond_to do |format|
        if @song.update(song_params)
          str += "信息修改成功！"
          format.json { render json: {"路径": params[:path], "信息": str} }
        else
          format.json { render json: {"信息": "修改失败！"} }
        end
      end
    else
      puts song_params[:名称].length
      puts song_params[:作词].length
      puts song_params[:作曲].length
      puts song_params[:演唱].length
      render json: {"信息": "请填写完整，字符需介于1~20之间！"}
    end
  end

  # DELETE /songs/1 or /songs/1.json
  def destroy
    id = "song_" + @song.id.to_s
    if @song.封面.图片 != 'song/icon3.png'
      File.delete("#{Rails.root}/app/assets/images/#{@song.封面.图片}")
    end
    @song.images.each do |image|
      filename = image.图片
      File.delete("#{Rails.root}/app/assets/images/#{filename}")
    end
    @song.destroy
    if params[:song].present? and params[:song][:ID].present?
      render json: {"信息": "删除成功！", "ID": id}
    else
      render json: {"路径": "/songs", "信息": "删除成功！"}
    end
  end

  def is_empty(data)
    if data == "undefined" or data == nil or data == ""
      return true
    else
      return false
    end
  end

  def check_length(data)
    if data.length > 0 and data.length <= 20
      return true
    else
      return false
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
