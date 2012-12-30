class Formula < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search, against: [:formula, :description]

  attr_accessible :counter, :description, :formula, :periodic, :period
  validates :formula, :description, presence: true
end
