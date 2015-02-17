# Funktion der bruges til at give en bedre bruger oplevelse når man opretter en reservation
updateDuration = () ->
  hours = parseInt $("#reservation_duration_hours").val()
  minutes = parseInt $("#reservation_duration_minutes").val()

  duration = hours*60+minutes
  if duration <= 0
    duration = 0
  else if duration >= (12*60)
    duration = (12*60)

  $('#reservation_duration_slider').foundation('slider', 'set_value', duration)
  $('#reservation_duration_hours').val(duration//60)
  $('#reservation_duration_minutes').val(duration%%60)
$ ->

  # Vis en formular til at oprette en ny reservation
  $(document).on 'opened', '#new_reservation[data-reveal]', ->

    # Tallene i formularen ændres
    $('#reservation_duration_hours').on 'change', ->
      updateDuration()
    $('#reservation_duration_minutes').on 'change', ->
      updateDuration()

    # Slideren i formularen ændres
    $("#reservation_duration_slider").on "change", ->
      duration = parseInt $(@).attr('data-slider')
      $("#reservation_duration_hours").val(duration//60)
      $("#reservation_duration_minutes").val(duration%%60)