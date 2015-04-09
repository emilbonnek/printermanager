<% if @printer.active %>
  $("#edit_printer_<%= @printer.id %>").parent().prependTo("#active-printers")
<% else %>
  $("#edit_printer_<%= @printer.id %>").parent().prependTo("#inactive-printers")
<% end %>