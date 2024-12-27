class NoticesController < ApplicationController
  before_action :set_notice, only: %i[ update destroy ]

  # PATCH/PUT /notices/1 or /notices/1.json
  def update
    id = "notice_" + @notice.id.to_s
    if @notice.update(notice_params)
      render json: {"路径": "/manipulators/personal_info"}
    else
      render json: {"信息": "错误！"}
    end
  end

  # DELETE /notices/1 or /notices/1.json
  def destroy
    id = "notice_" + @notice.id.to_s
    @notice.destroy
    render json: {"信息": "删除成功！", "路径": "/manipulators/personal_info"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @notice = Notice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notice_params
      params.require(:notice).permit(:read_by_receiver)
    end
end
