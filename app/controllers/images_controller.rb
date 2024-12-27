class ImagesController < ApplicationController
  before_action :set_image, only: %i[ destroy ]
  before_action :set_song, only: %i[ create destroy ]
  before_action :authenticate, only: [ :create, :destroy ]

  # POST /images or /images.json
  def create
    path = "/songs/" + params[:song_id]
    if params[:image][:图片].all?(&:blank?)
      render json: {"信息": "未上传图片！"}
    else
      flag = true
      params[:image][:图片].each_with_index do |uploaded_io, index|
        if !uploaded_io.blank?
          suffix = File.extname(uploaded_io.original_filename)
          filename = "uploads/image/" + Time.now.to_i.to_s + "_" + index.to_s + suffix
          if suffix == '.jpg' or suffix == '.jpeg' or suffix == '.png'
            @image = Image.new({"图片": filename, "属性": params[:属性]})
            @image.song = @song
            File.open(Rails.root.join('app/assets/images', filename), 'wb') do |file|
              file.write(uploaded_io.read)
            end
            if @image.save
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
          format.json { render json: {"路径": path, "信息": "必须为 .jpg 或 .jpeg 或 .png 格式！"} }
        end
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    id = "image_" + @image.id.to_s
    url = "/songs/" + params[:song_id]
    filename = @image.图片
    File.delete("#{Rails.root}/app/assets/images/#{filename}")
    @image.destroy
    render json: {"信息": "删除成功！", "ID": id}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    def set_song
      @song = Song.find(params[:song_id])
    end

    # Only allow a list of trusted parameters through.
    def image_params
      params.require(:image).permit(:图片, :song_id)
    end

    def authenticate
      render json: {"路径": "/manipulators/user_login", "信息": "请先登录！"}, status: :bad_request unless current_manipulatorid
      # redirect_to user_login_manipulators_url unless current_manipulatorid
    end
end
