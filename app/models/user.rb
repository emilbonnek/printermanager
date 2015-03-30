class User < ActiveRecord::Base
  attr_accessor :full_name
  has_many :reservations
  has_secure_password
  before_validation :separate_name
  
  validates :email, {uniqueness: true}
  validates :password, {confirmation: true}

  def separate_name
    self.first_name, self.last_name = self.full_name.titleize.match(/(\w+|\w+\-\w+)\ (.+$)/).captures
  end
  def format_name
    "#{self.first_name} #{self.last_name}"
  end
end
