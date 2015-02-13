# Funktioner der bruges til at håndtere simple omregninger der udføres mange gange.
datetimeToMinutes = (datetime) -> datetime.getUTCHours()*60+datetime.getUTCMinutes()
minutesToPixels = (minutes) -> minutes*((600/24)/60)

# Funktion der placerer en reservation korrekt på siden ud fra data-attributes
$.fn.placeAccordingly = ->
  starts_at = new Date(@data("starts-at"))
  ends_at = new Date(@data("ends-at"))
  # Afgør om reservationen startede igår
  yesterday = new Date(@parents("tr").data("date"))
  yesterday.setUTCDate yesterday.getUTCDate() - 1
  started_yesterday = (starts_at.getUTCDate() == yesterday.getUTCDate())
  # Afgør om reservationen først slutter imorgen
  tomorrow = new Date(@parents("tr").data("date"))
  tomorrow.setUTCDate tomorrow.getUTCDate() + 1
  ends_tomorrow = (ends_at.getUTCDate() == tomorrow.getUTCDate())
  # Afgør hvor mange minutter reservationen varer
  duration_in_mins = (ends_at.getTime() - starts_at.getTime())/(60*1000)
  # Bestem afstanden fra toppen
  if started_yesterday
    mins_from_top = 0
  else
    mins_from_top = datetimeToMinutes(starts_at)
  @css 'top', minutesToPixels(mins_from_top)+1
  # Bestem absolut højde
  if started_yesterday
    height_in_mins = duration_in_mins - ((24*60)-datetimeToMinutes(starts_at))
  else if ends_tomorrow
    height_in_mins = (24*60)-datetimeToMinutes(starts_at)
  else
    height_in_mins = duration_in_mins
  @css 'height', minutesToPixels(height_in_mins)-2
  return

$ ->
  # Begynd dato-feltet
  $("#date").change ->
    $(this).parents("form").submit()
  
  # Beregn på hvilke tider der kan indsættes "Opret reservation"-skilte 

  # Placer alle reservationene korrekt på siden
  $(".reservation").each (index, reservation) ->
    $(reservation).placeAccordingly()
  
  # Ved klik på en printer
  $('.printer-header').on 'click', ->
    name = $(this).data 'name'
    $('#show_printer').find('#name').val name
    $('#show_printer').foundation 'reveal', 'open'
  
  # Ved klik på en reservation
  $('.reservation').on 'click', ->
    id = $(this).data 'id'
    starts_at = new Date $(this).data('starts-at')
    ends_at = new Date $(this).data('ends-at')
    $('#show_reservation').find('#id').val id
    $('#show_reservation').find('#starts_at').val starts_at
    $('#show_reservation').find('#ends_at').val ends_at
    $('#show_reservation').foundation 'reveal', 'open'

