class BusAdmin::InvestmentsController < ApplicationController
  layout 'admin'
  before_filter :login_required, :check_authorization
  before_filter :load_order

  def index
    @investments = @order.present? ? @order.investments : Investment.all
  end
  
  private
    def load_order
      @order = Order.find(params[:order_id]) if params[:order_id]
    end
end