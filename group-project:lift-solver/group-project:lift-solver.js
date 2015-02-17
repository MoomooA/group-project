LiftSolver = (function () {
  function LiftSolver() {}

  LiftSolver.prototype.solve = function (c, t, theta, rho, v, L) {
    var A = L * c;
    var C = 2 * Math.PI * (theta % (2 * Math.PI));
    return 1 / 2 * C * rho * v * v * A;
  };

  LiftSolver.prototype.reducedSolve = function (c, theta) {
    return this.solve(c, 1, theta, 1, 1, 1);
  };

  return LiftSolver;

})();
