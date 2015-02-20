Template.logs.helpers
  logs: () ->
    Logs.find({}, {limit: 100, sort: [["timestamp", "desc"]]})
