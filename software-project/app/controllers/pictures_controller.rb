class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show edit update destroy ]
  before_action :set_song, only: %i[ create destroy ]

  # GET /pictures or /pictures.json
  def index
    @pictures = Picture.all
  end

  # GET /pictures/1 or /pictures/1.json
  def show
  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures or /pictures.json
  def create
    path = "/songs/" + params[:song_id]
    if params[:picture][:图片].all?(&:blank?)
      respond_to do |format|
        format.json { render json: {"路径": path, "信息": "必须上传图片！"}, status: :bad_request }
      end
    else
      flag = true
      params[:picture][:图片].each_with_index do |uploaded_io, index|
        if !uploaded_io.blank?
          suffix = File.extname(uploaded_io.original_filename)
          filename = Time.now.to_i.to_s + "_" + index.to_s + suffix
          if suffix == '.jpg' or suffix == '.jpeg' or suffix == '.png'
            @picture = Picture.new({"图片": filename})
            @picture.song = @song
            File.open(Rails.root.join('app/assets/images', filename), 'wb') do |file|
              file.write(uploaded_io.read)
            end
            if @picture.save
            else
              flag = false
              break
            end
          else
            flag = false
          end
        end
      end
      respond_to do |format|
        if flag
          format.json { render json: {"路径": path, "信息": "上传成功！"} }
        else
          format.json { render json: {"路径": path, "信息": "图片必须为 .jpg 或 .jpeg 或 .png 格式！"}, status: :bad_request }
        end
      end
    end
  end

  # PATCH/PUT /pictures/1 or /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to picture_url(@picture), notice: "Picture was successfully updated." }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1 or /pictures/1.json
  def destroy
    id = "picture_" + @picture.id.to_s
    path = "/songs/" + params[:song_id]
    filename = @picture.图片
    File.delete("#{Rails.root}/app/assets/images/#{filename}")
    @picture.destroy

    respond_to do |format|
      format.json { render json: {"路径": path, "信息": "删除成功！", "id": id} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    def set_song
      @song = Song.find(params[:song_id])
    end

    # Only allow a list of trusted parameters through.
    def picture_params
      params.require(:picture).permit(:图片)
    end
end
