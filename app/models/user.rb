class User < ActiveRecord::Base
  attr_accessor :full_name
  has_many :reservations, dependent: :destroy
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
  def self.search(search)
    unless search.empty?
      where(
        'first_name ILIKE ? OR 
        last_name ILIKE ? OR 
        email ILIKE ?',
        "%#{search}%", "%#{search}%", "%#{search}%")
    else
      none
    end
  end
end
