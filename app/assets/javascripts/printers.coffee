# Funktioner der bruges til at håndtere simple omregninger der udføres mange gange.
datetimeToMinutes = (datetime) -> datetime.getUTCHours()*60+datetime.getUTCMinutes()
minutesToPixels = (minutes) -> minutes*((500/24)/60)

getWeekday = (datetime) ->
  weekdays = ["Søndag", "Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag"]
  return weekdays[datetime.getUTCDay()]

formatDate = (datetime) ->
  yyyy = datetime.getUTCFullYear()
  MM = datetime.getUTCMonth() + 1
  dd = datetime.getUTCDate()
  if MM < 10
    MM = '0' + MM
  if dd < 10
    dd = '0' + dd
  return yyyy + "-" + MM + "-" + dd

# Funktion der formaterer et tidspunkt som tt:mm
formatTime = (datetime) -> 
  t = datetime.getUTCHours()
  m = datetime.getUTCMinutes()
  if t < 10
    t = '0' + t
  if m < 10
    m = '0' + m
  return t + ":" + m

# Funktion der formaterer et givent antal minutter som 't timer og m minutter'
formatMinutes = (minutes) ->
  t = minutes // 60
  m = minutes %% 60
  if t==0
    return m + " minutter"
  else if m==0
    return t + " timer"
  else
    return t + " timer og " + m + " minutter"



# ----- FUNKTIONER DER KAN BRUGES PÅ RESERVATIONER OG NOTRESERVATIONER ----- #
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
  
  # Skriv ugedagen på prefixet til dato-feltet
  date = new Date($("#date").val())
  $("#date-prefix").text getWeekday(date)
  
  # ------ START ------ #
  $("tbody tr").each () ->
    beginning_of_day = new Date($(@).data("date"))
    beginning_of_day.setUTCHours(0, 0, 0, 0)
    end_of_day = new Date($(@).data("date"))
    end_of_day.setUTCDate(end_of_day.getUTCDate() + 1)
    end_of_day.setUTCHours(0,0,0,0)

    $(@).children("td").each (index, field) ->
      
      arr = []
      reservations = $(field).children(".reservation")
      for reservation in reservations
        starts_at = $(reservation).startsAt()
        ends_at = $(reservation).endsAt()     
        arr.push starts_at, ends_at
      
      arr = arr.sort()

      if arr[0]<=beginning_of_day      then arr.shift() else arr.unshift(beginning_of_day)
      if arr[arr.length-1]>=end_of_day then arr.pop()   else arr.push(end_of_day)
      
      for i in [0..arr.length-1] by 2
        html = """ <div class='panel notreservation' data-starts-at='#{arr[i].toUTCString()}' data-ends-at='#{arr[i+1].toUTCString()}'>
                     
                   </div>
               """
        $(this).append(html) unless arr[i].getTime() == arr[i+1].getTime()

  # ------ SLUT ------ #

  # Placer alle reservationene og notreservationerne korrekt på siden
  $(".reservation, .notreservation").each (index, elem) ->
    $(elem).placeAccordingly()
  
  # Ved klik på "ny reservation"-knappen
  $("#new_reservation_button").on 'click', (event) ->

    $('#new_reservation').find("#reservation_printer_id").val("")
    $('#new_reservation').find("#reservation_starts_at_date").attr('readonly', false)
    $('#new_reservation').find("#reservation_starts_at_time").val("")
    $('#new_reservation').find('#reservation_duration_slider').foundation('slider', 'set_value', 6*60)
    $('#new_reservation').find('#printer-row').show()

    $('#new_reservation').foundation 'reveal', 'open'
    
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
  
  # Ved klik på en notreservation
  $('.notreservation').on 'click', ->
    printer_id = $(@).parents('td').data('printer-id')
    starts_at_date = formatDate $(@).startsAt()
    starts_at_time = formatTime $(@).startsAt()
    duration = $(@).durationInMinutes()
    duration = 12*60 if duration > 12*60
    $('#new_reservation').find("#reservation_printer_id").val(printer_id)
    $('#new_reservation').find("#reservation_starts_at_date").val(starts_at_date).attr('readonly', true)
    $('#new_reservation').find("#reservation_starts_at_time").val(starts_at_time)
    $('#new_reservation').find('#reservation_duration_slider').foundation('slider', 'set_value', duration)
    $('#new_reservation').find('#printer-row').hide()

    $('#new_reservation').foundation 'reveal', 'open'

