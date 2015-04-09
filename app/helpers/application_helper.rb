module ApplicationHelper
  def weekday(date)
    #date = Date.parse date
    weekdays = ["Søndag", "Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag"]
    weekdays[date.wday]
  end
end
