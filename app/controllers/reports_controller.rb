class ReportsController < ApplicationController
  before_action :set_report, only: %i[ update ]
  before_action :authenticate, only: [ :create, :update ]
  before_action :authenticate_manager, only: [ :index ]

  # GET /reports or /reports.json
  def index
    # @reports = Report.all
    @text = params[:文本] if params[:文本].present?
    @state = params[:状态] if params[:状态].present?
    @reports = Report.joins(:manipulator)
    if @text.present? and @state.present? and @state != "所有"
      @reports = @reports.where("manipulators.名称 = ? and reports.状态 = ?", @text, @state)
    elsif @text.present?
      @reports = @reports.where("manipulators.名称 = ?", @text)
    elsif @state.present? and @state != "所有"
      @reports = @reports.where("reports.状态 = ?", @state)
    elsif @state != "所有"
      @state = "待审核"
      @reports = @reports.where("reports.状态 = ?", @state)
    end
    respond_to do |format|
      format.html { render 'index', layout: 'manager' }
      format.json { render json: {"路径": "/reports"} }
    end
  end

  # POST /songs/1/comments/1/reports
  def create
    @manipulator = current_manipulatorid
    @song = Song.find(params[:song_id])
    @comment = Comment.find(params[:comment_id])
    url = "/songs/" + @song.id.to_s
    if @manipulator == @comment.manipulator
      render json: {"信息": "不能举报自己的评论！"}
      return
    end
    @report = Report.new(report_params)
    @report.song = @song
    @report.comment = @comment
    @report.manipulator = @manipulator
    @report.状态 = "待审核"

    # create notice
    @notice = Notice.new()
    @notice.receiver = @report.comment.manipulator

    @notice.sender = @report.manipulator.名称
    @notice.path = "/songs/#{@song.id}#comment-#{@comment.id}"
    @notice.内容 = @report.内容

    # @notice.notifiable_obj = @report
    # @notice.notifiable_obj_type = "Report"
    # @notice.notifiable_obj_id = @report.id
    @notice.notification_type = "举报"
    @notice.read_by_receiver = "未读"

    if @notice.save and @report.save
      message = @notice.sender + "举报了你的评论"
      ActionCable.server.broadcast("user_#{@notice.receiver.id}_channel", {msg: message})
      render json: {"信息": "举报成功！"}
    else
      render json: {"信息": "举报失败！"}
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    @report.update({"状态": params[:report][:状态]})

    # create notice 举报者
    @notice1 = Notice.new()
    @notice1.receiver = @report.manipulator

    @notice1.sender = "管理员"
    @notice1.内容 = @report.内容

    # @notice1.notifiable_obj = @report
    # @notice1.notifiable_obj_type = "Report"
    # @notice1.notifiable_obj_id = @report.id
    @notice1.read_by_receiver = "未读"

    if params[:report][:状态] == "已通过"
      @notice1.notification_type = "通过"
      @notice1.path = "#"

      @report.update(message: @report.comment.内容)
      @report.comment.destroy

      # @report.comment.update(parent_comment: nil, song: nil)
      # @report.comment.child_comments.each do |child_comment|
      #   child_comment.destroy
      # end
      # @report.comment.reports.each do |report|
      #   if report.状态 == '待审核'
      #     report.destroy
      #   end
      # end

      # create notice 被举报者
      @notice2 = Notice.new()
      @notice2.receiver = @report.comment.manipulator

      @notice2.sender = "管理员"
      @notice2.path = "#"
      @notice2.内容 = @report.comment.内容

      # @notice2.notifiable_obj = @comment
      # @notice2.notifiable_obj_type = "Comment"
      # @notice2.notifiable_obj_id = @comment.id
      @notice2.read_by_receiver = "未读"
      @notice2.notification_type = "删除"
      @notice2.save
      message2 = @notice2.sender + "删除了你的评论"
      ActionCable.server.broadcast("user_#{@notice2.receiver.id}_channel", {msg: message2})
    else
      @notice1.notification_type = "驳回"
      @notice1.path = "/songs/#{@report.song.id}#comment-#{@report.comment.id}"
    end
    @notice1.save
    message1 = @notice1.sender + @notice1.notification_type + "了你的举报"
    ActionCable.server.broadcast("user_#{@notice1.receiver.id}_channel", {msg: message1})
    render json: {"路径": "/reports", "信息": "提交成功！"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:内容)
    end

    def authenticate
      render json: {"路径": "/manipulators/user_login", "信息": "请先登录！"}, status: :bad_request unless current_manipulatorid
      # redirect_to user_login_manipulators_url unless current_manipulatorid
    end

    def authenticate_manager
      if !current_manipulatorid or current_manipulatortype != "管理员"
        respond_to do |format|
          format.html { redirect_to manager_login_manipulators_url }
          format.json { render json: {"路径": "/manipulators/manager_login", "信息": "请先登录管理员账号！"}, status: :bad_request }
        end
      end
    end
end
