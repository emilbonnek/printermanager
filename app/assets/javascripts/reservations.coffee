# Funktioner der bruges til at sætte slideren og felterne i formularen
setDurationSlider = (hours, minutes) ->
  duration = hours*60+minutes
  duration = 0     if duration <= 0
  duration = 12*60 if duration >= 12*60
  $('#new_reservation').find("#reservation_duration_slider").foundation('slider', 'set_value', duration)

setDurationFields = (duration) ->
  $('#new_reservation').find("#reservation_duration_hours").val duration//60
  $('#new_reservation').find("#reservation_duration_minutes").val duration%%60

$ ->

  # Vis en formular til at oprette en ny reservation
  $(document).on 'opened', '#new_reservation[data-reveal]', ->

    # Tallene i formularen ændres
    $('#reservation_duration_hours').on 'change', ->
      hours = parseInt $("#reservation_duration_hours").val()
      minutes = parseInt $("#reservation_duration_minutes").val()
      setDurationSlider hours, minutes

    $('#reservation_duration_minutes').on 'change', ->
      hours = parseInt $("#reservation_duration_hours").val()
      minutes = parseInt $("#reservation_duration_minutes").val()
      setDurationSlider hours, minutes

    # Slideren i formularen ændres
    $("#reservation_duration_slider").on "change", ->
      duration = parseInt $(@).attr('data-slider')
      setDurationFields duration