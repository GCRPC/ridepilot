class LiteUniqueRider < ApplicationRecord

  belongs_to :provider

  scope :for_provider,  -> (provider_id) { where(provider_id: provider_id) }

end