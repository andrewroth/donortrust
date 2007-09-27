class BusAdmin::QuickFactPartnersController < ApplicationController
  before_filter :login_required#, :check_authorization
  
  active_scaffold :quick_fact_partners do |config|
    config.label = "Quick Facts"
    config.columns = [ :quick_fact, :partner, :description ]    
    config.columns[ :quick_fact ].form_ui = :select
    config.columns[ :partner ].form_ui = :select    
    config.action_links.add 'index', :label => '<img src="/images/icons/you_tube.png" border=0>', :page => true, :type=> :record, :parameters =>{:controller=>"bus_admin/project_you_tube_videos"}
  end
end
