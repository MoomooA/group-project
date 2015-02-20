Future = Npm.require('fibers/future')

Meteor.methods
  checkAstral: (username, password) ->
    future = new Future()
    (new Auth()).authenticate(username, password, (err, result) ->
      if err?
        future.throw(new Meteor.Error("error", err))
        return
      if !result
        future.throw(new Meteor.Error("error", "Wrong ID or password"))
        return
      id = Accounts.createUser
        username: username
        password: password
      future.return id
    )
    future.wait()

  deleteOptimization: (optimizationId) ->
    optimization = Optimizations.findOne(optimizationId)
    optimizationRestricted = Optimizations.findOne({$and: [_id: optimizationId, userId: @userId]})
    if !optimization?
      Logs.insert
        userId: @userId
        type: "error"
        message: "Unsuccessful attemp to delete the optimization #{optimizationId} : Not found"
        timestamp: new Date()
      throw new Meteor.Error("no-optimization", "No optimization found");
    else if !optimizationRestricted?
      Logs.insert
        userId: optimization.userId
        type: "security"
        message: "#{@connection.clientAddress} tried to delete your optimization #{optimizationId}"
        timestamp: new Date()
      throw new Meteor.Error("no-right", "You do not have the right to delete this.");

    Logs.insert
      userId: @userId
      type: "delete-optimization"
      message: "Delete the optimization #{optimizationId}"
      timestamp: new Date()
    Optimizations.remove(optimizationId)
    Iterations.remove({optimizationId: optimizationId})

  launchOptimization: (optimizationId, c, t, theta) ->
    optimization = Optimizations.findOne(optimizationId)
    optimizationRestricted = Optimizations.findOne({$and: [_id: optimizationId, userId: @userId]})
    if !optimization?
      Logs.insert
        userId: @userId
        type: "error"
        message: "Unsuccessful attemp to create the optimization #{optimizationId}"
        timestamp: new Date()
      throw new Meteor.Error("no-optimization", "No optimization found");
    else if !optimizationRestricted?
      Logs.insert
        userId: optimization.userId
        type: "security"
        message: "#{@connection.clientAddress} tried to create an optimization #{optimizationId} for you"
        timestamp: new Date()
      throw new Meteor.Error("no-right", "You do not have the right to delete this.");

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
      counter: 0
    Optimizations.update(optimizationId, {$set: {max: L/D, updatedAt: new Date()}})
    Logs.insert
      userId: @userId
      type: "create-optimization"
      message: "Creation of the optimization #{optimizationId}"
      timestamp: new Date()

  optimize: (optimizationId, nbIterations) ->
    nbIterations = nbIterations || 1000
    #TODO find drag coefficient
    dragSolver = new DragSolver(1)
    liftSolver = new LiftSolver()
    nbIt = Iterations.find({optimizationId: optimizationId}).count()
    iterations = Iterations.find({optimizationId: optimizationId}, {sort:[["counter", "desc"]], limit: 2}).fetch()
    optimizer = null
    c = null

    optimization = Optimizations.findOne(optimizationId)
    optimizationRestricted = Optimizations.findOne({$and: [_id: optimizationId, userId: @userId]})
    if !optimization?
      Logs.insert
        userId: @userId
        type: "error"
        message: "Unsuccessful attemp to create the optimization #{optimizationId}"
        timestamp: new Date()
      throw new Meteor.Error("no-optimization", "No optimization found");
    else if !optimizationRestricted?
      Logs.insert
        userId: optimization.userId
        type: "security"
        message: "#{@connection.clientAddress} tried to create an optimization #{optimizationId} for you"
        timestamp: new Date()
      throw new Meteor.Error("no-right", "You do not have the right to delete this.");
    else if !iterations.length? or iterations.length is 0
      Logs.insert
        userId: @userId
        type: "error"
        message: "Unsuccessful attemp to iterate the optimization #{optimizationId}"
        timestamp: new Date()
      throw new Meteor.Error("no-iteration", "No iteration found");
    else if iterations.length is 1
      parameters = iterations[0].parameters
      c = parameters.shift() # we don't tweak the c
      optimizer = new Optimizer(parameters, optimization.tolerance, optimization.defaultStep)
    else
      parameters0 = iterations[0].parameters
      c = parameters0.shift() # we don't tweak the c
      parameters1 = iterations[1].parameters
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
        counter: nbIt + i

      i++

    Logs.insert
      userId: @userId
      type: "iterations"
      message: "Iterate #{nbIterations} times the optimization #{optimizationId}"
      timestamp: new Date()

    if Optimizations.findOne(optimizationId).max is startingValue
      Logs.insert
        userId: @userId
        type: "finished"
        message: "Finished the optimization #{optimizationId}"
        timestamp: new Date()
      Optimizations.update(optimizationId, {$set: {finished: true}})

    return "finished"

Accounts.config
  forbidClientAccountCreation: true
