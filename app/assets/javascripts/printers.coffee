# Funktioner der bruges til at håndtere simple omregninger der udføres mange gange.
datetimeToMinutes = (datetime) -> datetime.getUTCHours()*60+datetime.getUTCMinutes()
minutesToPixels = (minutes) -> minutes*((600/24)/60)

# En klasse der repræsenterer en Reservation. Indholder koden der placerer hver reservation rigtigt på siden.
class Reservation
  constructor: (@html_element) ->
    @starts_at = new Date($(html_element).data("starts-at"))
    @ends_at = new Date($(html_element).data("ends-at"))
  # Bestem reservationens afstand fra toppen i tabellen
  setTop: ->
    if @startedYesterday()
      mins_from_top = 0
    else
      mins_from_top = datetimeToMinutes(@starts_at)
    $(@html_element).css "top", minutesToPixels(mins_from_top)+2
  # Bestem reservationens højde i tabellen
  setHeight: ->
    if @startedYesterday()
      height_in_mins = @calcDuration() - ((24*60)-datetimeToMinutes(@starts_at))
    else if @endsTomorrow()
      height_in_mins = (24*60)-datetimeToMinutes(@starts_at)
    else
      height_in_mins = @calcDuration()
    $(@html_element).css "height", minutesToPixels(height_in_mins)-4
  calcDuration: ->
    (@ends_at.getTime() - @starts_at.getTime())/(60*1000)
  # Tjek om reservationen startede igår
  startedYesterday: ->
    yesterday = new Date($("#date").val())
    yesterday.setUTCDate yesterday.getUTCDate() - 1
    @starts_at.getUTCDate() == yesterday.getUTCDate()
  # Tjek om reservationen slutter imorgen
  endsTomorrow: ->
    tomorrow = new Date($("#date").val())
    tomorrow.setUTCDate tomorrow.getUTCDate() + 1
    @ends_at.getUTCDate() == tomorrow.getUTCDate()


  

$ ->
  # Begynd dato-feltet
  $("#date").change ->
    $(this).parents("form").submit()
  
  # Begynd tabellen
  $(".printer").each (index, printer) ->
    $(printer).children(".reservation").each (index, reservation) ->
      r = new Reservation(reservation)
      r.setTop()
      r.setHeight()
  
  $('.printer-header').on 'click', ->
    name = $(this).data 'name'
    $('#show_printer').find('#name').val name
    $('#show_printer').foundation 'reveal', 'open'

  $(document).on 'opened', '#show_printer[data-reveal]', ->

    $("#show_reservation").append("<a class='close-reveal-modal'>×</a>")