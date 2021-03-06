class Iend::AuthenticationsController < DtApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    logger.debug omniauth.to_yaml
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if !authentication && logged_in?
      authentication = current_user.apply_omniauth(omniauth)
      current_user.save # save the authentication and profile updates
      authentication.save!
      flash[:notice] = "Signed in successfully."
      redirect_to request.env["omniauth.origin"].present? ? request.env["omniauth.origin"] : iend_authentications_url
    elsif authentication
      flash[:notice] = "Signed in successfully."
      self.current_user = authentication.user
      redirect_to request.env["omniauth.origin"].present? ? request.env["omniauth.origin"] : iend_user_url(current_user)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        self.current_user = user
        redirect_to request.env["omniauth.origin"].present? ? request.env["omniauth.origin"] : iend_user_url(current_user)
      else
        flash[:notice] = "Please fill out the following missing information."
        session[:omniauth] = omniauth
        redirect_to new_iend_user_url
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully deleted #{@authentication.provider} authentication."
    redirect_to iend_authentications_url
  end

  def failure
    flash[:error] = "Sorry, we couldn't log you in"
    redirect_to home_url
  end
end