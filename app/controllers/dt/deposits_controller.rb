require 'order_helper'
class Dt::DepositsController < DtApplicationController
  helper 'dt/places'
  before_filter :login_required
  before_filter :find_cart
  include OrderHelper
  
  CANADA = 'canada'
  
  def new
    params[:deposit] = session[:deposit_params] if session[:deposit_params]
    @deposit = Deposit.new(deposit_params)
    
    respond_to do |format|
      format.html {
        #MP Dec 14, 2007 - In order to support US donations, this was added to switch out the
        #layout of the Gift page. If the user's country is nil or not Canada,
        #use the layout that allows for US donations.
        unless logged_in? && current_user.in_country?(CANADA)
          render :layout => 'us_receipt_layout' and return
        end
      }
    end
  end
  
  def create
    @deposit = Deposit.new( deposit_params )
    @valid = @deposit.valid?
    respond_to do |format|
      if @valid
        session[:deposit_params] = nil
        @cart.add_item(@deposit)
        flash[:notice] = "Your Deposit has been added to your cart."
        format.html { redirect_to dt_cart_path }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def edit
    @deposit = @cart.items.find(params[:id]).item if @cart.items.find(params[:id]).item.kind_of?(Deposit)
    respond_to do |format|
      format.html {
        redirect_to dt_cart_path and return unless @deposit
      }
    end
  end
  
  def update
    if @cart.items.find(params[:id]).item.kind_of?(Deposit)
      @deposit = @cart.items.find(params[:id]).item
      @deposit.attributes = params[:deposit]
      @deposit.user_ip_addr = request.remote_ip
      @valid = @deposit.valid?
    end
    
    respond_to do |format|
      if !@deposit
        format.html { redirect_to dt_cart_path }
      elsif @valid
        @cart.update_item(params[:id], @deposit)
        flash[:notice] = "Your Deposit has been updated."
        format.html { redirect_to dt_cart_path }
      else
        format.html { render :action => "edit" }
      end
    end
  end
   
  protected
  def deposit_params
    deposit_params = {}
    deposit_params = deposit_params.merge(params[:deposit]) if params[:deposit]
    deposit_params[:user_id] = current_user.id
    deposit_params[:user_ip_addr] = request.remote_ip
    deposit_params
  end
  
  def access_denied_with_deposit
    flash[:error] = "You must be logged in to make a deposit to your account."
    access_denied_without_deposit
  end
  alias_method_chain :access_denied, :deposit
  
end
