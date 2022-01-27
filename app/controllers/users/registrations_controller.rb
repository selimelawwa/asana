# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :clear_password_submission, only: [:update]
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :edit_password]

  # GET /resource/sign_up
  def new
    self.resource = resource_class.new(sign_up_params)
    store_location_for(resource, params[:redirect_to])
    super
  end

  # POST /resource
  def create
    super
    current_or_guest_user
    UserMailer.signup_confirmation(@user).deliver
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      bypass_sign_in resource, scope: resource_name
      flash[:notice] = "Account succesfully updated!"
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def check_email
    any_user = User.find_by(email: params[:user_email])
    if current_user
      email_used_before = any_user&.present? && any_user&.id != current_user.id
    else
      email_used_before = any_user&.present?
    end    
    render json: {email_used_before: email_used_before}
  end

  def check_current_password
    valid_password = current_user.valid_password?(params[:user_password])
    render json: {right_current_password: valid_password}
  end

  def edit_password
  end

  def update_password
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if user_params[:password].blank? || user_params[:password_confirmation].blank?
      flash[:alert] = "Current Password Can't be Blank"
      render "edit_password"
    elsif resource.update_with_password(user_params)
      flash[:notice] = "Password succesfully updated!"
      bypass_sign_in resource, scope: resource_name
      redirect_to edit_user_registration_path(resource)
    else
      flash[:alert] = resource.reload.valid_password?(params.dig(:user,:current_password)) ? "New Password Invalid / Dont Match Confirmation" : "Please Enter Correct Password"
      render "edit_password"
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def clear_password_submission
    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
    params[:user].delete(:current_password)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:city, :birthday, :name, :mobile])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys:  [:city, :birthday, :name, :mobile])
  end 

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
