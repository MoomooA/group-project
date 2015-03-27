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
      Iterations.findOne({optimizationId: Session.get('optimization')}, {sort:[["counter", "desc"]]})

wingEquation = (x, c, t) ->
  5 * t * c * (0.2969 * Math.sqrt(x / c) - 0.1260 * (x / c) - 0.3516 * Math.pow(x / c, 2) + 0.2843 * Math.pow(x / c, 3) - 0.1015 * Math.pow(x / c, 4))

drawDraw = () ->
  optimization = Optimizations.findOne(Session.get('optimization'))
  if optimization? and optimization.finished
    iteration = Iterations.findOne({$and: [{optimizationId: optimization._id}, {value: optimization.max}]})
  else
    iteration = Iterations.findOne({optimizationId: Session.get('optimization')}, {sort:[["counter", "desc"]]})

  values = []
  if iteration? and iteration.parameters? and iteration.parameters.length is 3
    x = 0
    while x < iteration.parameters[0]
      y = wingEquation(x, iteration.parameters[0], iteration.parameters[1])
      values.push
        x: iteration.parameters[0] - x
        y: parseFloat(y)
      values.unshift
        x: iteration.parameters[0] - x
        y: -y
      x += 0.01

    values.push
      x: 0
      y: 0
    values.unshift
      x: 0
      y: 0

    values = values.map (value) ->
      oldX = value.x - iteration.parameters[0]/2
      return {
        x: (oldX * Math.cos(-iteration.parameters[2]) + value.y * Math.sin(-iteration.parameters[2])) + iteration.parameters[0]/2
        y: value.y * Math.cos(-iteration.parameters[2]) - oldX * Math.sin(-iteration.parameters[2])
        marker:
          enabled: false
          states:
            hover:
              enabled: false
      }

    $('#canvas-draw').highcharts
      chart:
        type: 'area'
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false
      title:
        text: null
      yAxis:
        title: ''
      credits:
        enabled: false
      legend:
        enabled: false
      tooltip:
        enabled: false
      series: [
        {name: 'wing', data: values, color: 'currentColor'}
      ]

Template.draw.rendered =  () ->
  $("#canvas-draw").height($(window).height() - $("#canvas-draw").offset().top)
  @autorun () ->
    drawDraw()

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

    tolerance = parseFloat t.find('#tolerance').value.trim()
    step = parseFloat t.find('#step').value.trim()
    _t = parseFloat t.find('#t').value.trim()
    c = parseFloat t.find('#c').value.trim()
    theta = parseFloat t.find('#theta').value.trim()

    if isNaN(tolerance) or isNaN(step) or isNaN(_t) or isNaN(c) or isNaN(theta)
      button.error()
      console.log("wrong format")
      return

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
    button = new ProgressButton "iterate"
    utils.initFormErrors t

    nbIterations = Meteor.user().profile.nbIterations || 10

    Meteor.call('optimize', Session.get('optimization'), nbIterations, (err, result) ->
      if err?
        console.log(err)
        button.error()
        return
      button.notLoading()
    )

    return false
