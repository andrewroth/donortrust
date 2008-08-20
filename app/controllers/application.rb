class ApplicationController < ActionController::Base
  filter_parameter_logging :password
  include DtAuthenticatedSystem
  helper :dt_application
  helper "dt/search"

  #before_filter :set_user
  before_filter :login_from_cookie, :ssl_filter

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_donortrustfe_session_id'

  def rescue_404
    rescue_action_in_public DtNotFoundError.new
  end

  def rescue_action_in_public(exception)
    case exception.to_s
    when /DtNotFoundError/, /RoutingError/, /UnknownAction/
      render :template => "dt/shared/errors/error404", :layout => "dt_application", :status => "404"
    else
      @message = exception
      render :template => "dt/shared/errors/error", :layout => "dt_application", :status => "500"
    end
  end

  def check_authorization
    if logged_in?
      roles = current_user.roles
      requested_action = action_name
      requested_controller = self.class.controller_path
      requested_controller_id = self;
      actions = [];
      roles.each do |role|
        role.authorized_actions.each do |action|
          actions << action
        end
      end
      unless actions.detect do |action|
          permitted_actions = AuthorizedAction.find :all, :conditions => {"authorized_controller_id","#{requested_controller_id}"}
          for permitted_action in permitted_actions
            if user_type.bus_secure_action_id == permitted_action.id || indirect_approve()
              return true
            end
          end

          #puts "Permitted action: " + action.name + " Desired Action: " + requested_action.to_s + " With controller: " + requested_controller
          if direct_approve(requested_action.to_s, action.name.to_s, requested_controller.to_s,  action.authorized_controller.name.to_s ) ||
              indirect_approve(requested_action.to_s, action.name.to_s, requested_controller.to_s, action.authorized_controller.name.to_s, requested_controller_id )
            return true
          end
      end

        flash[:notice] = "You are not authorized to view the requested page."


        if request.parameters.has_value?('_list_inline_adapter') || request.parameters.has_value?('_method=delete')
          render :text => "You do not have access"
        else
          redirect_to('/dt')
        end
        return false
      end
    else
      return false
    end
  end

  def direct_approve (requested_action, permitted_action, requested_controller, permitted_controller)
    return (requested_action == permitted_action) && (requested_controller == permitted_controller)
  end

  def indirect_approve (requested_action, permitted_action, requested_controller, permitted_controller, requested_controller_id)
    case(requested_action)
    when ("index")
      return (permitted_action == 'list' || permitted_action == 'show') && (requested_controller == permitted_controller)
    when("update")
      return permitted_action == 'edit' && (requested_controller == permitted_controller)
    when("table")
      return permitted_action == 'list' && (requested_controller == permitted_controller)
    when("destroy")
      return permitted_action == 'delete' && (requested_controller == permitted_controller)
    when("new")
      return permitted_action == 'create' && (requested_controller == permitted_controller)
    when("row")
      return permitted_action == 'list' && (requested_controller == permitted_controller)
    when("nested")
      return permitted_action == 'show' && (requested_controller == permitted_controller)
    when("update_table")
      return permitted_action == 'show' && (requested_controller == permitted_controller)
    when("show_search")
      return permitted_action == 'list' && (requested_controller == permitted_controller)
    when("edit_associated")
      return permitted_action == 'edit' && (requested_controller == permitted_controller)
    when("get_association")
      return permitted_action == 'edit' && (requested_controller == permitted_controller)
    when("inactive_records")
      return permitted_action == 'record_management' && (requested_controller == permitted_controller)
    when("recover_record")
      return permitted_action == 'record_management' && (requested_controller == permitted_controller)
    else
      defined? requested_controller_id.get_local_actions(requested_action,permitted_action)

    end
  end

protected

def permission_denied
  flash[:notice] = "You don't have privileges to access this action"
  return redirect_to('/dt')
end

def permission_granted
  # CHANGED: commented the following line as it overrode all the normal flash notices!
  # flash[:notice] = "Welcome to the business administration area!"
end

def ssl_filter
  if ['production'].include?(ENV['RAILS_ENV'])
    redirect_to url_for(params.merge({:protocol => 'https://'})) and return false if !request.ssl? && ssl_required?
    redirect_to url_for(params.merge({:protocol => 'http://'})) and return false if request.ssl? && !ssl_required?
  end
end

#MP - Dec 14, 2007
#Added to support the us tax receipt functionality
#allows us to set a value indicating that the user has requested
#a US tax receipt. If the value is false, the session variable is
#cleared, otherwise it is set to true
def requires_us_tax_receipt(value)
  if value
    session[:requires_us_tax_receipt] = value
  else
    session[:requires_us_tax_receipt] = nil unless session[:requires_us_tax_receipt].nil?
  end
end

#MP - Dec 14, 2007
#Added to support the us tax receipt functionality
#If the user has indicated that they want a US tax
#receipt, the session variable will be true,
#otherwise it should be nil.
def requires_us_tax_receipt?
  return session[:requires_us_tax_receipt] unless session[:requires_us_tax_receipt].nil?
  false
end

def ssl_required?
  false
end

def log_error(exception)
  super(exception)
  if ENV['RAILS_ENV'] == 'production'
    begin
      ErrorMailer.deliver_snapshot(
        exception,
        clean_backtrace(exception),
        @session.instance_variable_get("@data"),
        @params,
        @request.env)
    rescue => e
      logger.error(e)
    end
  end
end

# Error Handling
class DtNotFoundError < Exception
end
end
