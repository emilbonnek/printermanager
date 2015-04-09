$('#new_reservation').foundation('reveal', 'close')
$("#bookings_table").find("#<%= @reservation.printer.id %>").append("<%= j render(@reservation) %>")
