class Dt::SubscriptionsController < DtApplicationController
  helper "dt/places"
  helper "dt/checkouts"
  before_filter :login_required

  def index
    @subscriptions = current_user.subscriptions
  end
  
  def edit
    @subscription = current_user.subscriptions.find(params[:id])
  end
  
  def update
    @subscription = current_user.subscriptions.find(params[:id])
    @saved = @subscription.update_attributes(params[:subscription])
    respond_to do |format|
      format.html {
        if @saved
          flash[:notice] = "Your subscription has been updated"
          redirect_to dt_subscriptions_path
        else
          render :action => "edit"
        end
      }
    end
  end
  
  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    @ended = @subscription.end_subscription
    respond_to do |format|
      format.html {
        if @ended
          flash[:notice] = "Your subscription has been ended"
        else
          flash[:notice] = "Your subscription could not be ended - please contact us"
        end
        redirect_to dt_subscriptions_path
      }
    end
  end
end