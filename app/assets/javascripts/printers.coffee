# Funktioner der bruges til at håndtere simple omregninger der udføres mange gange.
datetimeToMinutes = (datetime) -> datetime.getUTCHours()*60+datetime.getUTCMinutes()
minutesToPixels = (minutes) -> minutes*((500/24)/60)
# Funktion der formaterer et tidspunkt som tt:mm
FormatTime = (datetime) -> 
  t = datetime.getUTCHours()
  m = datetime.getUTCMinutes()
  if t < 10
    t = '0' + t
  if m < 10
    m = '0' + m
  return t + ":" + m

# Boolske funktioner der afgør om en reservation startede igår og slutter imorgen
$.fn.startedYesterday = ->
  starts_at = new Date(@data("starts-at"))
  yesterday = new Date(@parents("tr").data("date"))
  yesterday.setUTCDate yesterday.getUTCDate() - 1
  return starts_at.getUTCDate() == yesterday.getUTCDate()
$.fn.endsTomorrow = ->
  ends_at = new Date(@data("ends-at"))
  tomorrow = new Date(@parents("tr").data("date"))
  tomorrow.setUTCDate tomorrow.getUTCDate() + 1
  return ends_at.getUTCDate() == tomorrow.getUTCDate()

# Funktion der placerer en reservation korrekt på siden ud fra data-attributes
$.fn.placeAccordingly = ->
  starts_at = new Date(@data("starts-at"))
  ends_at = new Date(@data("ends-at"))
  # Afgør hvor mange minutter reservationen varer
  duration_in_mins = (ends_at.getTime() - starts_at.getTime())/(60*1000)
  # Bestem afstanden fra toppen
  if @startedYesterday()
    mins_from_top = 0
  else
    mins_from_top = datetimeToMinutes(starts_at)
  @css 'top', minutesToPixels(mins_from_top)
  # Bestem absolut højde
  if @startedYesterday()
    height_in_mins = duration_in_mins - ((24*60)-datetimeToMinutes(starts_at))
  else if @endsTomorrow()
    height_in_mins = (24*60)-datetimeToMinutes(starts_at)
  else
    height_in_mins = duration_in_mins
  @css 'height', minutesToPixels(height_in_mins)
  return

$ ->
  # Begynd dato-feltet
  $("#date").change ->
    $(this).parents("form").submit()
  
  # Beregn på hvilke tider der kan indsættes "ny reservation"-skilte 
  $("tbody tr td").each (index, field) ->
    reservations = $(field).children(".reservation")
    if reservations.first().css('top') == "0px"
      console.log reservations.first()
    #console.log reservations

  # Placer alle reservationene korrekt på siden
  $(".reservation").each (index, reservation) ->
    $(reservation).placeAccordingly()
  
  # Ved klik på en printer
  $('.printer-header').on 'click', ->
    name = $(this).data 'name'
    $('#show_printer').find('#name').text name
    $('#show_printer').foundation 'reveal', 'open'
  
  # Ved klik på en reservation
  $('.reservation').on 'click', ->
    id = $(this).data 'id'
    starts_at = new Date $(this).data('starts-at')
    ends_at = new Date $(this).data('ends-at')
    duration = "100 år"
    $('#show_reservation').find('#id').text id
    $('#show_reservation').find('#starts_at').text FormatTime(starts_at)
    $('#show_reservation').find('#ends_at').text FormatTime(ends_at)
    $('#show_reservation').find('#duration').text duration

    $('#show_reservation').foundation 'reveal', 'open'

