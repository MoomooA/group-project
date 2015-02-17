UI.registerHelper('prettifyDate', (date) ->
  if !date?
    ''
  else
    timestamp = new Date(date)
    now = new Date().getTime()
    diffEnJour = ((now - timestamp.getTime()) / 86400000).toFixed(0)
    if diffEnJour < 1
      "Aujourd'hui"
    else if diffEnJour < 2
      "Hier"
    else if diffEnJour < 8
      "Il y a " + diffEnJour + " jours."
    else
      "Le " + timestamp.toLocaleDateString('fr')
)
