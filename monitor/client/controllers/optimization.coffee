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

drawGraph = () ->
  iterations = Iterations.find({optimizationId: Session.get('optimization')}, {sort:[["counter", "asc"]]})
  values =  iterations.map (iteration) ->
    return if isNaN(iteration.value) then 0 else parseFloat(iteration.value)
  cValues =  iterations.map (iteration) ->
    return {
      y: parseFloat(iteration.parameters[0])
      marker:
        enabled: false
        states:
          hover:
            enabled: false
    }
  tValues =  iterations.map (iteration) ->
    return {
      y: parseFloat(iteration.parameters[1])
      marker:
        enabled: false
        states:
          hover:
            enabled: false
    }
  thetaValues =  iterations.map (iteration) ->
    return {
      y: parseFloat(iteration.parameters[2])
      marker:
        enabled: false
        states:
          hover:
            enabled: false
    }
  $('#canvas-graph').highcharts
    chart:
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false
    title:
      text: null
    yAxis:
      title: 'L / D'
      min: 0
    credits:
      enabled: false
    legend:
      enabled: false
    tooltip:
      shared: true
    series: [
      {name: 'L / D', data: values, color: 'currentColor'},
      {name: 'c', data: cValues, color: '#FFF'},
      {name: 't', data: tValues, color: '#FFF'},
      {name: 'theta', data: thetaValues, color: '#FFF'}
    ]

Template.graph.rendered =  () ->
  $("#canvas-graph").height($(window).height() - $("#canvas-graph").offset().top)
  @autorun () ->
    drawGraph()


Template.new_optimization.events
  'submit .form': (e, t) ->
    e.preventDefault()
    button = new ProgressButton "button"
    utils.initFormErrors t

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
        button.error()
        console.log(err)
        return
      Meteor.call('launchOptimization', optimizationId, c, _t, theta, (err, result) ->
        if err?
          button.error()
          console.log(err)
          return
        Session.set('optimization', optimizationId)
      )
    )
    return false

Template.optimization.events
  'click #iterate': (e, t) ->
    e.preventDefault()
    button = utils.initButton t, "iterate"

    nbIterations = Meteor.user().profile.nbIterations || 10

    Meteor.call('optimize', Session.get('optimization'), nbIterations, (err, result) ->
      if err?
        button.error()
        console.log(err)
        return
    )

    return false
