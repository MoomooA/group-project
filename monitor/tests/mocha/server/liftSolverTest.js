if (!(typeof MochaWeb === 'undefined')){
  MochaWeb.testOnly(function(){
    describe("Lift Solver", function(){
      chai.should();
      var solver = new LiftSolver();
      it("should exist", function(){
        solver.should.be.a('object');
      });
      it("should compute the lift", function(){
        solver.reducedSolve(1,1).should.equal(Math.PI);
      });
    });
  });
}
