search = ->
  $.getJSON $("#search_users").attr("action"), $("#search_users").serialize(), (data) ->

    $("#search_results").empty()

    items = []
    if data.length is 0 && !!$("#search_users").find("input[type=search]").val()
      items.push "<li>Ingen resultater</li>"
    else
      $.each data, (key, val) ->
        console.log val.first_name
        items.push "<li><a data-reveal-id='show_user' data-reveal-ajax='true' href='users/"+val.id+"'>"+val.first_name+" "+val.last_name+"</a></li>"

    $("#search_results").append items.join("")

$ ->
  search_field = $("#search_users").find("input[type=search]")
  search_field.bind "keyup search", -> search()