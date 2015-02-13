module ApplicationHelper
  def get_weekday_in_danish(date)
    weekdays = ["Søndag", "Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag"]
    weekdays[date.to_date.wday]
  end
end
