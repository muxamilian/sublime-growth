class Image < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: :description

  attr_accessible :description, :url
end
