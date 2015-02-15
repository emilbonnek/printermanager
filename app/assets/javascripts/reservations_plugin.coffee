# Funktioner der henter start og slut tidspunkt for en reservation og laver dem til Javascript dato-objekter.
$.fn.startsAt = ->
  new Date(@data("starts-at"))
$.fn.endsAt = ->
  new Date(@data("ends-at"))

# Funktion der beregner længden af en reservation i minutter
$.fn.durationInMinutes = ->
  (@endsAt().getTime() - @startsAt().getTime())/(60*1000)

# Boolske funktioner der afgør om en reservation startede igår og slutter imorgen
$.fn.startedYesterday = ->
  yesterday = new Date(@parents("tr").data("date"))
  yesterday.setUTCDate yesterday.getUTCDate() - 1
  return @startsAt().getUTCDate() == yesterday.getUTCDate()
$.fn.endsTomorrow = ->
  tomorrow = new Date(@parents("tr").data("date"))
  tomorrow.setUTCDate tomorrow.getUTCDate() + 1
  return @endsAt().getUTCDate() == tomorrow.getUTCDate()

# Funktion der placerer en reservation korrekt på siden ud fra data-attributes
$.fn.placeAccordingly = ->
  starts_at = @startsAt()
  # Bestem afstanden fra toppen
  if @startedYesterday()
    mins_from_top = 0
  else
    mins_from_top = datetimeToMinutes(starts_at)
  @css 'top', minutesToPixels(mins_from_top)
  # Bestem absolut højde
  if @startedYesterday()
    height_in_mins = @durationInMinutes() - ((24*60)-datetimeToMinutes(starts_at))
  else if @endsTomorrow()
    height_in_mins = (24*60)-datetimeToMinutes(starts_at)
  else
    height_in_mins = @durationInMinutes()
  @css 'height', minutesToPixels(height_in_mins)
  return