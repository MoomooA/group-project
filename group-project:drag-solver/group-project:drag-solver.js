DragSolver = (function () {
  function DragSolver(_dragCoefficient) {
    this.dragCoefficient = _dragCoefficient;
  }

  DragSolver.prototype.solve = function (c, t, theta, C, rho, v, L) {
    // 1.1019 * t * t is the radius at the front of the airfoil. I'm approximating the length of what is not on the regular triangle by it
    var A = L * Math.cos(theta) * c + 1.1019 * t * t;
    return 1 / 2 * C * rho * v * v * A;
  };

  DragSolver.prototype.reducedSolve = function (c, t, theta) {
    return this.solve(c, t, theta, this.dragCoefficient, 1, 1, 1);
  };

  return DragSolver;

})();
