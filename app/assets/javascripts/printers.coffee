# Funktioner der bruges til at håndtere simple omregninger der udføres mange gange.
datetimeToMinutes = (datetime) -> datetime.getUTCHours()*60+datetime.getUTCMinutes()
minutesToPixels = (minutes) -> minutes*((500/24)/60)

# Funktion der formaterer et tidspunkt som tt:mm
formatTime = (datetime) -> 
  t = datetime.getUTCHours()
  m = datetime.getUTCMinutes()
  if t < 10
    t = '0' + t
  if m < 10
    m = '0' + m
  return t + ":" + m

# Funktion der formaterer et givent antal minutter
formatMinutes = (minutes) ->
  t = minutes // 60
  m = minutes %% 60
  if t==0
    return m + " minutter"
  else if m==0
    return t + " timer"
  else
    return t + " timer og " + m + " minutter"


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

$ ->
  # Begynd dato-feltet
  $("#date").change ->
    $(@).parents("form").submit()
  
  # Beregn på hvilke tider der kan indsættes "ny reservation"-skilte 
  $("tbody tr td").each (index, field) ->
    reservations = $(field).children(".reservation")
    start = new Date
    start.setUTCHours(0, 0, 0, 0)
    if reservations.first().endsAt() == start or reservations.first().startedYesterday()
      console.log "Denne her er placeret i toppen"


  # Placer alle reservationene korrekt på siden
  $(".reservation").each (index, reservation) ->
    $(reservation).placeAccordingly()
  
  # Ved klik på en printer
  $('.printer-header').on 'click', ->
    name = $(@).data 'name'
    $('#show_printer').find('#name').text name
    $('#show_printer').foundation 'reveal', 'open'
  
  # Ved klik på en reservation
  $('.reservation').on 'click', ->
    id = $(@).data 'id'
    starts_at = $(@).startsAt()
    ends_at = $(@).endsAt()
    duration = $(@).durationInMinutes()
    $('#show_reservation').find('#id').text id
    $('#show_reservation').find('#starts_at').text formatTime(starts_at)
    $('#show_reservation').find('#ends_at').text formatTime(ends_at)
    $('#show_reservation').find('#duration').text formatMinutes(duration)

    $('#show_reservation').foundation 'reveal', 'open'

