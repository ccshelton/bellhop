class AppsController < ApplicationController
  layout :resolve_layout

  def index
    @apps = current_admin.apps.all
  end

  def show
  end

  def new
    @app = App.new
  end

  def create
    @app = current_admin.apps.new(app_params)
    if @app.save
      redirect_to root_url(subdomain: @app.subdomain)
    else
      render 'new'
    end
  end

  def update
    @app = current_tenant
    if @app.update(app_params)
      redirect_to request.referrer
      flash[:success] = "Settings updated"
    else
      render "/admin/pages/settings"
    end
  end

  def destroy
    App.find(current_tenant.id).destroy
    flash[:success] = "App deleted"
    redirect_to root_url(:subdomain => false)
  end

  private
    def app_params
      params.require(:app).permit(:intercom_id, :subdomain, :user_id_enabled, :secure_mode_enabled)
    end

    def resolve_layout
      if action_name == 'show'
        'apps_layout'
      elsif action_name == 'update'
        'admin_layout'
      else
        'application'
      end
    end
end
