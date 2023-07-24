class SongTypesController < ApplicationController
  before_action :set_song_type, only: %i[ show edit update destroy ]
  before_action :authenticate, only: [ :new, :destroy ]

  # GET /song_types or /song_types.json
  def index
    @song_types = SongType.all
    render 'index', layout: 'main'
  end

  # GET /song_types/1 or /song_types/1.json
  def show
  end

  # GET /song_types/new
  def new
    @song_type = SongType.new
    respond_to do |format|
      format.html { render 'new', layout: 'account' }
      format.json { render json: {"路径": "/song_types/new"} }
    end
  end

  # GET /song_types/1/edit
  def edit
  end

  # POST /song_types or /song_types.json
  def create
    if song_type_params[:名称] != ""
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
      render json: {"信息": "名称未填写！"}
    end
  end

  # DELETE /song_types/1 or /song_types/1.json
  def destroy
    id = "song_type_" + @song_type.id.to_s
    @song_type.destroy
    render json: {"信息": "删除成功！", "ID": id}
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
