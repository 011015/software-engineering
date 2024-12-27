class ManipulatorsController < ApplicationController
  before_action :set_manipulator, only: %i[ update destroy ]
  before_action :authenticate_user, only: [ :personal_info, :delete_avatar, :update ]
  before_action :authenticate_manager, only: [ :index ]

  # GET /manipulators or /manipulators.json
  def index
    conditions = {}
    conditions["名称"] = params[:文本] if params[:文本].present?
    conditions["类型"] = params[:类型] if params[:类型].present?
    conditions["性别"] = params[:性别] if params[:性别].present?
    @text = conditions["名称"]
    @type = conditions["类型"]
    @sex = conditions["性别"]

    @manipulators = Manipulator.where(conditions)
    respond_to do |format|
      format.html { render 'index', layout: 'manager' }
      format.json { render json: {"路径": "/manipulators"} }
    end
  end

  # PATCH/PUT /manipulators/1 or /manipulators/1.json
  def update
    str = ""

    # 修改头像
    if !is_empty(params[:头像])
      uploaded_io = params[:头像]
      suffix = File.extname(uploaded_io.original_filename)
      filename = "uploads/account/" + Time.now.to_i.to_s + "_0" + suffix
      if suffix == '.jpg' or suffix == '.jpeg' or suffix == '.png'
        if @manipulator.头像.图片 != 'default.jpg'
          File.delete("#{Rails.root}/app/assets/images/#{@manipulator.头像.图片}")
        end
        File.open(Rails.root.join('app/assets/images', filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        @manipulator.头像.update({"图片": filename})
        str += "头像修改成功！\r\n"
      else
        str += "图片必须为 .jpg 或 .jpeg 或 .png 格式！\r\n"
      end
    end

    # 修改名称
    if !check_length(manipulator_params[:名称])
      str += "名称需介于1~20字符之间！\r\n"
    elsif manipulator_params[:名称] != @manipulator.名称
      manipulator = Manipulator.where("名称": manipulator_params[:名称]).first
      if manipulator
        str += "名称已被使用！\r\n"
      else
        str += "名称修改成功！\r\n"
        @manipulator.update({"名称": manipulator_params[:名称]})
      end
    end

    # 修改密码
    if !check_pwd_length(manipulator_params[:密码])
      str += "新密码需介于8~20字符之间！\r\n"
    else
      if !check_pwd_length((params[:原密码]))
        str += "原密码需介于8~20字符之间！\r\n"
      else
        manipulator = Manipulator.where({"名称": manipulator_params[:名称], "密码": params[:原密码]}).first
        if !manipulator
          str += "原密码错误！\r\n"
        elsif manipulator_params[:密码] != params[:确认密码]
          str += "新密码与确认密码不一致！\r\n"
        else
          str += "密码修改成功！\r\n"
          @manipulator.update({"密码": manipulator_params[:密码]})
        end
      end
    end

    if is_empty(manipulator_params[:性别])
      str += "性别未填写！\r\n"
    elsif @manipulator.性别 != manipulator_params[:性别]
      str += "性别修改成功！\r\n"
      @manipulator.update({"性别": manipulator_params[:性别]})
    end

    if str == ""
      str += "请填写修改信息！\r\n"
    end
    render json: {"路径": "/manipulators/personal_info", "信息": str}
  end

  # DELETE /manipulators/1 or /manipulators/1.json
  def destroy
    if @manipulator.头像.图片 != 'default.jpg'
      File.delete("#{Rails.root}/app/assets/images/#{@manipulator.头像.图片}")
    end
    @manipulator.songs.each do |song|
      if song.封面.图片 != 'song/icon3.png'
        File.delete("#{Rails.root}/app/assets/images/#{song.封面.图片}")
      end
      song.images.each do |image|
        filename = image.图片
        File.delete("#{Rails.root}/app/assets/images/#{filename}")
      end
    end
    id = "manipulator-" + @manipulator.id.to_s
    if @manipulator.类型 == "管理员"
      render json: {"信息": "不能删除管理员账户！"}
    elsif @manipulator.id == current_manipulatorid.id
      session.delete(:current_manipulatortype)
      session.delete(:current_manipulatorid)
      @manipulator.destroy
      render json: {"路径": "/manipulators/user_login", "信息": "注销成功！"}
    else
      @manipulator.destroy
      render json: {"信息": "删除成功！", "ID": id}
    end
  end

  # POST /manipulators/do_register
  def do_register
    str = ""
    
    if !check_length(params[:名称])
      str += "名称需介于1~20字符之间！\r\n"
    else
      manipulator = Manipulator.where("名称": params[:名称]).first
      if manipulator
        str += "名称已被使用！\r\n"
      end
    end
    if !check_pwd_length(params[:密码])
      str += "密码需介于8~20字符之间！\r\n"
    end
    if is_empty(params[:性别])
      str += "性别未填写！\r\n"
    end

    url = "/manipulators/user_login"
    if str == ""
      @manipulator = Manipulator.new({"名称": params[:名称], "密码": params[:密码], "类型": params[:类型], "性别": params[:性别]})
      
      if !is_empty(params[:头像])
        uploaded_io = params[:头像]
        suffix = File.extname(uploaded_io.original_filename)
        filename = "uploads/account/" + Time.now.to_i.to_s + "_0" + suffix
        if suffix == '.jpg' or suffix == '.jpeg' or suffix == '.png'
          @picture = Picture.new({"图片": filename})
          @manipulator.头像 = @picture
          File.open(Rails.root.join('app/assets/images', filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          @picture.save
        else
          str += "图片必须为 .jpg 或 .jpeg 或 .png 格式！\r\n"
          @picture = Picture.new({"图片": "default.jpg"})
          @manipulator.头像 = @picture
          @picture.save
        end
      else
        @picture = Picture.new({"图片": "default.jpg"})
        @manipulator.头像 = @picture
        @picture.save
      end
      
      if @manipulator.save
        str += "注册成功！"
        render json: {"路径": url, "信息": str}
      else
        str += "注册失败！"
        render json: {"信息": str}
      end
    else
      render json: {"信息": str}
    end
  end

  # GET /manipulators/user_register
  def user_register
    render 'user_register', layout: 'account'
  end

  # POST /manipulators/do_login
  def do_login
    str = ""

    if !check_length(params[:名称])
      str += "名称需介于1~20字符之间！\r\n"
    end
    if !check_pwd_length(params[:密码])
      str += "密码需介于8~20字符之间！\r\n"
    end

    if str == ""
      if params[:类型] == "管理员"
        if Manipulator.where({"名称": "LHQ", "密码": "lhq12345678", "类型": "管理员"}).first == nil
          @manipulator = Manipulator.new({"名称": "LHQ", "密码": "lhq12345678", "类型": "管理员"})
          @picture = Picture.new({"图片": "default.jpg"})
          @manipulator.头像 = @picture
          @picture.save
          @manipulator.save
        end
      end
      manipulator = Manipulator.where({"名称": params[:名称], "密码": params[:密码], "类型": params[:类型]}).first
      if manipulator
        session[:current_manipulatorid] = manipulator.id
        session[:current_manipulatortype] = manipulator.类型
        str += "登录成功！"
        url = ""
        if params[:类型] == "管理员"
          url = "/manipulators"
        else
          url = "/song_types"
        end
        render json: {"路径": url, "信息": str, "ID": manipulator.id}
      else
        str += "密码或用户名错误！"
        render json: {"信息": str}
      end
    else
      render json: {"信息": str}
    end
  end

  # GET /manipulators/user_login
  def user_login
    render 'user_login', layout: 'account'
  end

  # GET /manipulators/manager_login
  def manager_login
    render 'manager_login', layout: 'account'
  end

  # GET /manipulators/logout
  def logout
    type = current_manipulatortype
    session.delete(:current_manipulatortype)
    session.delete(:current_manipulatorid)

    if type == "管理员"
      render json: {"路径": "/manipulators/manager_login", "信息": "登出成功！"}
    else
      render json: {"路径": "/manipulators/user_login", "信息": "登出成功！"}
    end
  end

  # GET /manipulators/personal_info
  def personal_info
    @manipulator = current_manipulatorid
    if params[:data]
      @select = params[:data]
    else
      @select = "mydata"
    end
    @unread_count = Notice.where("notices.receiver_id = :user_id AND notices.read_by_receiver = :status", 
    user_id: @manipulator.id, status: "未读").count

    if params[:data] == "未读" or params[:data] == "已读"
      @msgs = Notice.where("notices.receiver_id = :user_id AND notices.read_by_receiver = :status", 
      user_id: @manipulator.id, status: params[:data])
      respond_to do |format|
        format.html { render 'personal_info', layout: 'main' }
        format.json { render json: {"路径": "/manipulators/personal_info"} }
      end
    else
      respond_to do |format|
        format.html { render 'personal_info', layout: 'main' }
        format.json { render json: {"路径": "/manipulators/personal_info"} }
      end
    end
  end

  # DELETE /manipulators/delete_avatar
  def delete_avatar
    @manipulator = current_manipulatorid
    if @manipulator.头像.图片 != 'default.jpg'
      File.delete("#{Rails.root}/app/assets/images/#{@manipulator.头像.图片}")

      @manipulator.头像.update({"图片": "default.jpg"})
    end
    render json: {"路径": "/manipulators/personal_info", "信息": "删除头像成功！"}
  end

  def session_id
    if (current_manipulatorid)
        render json: { session_id: current_manipulatorid.id }
    else
        render json: { status: :bad_request }
    end
  end

  def is_empty(data)
    if data == "undefined" or data == nil or data == ""
      return true
    else
      return false
    end
  end

  def check_length(data)
    if data.length > 0 and data.length <= 20
      return true
    else
      return false
    end
  end

  def check_pwd_length(data)
    if data.length >= 8 and data.length <= 20
      return true
    else
      return false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manipulator
      @manipulator = Manipulator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def manipulator_params
      params.require(:manipulator).permit(:名称, :类型, :密码, :性别)
    end

    def authenticate
      unless current_manipulatorid
        respond_to do |format|
          format.html { redirect_to user_login_manipulators_url }
          format.json { render json: {"路径": "/manipulators/user_login", "信息": "请先登录！"}, status: :bad_request }
        end
      end
    end

    def authenticate_user
      if !current_manipulatorid or current_manipulatortype != "用户"
        respond_to do |format|
          format.html { redirect_to user_login_manipulators_url }
          format.json { render json: {"路径": "/manipulators/user_login", "信息": "请先登录用户账号！"}, status: :bad_request }
        end
      end
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
