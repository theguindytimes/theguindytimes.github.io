class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :email, :password, :password_confirmation, :current_password)}
  end


def update
    if needs_password?(@user, user_params)
      if @user.update_with_password(user_params_password_update)
        flash[:notice] = 'User was successfully updated.'
      else
        error = true
      end
    else
      if @user.update_without_password(user_params)
        flash[:notice] = 'User was successfully updated.'
      else
        error = true
      end
    end

    if error
      flash[:error] = @user.errors.messages
      render action: "edit"
    else
	    redirect_to root_path
    end
  end
  private
  
def needs_password?(user, user_params)
  print '*'*100
  #!user_params[:current_password].blank?
  !user.encrypted_password.blank?
end

def user_params
  params[:user].permit(:email, :password, :password_confirmation,  :name)
end

#Need :current_password for password update
def user_params_password_update
  params[:user].permit(:email, :password, :password_confirmation, :current_password, :name)
end
end
