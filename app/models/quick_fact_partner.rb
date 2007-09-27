class QuickFactPartner < ActiveRecord::Base
  
  belongs_to :quick_fact
  belongs_to :partner
  belongs_to :you_tube_video  
     
  validates_presence_of   :quick_fact
  validates_presence_of   :description
end
