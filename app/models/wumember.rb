class Wumember < ActiveRecord::Base
  validates :name, :artist_id, presence: true
end
