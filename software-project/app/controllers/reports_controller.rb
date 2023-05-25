class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update destroy ]
  before_action :authenticate, only: [ :create, :update]
  before_action :authenticate_manager, only: [ :index ]

  # GET /reports or /reports.json
  def index
    # @reports = Report.all
    @reports = Report.where({"状态": "待审核"}).all
    respond_to do |format|
      format.html { render 'index', layout: 'manager' }
      format.json { render json: {"路径": "/reports"} }
    end
  end

  # GET /reports/1 or /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /songs/:song_id/comments/:comment_id/reports
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
    @report.comment = @comment
    @report.manipulator = @manipulator
    @report.状态 = "待审核"

    if @report.save
      render json: {"信息": "举报成功！"}
    else
      render json: {"信息": "举报失败！"}
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    if params[:report][:状态] == "已通过"
      @report.comment.destroy
    end
    @report.update({"状态": params[:report][:状态]})
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
