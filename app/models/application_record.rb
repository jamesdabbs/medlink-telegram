class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.newest n
    order(created_at: :desc).limit(n)
  end
end
