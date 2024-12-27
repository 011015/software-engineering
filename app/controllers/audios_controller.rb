class AudiosController < ApplicationController
  before_action :set_audio, only: %i[ destroy ]

  # POST /songs/:song_id/audios
  def create
    path = "/songs/" + params[:song_id]
    if params.key?(:audio)
      uploaded_io = audio_params[:音频]
      suffix = File.extname(uploaded_io.original_filename)
      filename = "uploads/audio/" + Time.now.to_i.to_s + "_0" + suffix
      if suffix == '.mp3' or suffix == '.wav'
        @audio = Audio.new({"音频": filename, "属性": params[:属性]})
        @audio.song = Song.find(params[:song_id])
        File.open(Rails.root.join('app/assets/images', filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        if @audio.save
          render json: {"路径": path, "信息": "上传成功！"}
        else
          render json: {"路径": path, "信息": "上传失败！"}
        end
      else
          render json: {"信息": "必须为 .mp3 或 .wav 格式！"}
      end
    else
      render json: {"信息": "未上传音频！"}
    end
  end

  # DELETE /songs/1/audios/1
  def destroy
    id = "audio_" + @audio.id.to_s
    url = "/songs/" + params[:song_id]
    filename = @audio.音频
    File.delete("#{Rails.root}/app/assets/images/#{filename}")
    @audio.destroy
    render json: {"路径": url, "信息": "删除成功！"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio
      @audio = Audio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def audio_params
      params.require(:audio).permit(:音频)
    end
end
