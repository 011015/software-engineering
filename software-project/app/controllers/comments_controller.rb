class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :authenticate, only: [ :create, :destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /songs/:song_id/comments
  def create
    if is_empty(comment_params[:内容])
      render json: {"信息": "请填写内容！"}
    else
      @song = Song.find(params[:song_id])
      @comment = Comment.new(comment_params)
      @comment.manipulator = current_manipulatorid
      @comment.song = @song
      url = "/songs/" + @song.id.to_s
  
      if @comment.save
        render json: {"路径": url, "信息": "评论成功！"}
      else
        render json: {"路径": url, "信息": "评论失败！"}
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
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
