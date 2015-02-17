var Variation = {
  Plus: 1,
  Minus: -1,
  Undefined: 0
};

Optimizer = (function () {
  function Optimizer(_startingParameters, _tolerance, _step, _previousParameters, _currentVariation, _previousVariation, _currentStep, _previousValue) {
    if (!this._checkParameters(_startingParameters)) {
      return new Error("The parameters are not an array.");
    }
    this.tolerance = _tolerance || 0.01;
    this.currentParameters = _startingParameters;
    this.tweekedParameter = this._findTweekedParameter(this.currentParameters, _previousParameters || _startingParameters);
    this.currentVariation = _currentVariation || Variation.Undefined;
    this.previousVariation = _previousVariation || Variation.Undefined;
    this.defaultStep = _step || 1;
    this.step = _currentStep || this.defaultStep;
    this.previousValue = _previousValue;
  }

  Optimizer.prototype._checkParameters = function (parameters) {
    return typeof parameters === "object" && parameters !== null && parameters.length && parameters.length !== 0;
  };

  Optimizer.prototype._findTweekedParameter = function (currentParameters, previousParameters) {
    for (var i = 0; i < currentParameters.length; i++) {
      if (currentParameters[i] !== previousParameters[i]) {
        return i;
      }
    }
    return -1;
  };

  Optimizer.prototype.optimize = function (currentValue) {

    var step = this.defaultStep;
    var variation = Variation.Plus;

    var parameterToTweekIndex = this.tweekedParameter;

    if (typeof currentValue === "undefined" || currentValue === null) {
      // we need the value
      return new Error("The value is missing.");
    }

    if (this.tweekedParameter === -1) {
      // if it's the first time, pick the first parameter and tweek it
      parameterToTweekIndex = 0;
    } else if (Math.abs(currentValue - this.previousValue) < this.tolerance) {
      // if we are under the tolerance for this parameter, go to the next one
      parameterToTweekIndex = (this.tweekedParameter + 1) % this.currentParameters.length;
    }

    if (parameterToTweekIndex === this.tweekedParameter) {
      step = this.step;
      if (currentValue < this.previousValue) { // we need to go back
        variation = -this.currentVariation;
        if (variation == this.previousVariation) { // if we are oscillating
          step = this.step / 2;
        }
      } else {
        variation = this.currentVariation;
        if (this.currentVariation !== this.previousVariation) { // if we are oscillating
          step = this.step / 2;
        }
      }
    }

    this.previousVariation = this.currentVariation;
    this.currentVariation = variation;
    this.step = step;
    this.tweekedParameter = parameterToTweekIndex;
    this.currentParameters[this.tweekedParameter] = this.currentParameters[this.tweekedParameter] + this.step * this.currentVariation;

    return {
      parameters : this.currentParameters,
      variation: this.currentVariation,
      step: this.step
    };

  };

  return Optimizer;

})();
