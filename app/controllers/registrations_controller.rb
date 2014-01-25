class RegistrationsController < Devise::RegistrationsController

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      @user.update_without_password(params[:user])
    else
      @user.update_attributes(params[:user])
    end
    if @user.errors.blank?
      redirect_to admin_users_path, :notice => "User updated successfully."
    else
      render :edit
    end
  end

end