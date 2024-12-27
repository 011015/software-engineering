class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    helper_method :current_manipulatorid
    helper_method :current_manipulatortype
    # helper_method :unread_count

    def current_manipulatorid
        # 不知道为什么删库重建了还有id=1，需要用find_by_id，以免报错
        # find_by_id找不到会返回nil
        @current_manipulatorid ||= Manipulator.find_by_id(session[:current_manipulatorid]) if session[:current_manipulatorid]
    end
  
    def current_manipulatortype
        @current_manipulatortype ||= session[:current_manipulatortype] if session[:current_manipulatortype]
    end

    # def unread_count
    #     count = Notice.where("notices.receiver_id = :user_id AND notices.read_by_receiver = :status", 
    #     user_id: current_manipulatorid.id, status: '未读').count
    #     if count > 99
    #         @unread_count = "99+"
    #     elsif count > 0
    #         @unread_count = count
    #     else
    #         @unread_count = nil
    #     end
    # end

    private
    def record_not_found
      render file: Rails.root.join('public', '404.html'), status: :not_found, layout: false
    end
end
