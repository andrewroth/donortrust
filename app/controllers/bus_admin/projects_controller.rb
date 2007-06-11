class BusAdmin::ProjectsController < ApplicationController
  before_filter :login_required  
  
  active_scaffold :project do |config|
    config.list.columns = [:name, :description, :expected_completion_date, 
                          :start_date, :end_date, :dollars_spent, :total_cost]                          
    config.show.columns = [:name, :description, :expected_completion_date, 
                          :start_date, :end_date, :dollars_spent, :total_cost, :project_histories]
    config.update.columns = [:name, :description, :expected_completion_date, 
                          :start_date, :end_date, :dollars_spent, :total_cost]
    config.create.columns = [:name, :description, :expected_completion_date, 
                          :start_date, :end_date, :dollars_spent, :total_cost]
    config.nested.add_link("Show history", [:project_histories])   
    
    config.create.columns.exclude :project_histories
    config.list.columns.exclude :project_histories
    config.update.columns.exclude :project_histories
  end

end
