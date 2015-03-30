$ ->
  $("#new_reservation").on("ajax:success", (e, data, status, xhr) ->
    $('#show_this').foundation 'reveal', 'close'
    responseObject = $.parseJSON(xhr.responseText)
    console.log responseObject

    # indsæt en ny reservation her

  ).on "ajax:error", (e, xhr, status, error) ->
    responseObject = $.parseJSON(xhr.responseText)
    $("#starts_at_error").remove()
    $("#ends_at_error").remove()

    if responseObject["starts_at"]

      $("#reservation_starts_at_date").addClass("error").parent().find("label").addClass("error")
      $("#reservation_starts_at_time").addClass("error").parent().find("label").addClass("error")
      
      $("<small class='error' id='starts_at_error'>").html(responseObject["starts_at"]).insertAfter("#reservation_starts_at_time").hide().slideDown()
    if responseObject["ends_at"]

      # $("#reservation_duration_hours").addClass("error").parent().find("label").addClass("error")
      # $("#reservation_duration_minutes").addClass("error").parent().find("label").addClass("error")
      
      $("<small class='error' id='ends_at_error'>").html(responseObject["ends_at"]).appendTo("#duration_row").hide().slideDown()
      #$("#reservation_duration_minutes").parent().parent().parent().parent().append("juuhuuu")

      console.log responseObject["ends_at"]
    
    
    #$("#new_reservation").append xhr.responseText