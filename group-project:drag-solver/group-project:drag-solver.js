DragSolver = (function () {
  function DragSolver(_dragCoefficient) {
    this.dragCoefficient = _dragCoefficient;
  }

  DragSolver.prototype.solve = function (c, t, theta, C, rho, v, L) {
    // TODO find A
    var A = L * c;
    return 1 / 2 * C * rho * v * v * A;
  };

  DragSolver.prototype.reducedSolve = function (c, t, theta) {
    return this.solve(c, t, theta, this.dragCoefficient, 1, 1, 1);
  };

  return DragSolver;

})();
