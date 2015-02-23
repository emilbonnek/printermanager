class User < ActiveRecord::Base
  attr_accessor :full_name, :password
  before_validation :separate_name
  
  validates :email, {uniqueness: true}
  validates :password, {confirmation: true}

  def separate_name
    self.first_name, self.last_name = self.full_name.titleize.match(/(\w+|\w+\-\w+)\ (.+$)/).captures
  end
end
