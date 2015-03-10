if (!(typeof MochaWeb === 'undefined')){
  MochaWeb.testOnly(function(){
    describe("Astral Authentication", function(){
      var should = chai.should();
      var auth = new Auth();
      it("should exist", function(){
        auth.should.be.a('object');
      });
      it("should connect to astral", function(){
        auth.authenticate("", "", function(err, result) {
          should.not.exist(err);
        });
      });
      it("should not allow unidentified user", function(){
        auth.authenticate("", "", function(err, result) {
          result.should.equal(false);
        });
        auth.authenticate("s219924", "", function(err, result) {
          result.should.equal(false);
        });
      });
      /*it("should allow identified user", function(){
        auth.authenticate("s219924", "********", function(err, result) {
          result.should.equal(true);
        });
      });*/
    });
  });
}
