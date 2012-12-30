class Image < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, 
    against: {
      description: 'A'
    }

  attr_accessible :description, :uri
end
