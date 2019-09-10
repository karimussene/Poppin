class FavoriteCuisine < ApplicationRecord
  belongs_to :cuisine
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :cuisine_id
end

