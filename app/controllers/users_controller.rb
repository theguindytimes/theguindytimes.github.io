class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:show,:admin]
  before_action :check_user,  only: [:show, :index, :new, :new_news, :edit]

  def index
    @users = User.all
    authorize @users
  end

  def show
    @user = User.friendly.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.friendly.find(params[:id])
    authorize @user
    if @user != current_user and current_user.admin?
      if @user.admin?
        @user.update_attributes({:role => 0})
      else
        @user.update_attributes({:role => 1})
      end
      redirect_to users_path, :alert => "User updated"
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
    # if @user.update_attributes(secure_params)
      # redirect_to users_path, :notice => "User updated."
    # else
      # redirect_to users_path, :alert => "Unable to update user."
    # end
  end

  def destroy
    user = User.friendly.find(params[:id])
    authorize user
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  private

  def check_user
    redirect_to root_path if !(current_user and current_user.admin?)
  end
  def secure_params
    params.require(:user).permit(:role)
  end

end
