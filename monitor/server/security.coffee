Meteor.methods
  deleteOptimization: (optimizationId) ->
    Optimizations.remove(optimizationId)
    Iterations.remove({optimizationId: optimizationId})

  launchOptimization: (optimizationId, c, t, theta) ->
    #TODO find drag coefficient
    D = (new DragSolver(1)).reducedSolve(c, t, theta)
    L = (new LiftSolver()).reducedSolve(c, theta)
    Iterations.insert
      D: D
      L: L
      value: L/D
      parameters: [c, t, theta]
      variation: null
      step: null
      optimizationId: optimizationId
      timestamp: new Date()
    Optimizations.update(optimizationId, {$set: {max: L/D, updatedAt: new Date()}})

  optimize: (optimizationId, nbIterations) ->
    nbIterations = nbIterations || 1000
    #TODO find drag coefficient
    dragSolver = new DragSolver(1)
    liftSolver = new LiftSolver()
    optimization = Optimizations.findOne(optimizationId)
    iterations = Iterations.find({optimizationId: optimizationId}, {sort:[["updatedAt", "desc"]], limit: 2}).fetch()
    optimizer = null
    c = null

    if !optimization?
      throw new Meteor.Error("no-optimization", "No optimization found");
    else if !iterations.length? or iterations.length is 0
      throw new Meteor.Error("no-iteration", "No iteration found");
    else if iterations.length is 1
      parameters = iterations[0].parameters
      c = parameters.shift() # we don't tweak the c
      optimizer = new Optimizer(parameters, optimization.tolerance, optimization.defaultStep)
    else
      parameters0 = iterations[0].parameters
      c = parameters0.shift() # we don't tweak the c
      parameters1 = iterations[0].parameters
      parameters1.shift() # we don't tweak the c
      optimizer = new Optimizer(parameters0, optimization.tolerance, optimization.defaultStep, parameters1, iterations[0].variation, iterations[1].variation, iterations[0].step, iterations[1].L / iterations[1].D)

    startingValue = optimization.max
    currentValue = iterations[0].L / iterations[0].D

    i = 0
    while i < nbIterations
      {parameters, variation, step} = optimizer.optimize(currentValue)
      currentParameters = [c].concat(parameters) # add the c
      L = liftSolver.reducedSolve(currentParameters[0], currentParameters[2])
      D = dragSolver.reducedSolve(currentParameters[0], currentParameters[1], currentParameters[2])

      if L / D > currentValue
        Optimizations.update(optimizationId, {$set: {updatedAt: new Date(), max: L / D}})

      currentValue = L / D
      Iterations.insert
        D: D
        L: L
        value: currentValue
        parameters: currentParameters
        variation: variation
        step: step
        optimizationId: optimizationId
        timestamp: new Date()

      i++

    if Optimizations.findOne(optimizationId).max is startingValue
      Optimizations.update(optimizationId, {$set: {finished: true}})

    return "finished"

Accounts.config
  forbidClientAccountCreation: true
