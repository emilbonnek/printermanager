# Funktioner der bruges til at håndtere simple omregninger der udføres mange gange.
datetimeToMinutes = (datetime) -> datetime.getUTCHours()*60+datetime.getUTCMinutes()
minutesToPixels = (minutes) -> minutes*((500/24)/60)

getWeekday = (datetime) ->
  weekdays = ["Søndag", "Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag"]
  return weekdays[datetime.getUTCDay()]

# Funktion der formaterer et tidsounkt som YYYY:MM:dd
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
  hh = datetime.getUTCHours()
  mm = datetime.getUTCMinutes()
  if hh < 10
    hh = '0' + hh
  if mm < 10
    mm = '0' + mm
  return hh + ":" + mm
# Funktion der formaterer et givent antal minutter som 'hh timer og mm minutter'
formatMinutes = (minutes) ->
  hh = minutes // 60
  mm = minutes %% 60
  if hh==0
    return mm + " minutter"
  else if mm==0
    return hh + " timer"
  else
    return hh + " timer og " + mm + " minutter"

# ----- FUNKTIONER DER BRUGES I FORMULAREN TIL AT OPRETTE EN NY RESERVATION ----- #
# Funktioner der bruges til at sætte slideren og felterne i formularen
setDurationSlider = (hours, minutes) ->
  duration = hours*60+minutes
  duration = 0     if duration <= 0
  duration = 12*60 if duration >= 12*60
  $('#new_reservation').find("#reservation_duration_slider").foundation('slider', 'set_value', duration)

setDurationFields = (duration) ->
  $('#new_reservation').find("#reservation_duration_hours").val duration//60
  $('#new_reservation').find("#reservation_duration_minutes").val duration%%60

showOrHideCurrentTime = () ->
  checked = $("#update_settings").find("#current_time_toggle").prop( "checked")
  if checked
    $(".current-time").show()
  else
    $(".current-time").hide()

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

  # Ved ændring på dato-feltet
  $("#date").change ->
    $(@).parents("form").submit()

  # Ved ændring i indstillingerne i toppen
  $("#update_settings").find("#current_time_toggle").change ->
    showOrHideCurrentTime()
  
  # Skriv ugedagen på prefixet til dato-feltet
  date = new Date($("#date").val())
  $("#date-prefix").text getWeekday(date)
  
  $("tbody tr").each () ->
    beginning_of_day = new Date($(@).data("date"))
    beginning_of_day.setUTCHours(0, 0, 0, 0)
    end_of_day = new Date($(@).data("date"))
    end_of_day.setUTCDate(end_of_day.getUTCDate() + 1)
    end_of_day.setUTCHours(0,0,0,0)

    $(@).children("td").each (index, field) ->
      # Opret en linje der viser klokken
      current_time = """
                       <div class="current-time">
                       </div>
                     """
      $(@).append current_time

      arr = []
      reservations = $(field).children(".reservation")
      for reservation in reservations
        id = $(reservation).data 'id'
        duration = $(reservation).durationInMinutes()
        starts_at = $(reservation).startsAt()
        ends_at = $(reservation).endsAt()

        # Sæt tooltip for den enkelte reservation
        tooltip = """
                    ID: #{id} <br/>
                    Klokken: #{formatTime(starts_at)} - #{formatTime(ends_at)} <br/>
                    Varer: #{formatMinutes(duration)} <br/>
                  """
        $(reservation).attr("title",tooltip)

        arr.push starts_at, ends_at
      
      arr = arr.sort()

      if arr[0]<=beginning_of_day      then arr.shift() else arr.unshift(beginning_of_day)
      if arr[arr.length-1]>=end_of_day then arr.pop()   else arr.push(end_of_day)
      console.log arr
      for i in [0..arr.length-1] by 2
        html = """ <div class='panel notreservation' data-starts-at='#{arr[i].toUTCString()}' data-ends-at='#{arr[i+1].toUTCString()}'>
                   
                   </div>
               """
        $(this).append(html) unless arr[i].getTime() == arr[i+1].getTime()


  # Placer alle reservationene og notreservationerne korrekt på siden
  $(".reservation, .notreservation").each (index, elem) ->
    $(elem).placeAccordingly()
  
  # Placer current-time linjen korrekt
  now = new Date()
  now.setUTCHours(now.getUTCHours()+1)
  mins_from_top = datetimeToMinutes(now)
  $(".current-time").css 'top', minutesToPixels(mins_from_top)
  # Skjul eller vis current-time linjerne 
  showOrHideCurrentTime()

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
    duration = 4*60 if duration > 4*60
    $('#new_reservation').find("#reservation_printer_id").val(printer_id)
    $('#new_reservation').find("#reservation_starts_at_date").val(starts_at_date).attr('readonly', true)
    $('#new_reservation').find("#reservation_starts_at_time").val(starts_at_time)
    setDurationSlider(duration//60,duration%%60)
    setDurationFields(duration)
    $('#new_reservation').find('#printer-row').hide()

    $('#new_reservation').foundation 'reveal', 'open'

  # Ved klik på "ny reservation"-knappen
  $("#new_reservation_button").on 'click', ->
    starts_at_date = formatDate(new Date($("#date").val()))
    $('#new_reservation').find("#reservation_printer_id").val("")
    $('#new_reservation').find("#reservation_starts_at_date").attr('readonly', false)
    $('#new_reservation').find("#reservation_starts_at_date").val(starts_at_date)
    $('#new_reservation').find("#reservation_starts_at_time").val("")
    setDurationSlider(4,0)
    setDurationFields(4*60)
    $('#new_reservation').find('#printer-row').show()

    $('#new_reservation').foundation 'reveal', 'open'
  
  # Ved ændringer på mulighederne i  "ny reservation" formularen
  $('#new_reservation').find('#reservation_duration_hours').on 'change', ->
      hours = parseInt $("#reservation_duration_hours").val()
      minutes = parseInt $("#reservation_duration_minutes").val()
      setDurationSlider hours, minutes

  $('#new_reservation').find('#reservation_duration_minutes').on 'change', ->
    hours = parseInt $("#reservation_duration_hours").val()
    minutes = parseInt $("#reservation_duration_minutes").val()
    setDurationSlider hours, minutes

    # Slideren i formularen ændres
  $('#new_reservation').find("#reservation_duration_slider").on "change", ->
    duration = parseInt $(@).attr('data-slider')
    setDurationFields duration

#new_user