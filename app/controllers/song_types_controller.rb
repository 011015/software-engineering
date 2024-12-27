class SongTypesController < ApplicationController
  before_action :set_song_type, only: %i[ destroy ]
  before_action :authenticate, only: [ :new, :destroy ]

  # GET /song_types or /song_types.json
  def index
    @collect_sort = params[:收藏数] if params[:收藏数].present?
    @created_sort = params[:发布时间] if params[:发布时间].present?

    if @collect_sort.present? && @created_sort.present?
      order_sql = "song_types.id, collect_count #{@collect_sort}, song_created #{@created_sort}"
    elsif @collect_sort.present?
      order_sql = "song_types.id, collect_count #{@collect_sort}"
    elsif @created_sort.present?
      order_sql = "song_types.id, song_created #{@created_sort}"
    else
      order_sql = "song_types.id"
    end

    if params[:song_type_ids].present?
      @song_type_ids = params[:song_type_ids]

      song_records = Song.left_joins(:collects)
      .select("songs.id AS song_id, songs.created_at AS song_created, COUNT(collects.id) AS collect_count")
      .group("songs.id")
      .to_sql

      song_type_records = SongType.left_joins(:relationships)
      .joins("LEFT JOIN (#{song_records}) AS song_collects ON relationships.song_id = song_collects.song_id")
      .select("song_types.id, song_types.名称, song_collects.*")
      .where("song_types.id IN (?)", @song_type_ids)    # 替换为要查询的SongType的ID数组
      .order(order_sql)

      @song_types = []
      song_type = nil
      song_type_records.each do |record|
        if song_type == nil              # 新的一个曲谱类型
          song_type = SongType.new({"id": record.id, "名称": record.名称})
          song_type.songs = []
          if record.song_id
            song = Song.find(record.song_id)
            song_type.songs << song
          end
        elsif record.id != song_type.id  # 新的一个曲谱类型
          @song_types << song_type
          song_type = SongType.new({"id": record.id, "名称": record.名称})
          song_type.songs = []
          if record.song_id
            song = Song.find(record.song_id)
            song_type.songs << song
          end
        else
          if record.song_id
            song = Song.find(record.song_id)
            song_type.songs << song
          end
        end
      end
      if song_type != nil
        @song_types << song_type
      end
      render 'index', layout: 'main'
    else
      @song_type_ids = SongType.pluck(:id)
      @song_types = SongType.all
      render 'index', layout: 'main'
    end
  end

  # GET /song_types/new
  def new
    @song_type = SongType.new
    respond_to do |format|
      format.html { render 'new', layout: 'account' }
      format.json { render json: {"路径": "/song_types/new"} }
    end
  end

  # POST /song_types or /song_types.json
  def create
    if song_type_params[:名称].length > 0 and song_type_params[:名称].length <= 20
      name = SongType.where("名称": song_type_params[:名称]).first
      if name
        render json: {"信息": "名称重复！"}
      else
        @song_type = SongType.new(song_type_params)
        respond_to do |format|
          if @song_type.save
            format.json { render json: {"路径": "/song_types", "信息": "创建成功！"} }
          else
            format.json { render json: {"信息": "创建失败！"} }
          end
        end
      end
    else
      render json: {"信息": "名称需介于1~20字符之间！"}
    end
  end

  # DELETE /song_types/1 or /song_types/1.json
  def destroy
    id = "song_type_" + @song_type.id.to_s
    @song_type.destroy
    render json: {"路径": "/song_types", "信息": "删除成功！"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song_type
      @song_type = SongType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def song_type_params
      params.require(:song_type).permit(:名称)
    end

    def authenticate
      render json: {"路径": "/manipulators/user_login", "信息": "请先登录！"}, status: :bad_request unless current_manipulatorid
      # redirect_to user_login_manipulators_url unless current_manipulatorid
    end
end
