class ApplicationController < ActionController::Base
    helper_method :current_manipulatorid
    helper_method :current_manipulatortype

    def current_manipulatorid
        @current_manipulatorid ||= Manipulator.find(session[:current_manipulatorid]) if session[:current_manipulatorid]
    end
  
    def current_manipulatortype
        @current_manipulatortype ||= session[:current_manipulatortype] if session[:current_manipulatortype]
    end
end
