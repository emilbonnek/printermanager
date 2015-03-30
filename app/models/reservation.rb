class Reservation < ActiveRecord::Base
  attr_accessor :starts_at_date, :starts_at_time, :duration
  before_validation :create_start_datetime, :create_end_datetime
  belongs_to :printer
  belongs_to :user

  validates_datetime :starts_at, { on_or_after: :today }
  validate :starts_at_ok
  validate :ends_at_ok
  validate :ends_at_later_than_starts_at
  
  def create_start_datetime
    date = Date.parse self.starts_at_date
    time = Time.parse self.starts_at_time
    self.starts_at = DateTime.new(date.year, date.month,
                                   date.day,  time.hour,
                                   time.min,  time.sec )
  end
  def create_end_datetime
    self.ends_at = self.starts_at + self.duration.to_i.minutes
  end

  def duration_method
    (self.ends_at.to_i - self.starts_at.to_i)/60
  end
  
  # Udvælger de relevante reservation for en given dato, hvis ingen dato er givet bruges idag
  def self.relevant(date = Date.today)
    if date.blank?
      date = Date.today
    end
    where(
      '(starts_at > ? AND starts_at < ?) 
       OR (ends_at > ? AND ends_at < ?)',
      date.to_date.beginning_of_day, date.to_date.end_of_day, 
      date.to_date.beginning_of_day, date.to_date.end_of_day
    )
  end

  # Valideringsmetoder til af oprettelsen af en reservation
  private
  def starts_at_ok
    unless self.printer.reservations.where(
      '(starts_at < ? AND ends_at > ?)',
      starts_at, starts_at
    ).empty?
      errors.add(:starts_at, 'Denne tid starter oven i en anden reservation af samme printer')
    end
  end
  def ends_at_ok
    unless self.printer.reservations.where(
      '(starts_at > ? AND starts_at < ?)',
      starts_at, ends_at
    ).empty?
      errors.add(:ends_at, 'Denne tid slutter oven i en anden reservation af samme printer')
    end
  end
  def ends_at_later_than_starts_at
    if starts_at == ends_at
      errors.add(:ends_at, 'Denne tid starter og slutter på samme tid')
    elsif starts_at > ends_at 
      errors.add(:ends_at, 'Denne tid slutter før den starter, du har vist pillet ved noget')
    end
  end
end
