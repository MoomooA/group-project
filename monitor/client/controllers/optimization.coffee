Template.optimization.helpers
  newOptimization: () ->
    !Session.get('optimization')?
  currentOptimization: () ->
    Optimizations.findOne(Session.get('optimization'))
  iterations: () ->
    Iterations.find({optimizationId: Session.get('optimization')}, {sort:[["counter", "desc"]]}).fetch()
  currentIteration: () ->
    optimization = Optimizations.findOne(Session.get('optimization'))
    if optimization? and optimization.finished
      Iterations.findOne({$and: [{optimizationId: optimization._id}, {value: optimization.max}]})
    else
      Iterations.findOne({optimizationId: optimization._id}, {sort:[["counter", "desc"]]})

graph = null

### TODO update canvas
Tracker.autorun () ->
  optimization = Optimizations.findOne(Session.get('optimization'))
  iteration = null
  if optimization? and optimization.finished
    iteration = Iterations.findOne({$and: [{optimizationId: optimization._id}, {value: optimization.max}]})
  else
    iteration = Iterations.findOne({optimizationId: optimization._id}, {$sort:[["counter", "desc"]]})
###

###Tracker.autorun () ->
  if graph?
    console.log Iterations.find({optimizationId: Session.get('optimization')}, {sort:[["counter", "desc"]]}).map((iteration) -> return [iteration.counter, iteration.value])
    graph.setData(Iterations.find({optimizationId: Session.get('optimization')}, {sort:[["counter", "desc"]]}).map((iteration) -> return [iteration.counter, iteration.value]))
    graph.draw()

Template.graph.rendered = () ->
  graph = $.plot($(".graph"), Iterations.find({optimizationId: Session.get('optimization')}, {sort:[["counter", "desc"]]}).map((iteration) -> return [iteration.counter, iteration.value]))
###

drawGraph = () ->
  values =  Iterations.find({optimizationId: Session.get('optimization')}, {sort:[["counter", "asc"]]}).map((iteration) -> return if isNaN(iteration.value) then 0 else iteration.value)
  $('#canvas-graph').highcharts
    chart:
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false
    plotOptions:
      series:
        color: '#37BC9B'
    title:
      text: null
    yAxis:
      title: 'L / D'
    credits:
      enabled: false
    legend:
      enabled: false
    series: [
      name: 'L / D',
      data: values
    ]

Template.graph.rendered =  () ->
  @autorun () ->
    drawGraph()


Template.new_optimization.events
  'submit .form': (e, t) ->
    e.preventDefault()
    button = utils.initButton t

    tolerance = t.find('#tolerance').value.trim()
    step = t.find('#step').value.trim()
    _t = t.find('#t').value.trim()
    c = t.find('#c').value.trim()
    theta = t.find('#theta').value.trim()

    Optimizations.insert(
      userId: Meteor.userId()
      createdAt: new Date()
      updatedAt: new Date()
      finished: false
      tolerance: tolerance
      defaultStep: step
      max: 0
    , (err, optimizationId) ->
      if err?
        classie.removeClass(button, 'loading')
        classie.addClass(button, 'error')
        setTimeout(
          () -> classie.removeClass(button, 'error' )
        , 1200 )
        console.log(err)
        return
      Meteor.call('launchOptimization', optimizationId, c, _t, theta, (err, result) ->
        classie.removeClass(button, 'loading')
        if err?
          classie.addClass(button, 'error')
          setTimeout(
            () -> classie.removeClass(button, 'error' )
          , 1200 )
          console.log(err)
          return
        Session.set('optimization', optimizationId)
      )
    )
    return false

Template.optimization.events
  'click #iterate': (e, t) ->
    e.preventDefault()
    button = utils.initButton t

    nbIterations = 100

    Meteor.call('optimize', Session.get('optimization'), nbIterations, (err, result) ->
      classie.removeClass(button, 'loading')
      if err?
        classie.addClass(button, 'error')
        setTimeout(
          () -> classie.removeClass(button, 'error' )
        , 1200 )
        console.log(err)
        return
    )

    return false
