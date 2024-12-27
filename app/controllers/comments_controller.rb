class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ destroy ]
  before_action :authenticate, only: [ :create, :destroy ]

  # POST /songs/1/comments or /songs/1/comments/1/comments
  def create
    if is_empty(comment_params[:内容])
      render json: {"信息": "请填写内容！"}
    else
      @song = Song.find(params[:song_id])
      @comment = Comment.new(comment_params)
      @comment.manipulator = current_manipulatorid
      if params[:comment_id]
        @parent_comment = Comment.find(params[:comment_id])
        @comment.parent_comment = @parent_comment
        @comment.save

        if @comment.manipulator.id != @parent_comment.manipulator.id
          # create notice
          @notice = Notice.new()
          @notice.receiver = @parent_comment.manipulator
          @notice.sender = @comment.manipulator.名称
          @notice.path = "/songs/#{@song.id}#comment-#{@comment.id}"
          @notice.内容 = @comment.内容

          # @notice.notifiable_obj = @comment
          # @notice.notifiable_obj_type = "Comment"
          # @notice.notifiable_obj_id = @comment.id
          @notice.notification_type = "回复"
          @notice.read_by_receiver = "未读"
          @notice.save

          message = @notice.sender + "回复了你的评论"
          ActionCable.server.broadcast("user_#{@notice.receiver.id}_channel", {msg: message})
        end

        url = "/songs/" + @song.id.to_s
        render json: {"路径": url, "信息": "评论成功！"}
      else
        @comment.song = @song
        url = "/songs/" + @song.id.to_s
  
        if @comment.save
          render json: {"路径": url, "信息": "评论成功！"}
        else
          render json: {"路径": url, "信息": "评论失败！"}
        end
      end
    end
  end

  # DELETE /songs/1/comments/1
  def destroy
    id = "comment_" + @comment.id.to_s
    @song = Song.find(params[:song_id])
    @comment.destroy
    url = "/songs/" + @song.id.to_s
    render json: {"信息": "删除成功！", "ID": id}
  end

  def is_empty(data)
    if data == "undefined" or data == nil or data == ""
      return true
    else
      return false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:内容)
    end

    def authenticate
      render json: {"路径": "/manipulators/user_login", "信息": "请先登录！"}, status: :bad_request unless current_manipulatorid
      # redirect_to user_login_manipulators_url unless current_manipulatorid
    end
end