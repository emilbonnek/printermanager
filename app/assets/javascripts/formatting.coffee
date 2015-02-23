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