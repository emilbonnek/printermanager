module ReservationsHelper
  def calc_top(reservation)
    ((reservation.starts_at.hour + reservation.starts_at.min.to_f/60)/24)*100
  end
  def calc_height(reservation)
    (reservation.ends_at - reservation.starts_at)/60/60/24*100
  end
  def duration(reservation)
    hh = ((reservation.ends_at - reservation.starts_at)/60/60).to_i
    mm = ((reservation.ends_at - reservation.starts_at)/60%60).to_i
    if hh==0
      return mm.to_s + " minutter"
    elsif mm==0
      return hh.to_s + " timer"
    else
      return hh.to_s + " timer og " + mm.to_s + " minutter"
    end
  end
end
