class ManipulatorsController < ApplicationController
  layout 'account', only: %i[ user_register user_login manager_login ]
  before_action :set_manipulator, only: %i[ show edit update destroy ]

  # GET /manipulators or /manipulators.json
  def index
    @manipulators = Manipulator.all
  end

  # GET /manipulators/1 or /manipulators/1.json
  def show
  end

  # GET /manipulators/new
  def new
    @manipulator = Manipulator.new
  end

  # GET /manipulators/1/edit
  def edit
  end

  # PATCH/PUT /manipulators/1 or /manipulators/1.json
  def update
    respond_to do |format|
      if @manipulator.update(manipulator_params)
        format.html { redirect_to manipulator_url(@manipulator), notice: "Manipulator was successfully updated." }
        format.json { render :show, status: :ok, location: @manipulator }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @manipulator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manipulators/1 or /manipulators/1.json
  def destroy
    @manipulator.destroy

    respond_to do |format|
      format.html { redirect_to manipulators_url, notice: "Manipulator was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /manipulators/do_register
  def do_register
    str = ""
    if params[:名称] == ""
      str += "名称未填写!\r\n"
    end
    if params[:密码] == ""
      str += "密码未填写!\r\n"
    end
    if params[:密码].length < 8 and params[:密码].length != 0
      str += "密码少于8个字符!\r\n"
    end
    if params[:性别] == nil
      str += "性别未填写!\r\n"
    end
    manipulator = Manipulator.where("名称": params[:名称]).first
    if params[:名称] != "" and manipulator
      str += "名称重复!\r\n"
    end

    if str == ""
      @manipulator = Manipulator.new({"名称": params[:名称], "密码": params[:密码], "类型": params[:类型], "性别": params[:性别]})
      @picture = Picture.new({"图片": "default.jpg"})
      @manipulator.头像 = @picture
      
      if @manipulator.save
        str += "注册成功！"
        url = ""
        if params[:类型] == "管理员"
          url = "/manipulators/manager_login"
        else
          url = "/manipulators/user_login"
        end
        render json: {"路径": url, "信息": str}, status: :created
      else
        render json: @picture.errors, status: :unprocessable_entity
      end

    else
      render json: {"信息": str}, status: :unprocessable_entity
    end
  end

  # GET /manipulators/user_register
  def user_register
  end

  # POST /manipulators/do_login
  def do_login
    str = ""
    if params[:名称] == ""
      str += "名称未填写!\r\n"
    end
    if params[:密码] == ""
      str += "密码未填写!\r\n"
    end
    if params[:密码].length < 8 and params[:密码].length != 0
      str += "密码少于8个字符!\r\n"
    end

    if str == ""
      manipulator = Manipulator.where("名称": params[:名称], "密码": params[:密码]).first
      if manipulator
        session[:current_manipulatorid] = manipulator.id
        session[:current_manipulatortype] = manipulator.类型
        str += "登录成功！"
        url = ""
        if params[:类型] == "管理员"
          url = "/manipulators/manager_login"
        else
          url = "/manipulators/user_login"
        end
        render json: {"路径": url, "信息": str}
      else
        str += "密码或用户名错误！"
        render json: {"信息": str}, status: :bad_request
      end
    else
      render json: {"信息": str}, status: :bad_request
    end
  end

  # GET /manipulators/user_login
  def user_login
  end

  # GET /manipulators/manager_login
  def manager_login
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manipulator
      @manipulator = Manipulator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def manipulator_params
      params.require(:manipulator).permit(:名称, :密码, :性别)
    end
end
