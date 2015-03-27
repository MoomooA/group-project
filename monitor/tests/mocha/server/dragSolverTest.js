if (!(typeof MochaWeb === 'undefined')){
  MochaWeb.testOnly(function(){
    describe("Drag Solver", function(){
      chai.should();
      var solver = new DragSolver(1);
      for (var i = 0; i<200;i++) {
        it("should exist" + i, function(){
          solver.should.be.a('object');
        });
      }
      it("should compute the lift", function(){
        solver.reducedSolve(1, 1, 1).should.equal(0.5662360870822405);
        solver.reducedSolve(1, 1, 1).should.equal(solver.solve(1, 1, 1, 1, 1, 1, 1));
      });
    });
  });
}
