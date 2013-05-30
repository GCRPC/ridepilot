class ProviderEthnicity < ActiveRecord::Base
  belongs_to :provider
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  validate :name, :length => { :minimum => 2 }

  default_scope :order => 'name'

  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
end
