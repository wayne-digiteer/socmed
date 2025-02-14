# app/controllers/admin/base_controller.rb
module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!

    private
    layout "admin"

    def after_sign_in_path_for(resource)
      admin_dashboard_path
    end
  end
end
