class CollectsController < ApplicationController
  before_action :set_collect, only: %i[ destroy delete ]
  before_action :authenticate, only: [ :create, :destroy ]

  # POST /songs/1/collects
  def create
    @song = Song.find(params[:song_id])
    @collect = Collect.new()
    @collect.song = @song
    @collect.manipulator = current_manipulatorid
    url = "/songs/" + @song.id.to_s

    if @collect.manipulator.id != @collect.song.manipulator.id
      # create notice
      @notice = Notice.new()
      @notice.receiver = @song.manipulator
      @notice.sender = @collect.manipulator.名称
      @notice.path = "/songs/#{@collect.song.id}"
      @notice.内容 = @collect.song.名称
      # @notice.notifiable_obj = @collect.manipulator.名称
      # @notice.notifiable_obj_type = "Collect"
      # @notice.notifiable_obj_id = @collect.id

      @notice.notification_type = "收藏"
      @notice.read_by_receiver = "未读"
      message = @notice.sender + "收藏了你的曲谱"

      @notice.save
      ActionCable.server.broadcast("user_#{@notice.receiver.id}_channel", {msg: message})
    end
    
    if @collect.save
      render json: {"路径": url, "信息": "收藏成功！"}
    else
      render json: {"路径": url, "信息": "收藏失败！"}
    end
  end

  # DELETE /songs/1/collects/1
  def destroy
    @song = Song.find(params[:song_id])
    @collect.destroy
    url = "/songs/" + @song.id.to_s
    render json: {"路径": url, "信息": "取消收藏成功！"}
  end

  # DELETE /collects/1
  def delete
    id = "collect_" + @collect.id.to_s
    @collect.destroy
    render json: {"路径": "/manipulators/personal_info"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collect
      @collect = Collect.find(params[:id])
    end

    def authenticate
      render json: {"路径": "/manipulators/user_login", "信息": "请先登录用户账号！"}, status: :bad_request if !current_manipulatorid or current_manipulatortype != "用户"
      # redirect_to user_login_manipulators_url unless current_manipulatorid
    end
end
