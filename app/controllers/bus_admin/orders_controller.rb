class BusAdmin::OrdersController < ApplicationController
  layout 'admin'
  before_filter :login_required, :check_authorization

  active_scaffold do |config|
    # config.columns = [ :first_name, :last_name, :login, :country, :roles, :staff, :title, :twitter, :facebook, :bio]
    # config.columns[:roles].form_ui = :select 
    # config.list.columns = [:first_name, :last_name, :login, :roles, :staff]
    # config.update.columns = [:first_name, :last_name, :login, :display_name, :address,  :city, :province, :country, :postal_code, :administrations, :staff, :title, :twitter, :facebook, :bio]
    
    list.sorting = [{:updated_at => 'DESC'}, {:complete => "DESC"}]
    config.list.columns =   [:order_number, :first_name, :last_name, :company, :email, :total, :user, :updated_at, :complete]
    config.update.columns = [:donor_type, :title, :first_name, :last_name, :company, :address, :address2, :city, :country, :province, :postal_code, :email, :total, :account_balance_payment, :credit_card_payment, :card_number, :cvv, :expiry_month, :expiry_year, :cardholder_name, :authorization_result, :order_number, :user_id, :complete, :created_at, :updated_at, :gift_card_payment, :gift_card_payment_id, :pledge_account_payment, :pledge_account_payment_id, :is_registration, :registration_fee_id, :subscription_id, :tax_receipt_requested]
  end
  # 
  # def index
  #   @orders = Order.all
  # end
end