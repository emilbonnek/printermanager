json.array!(@reservations) do |reservation|
  json.extract! reservation, :id
  json.url printer_reservation_url(reservation, format: :json)
end
