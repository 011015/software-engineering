class SongTypesController < ApplicationController
  layout 'account', only: [:new]
  before_action :set_song_type, only: %i[ show edit update destroy ]

  # GET /song_types or /song_types.json
  def index
    @song_types = SongType.all
  end

  # GET /song_types/1 or /song_types/1.json
  def show
  end

  # GET /song_types/new
  def new
    @song_type = SongType.new
  end

  # GET /song_types/1/edit
  def edit
  end

  # POST /song_types or /song_types.json
  def create
    if song_type_params[:名称] != ""
      name = SongType.where("名称": song_type_params[:名称]).first
      if name
        render json: {"路径": "/song_types", "信息": "名称重复!\r\n"}, status: :bad_request
      else
        @song_type = SongType.new(song_type_params)
        respond_to do |format|
          if @song_type.save
            format.json { render json: {"路径": "/song_types", "信息": "创建成功！\r\n"}, status: :created }
          else
            format.json { render json: {"路径": "/song_types", "信息": "创建失败！\r\n"}, status: :unprocessable_entity }
          end
        end
      end
    else
      render json: {"路径": "/song_types", "信息": "名称未填写！\r\n"}, status: :bad_request
    end
  end

  # PATCH/PUT /song_types/1 or /song_types/1.json
  def update
    respond_to do |format|
      if @song_type.update(song_type_params)
        format.html { redirect_to song_type_url(@song_type), notice: "Song type was successfully updated." }
        format.json { render :show, status: :ok, location: @song_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @song_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /song_types/1 or /song_types/1.json
  def destroy
    id = "song_type_" + @song_type.id.to_s
    if @song_type.destroy
      render json: {"信息": "删除成功！", "id": id}
    else
      render json: {"信息": "删除失败！"}
    end
    # format.html { redirect_to song_types_url, notice: "Song type was successfully destroyed." }
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
end
