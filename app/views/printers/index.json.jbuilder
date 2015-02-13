json.array!(@printers) do |printer|
  json.extract! printer, :id, :name
  json.url printer_url(printer, format: :json)
end
