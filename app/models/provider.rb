class Provider < ActiveRecord::Base
  has_many :roles, :dependent => :destroy
  has_many :users, :through => :roles
  has_many :drivers, :dependent => :destroy
  has_many :vehicles, :dependent => :destroy
  has_many :device_pools, :dependent => :destroy
  has_many :monthlies, :dependent => :destroy
  has_many :ethnicities, :class_name=>'ProviderEthnicity', :dependent => :destroy
  has_many :funding_source_visibilities, :dependent => :destroy
  has_many :funding_sources, :through => :funding_source_visibilities
  has_many :addresses, :dependent => :nullify

  has_attached_file :logo, :styles => { :small => "150x150>" }
  
  validate :name, :length => { :minimum => 2 }

  validates_attachment_size :logo, :less_than => 200.kilobytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  after_initialize :init

  def init
    self.scheduling = true if new_record?
  end
end
