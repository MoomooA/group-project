function Graph(config) {
    // user defined properties
    this.canvas = document.getElementById(config.canvasId);
    this.minX = config.minX;
    this.minY = config.minY;
    this.maxX = config.maxX;
    this.maxY = config.maxY;
    this.unitsPerTickX = config.unitsPerTickX;
    this.unitsPerTickY = config.unitsPerTickY;
    this.parT = config.parT;
    this.parC = config.parC;

    // constants
    this.axisColor = '#aaa';
    this.font = '8pt Calibri';
    this.tickSize = 20;

    // relationships
    this.context = this.canvas.getContext('2d');
    this.rangeX = this.maxX - this.minX;
    this.rangeY = this.maxY - this.minY;
    this.unitX = this.canvas.width / this.rangeX;
    this.unitY = this.canvas.height / this.rangeY;
    this.centerY = Math.round(Math.abs(this.minY / this.rangeY) * this.canvas.height);
    this.centerX = Math.round(Math.abs(this.minX / this.rangeX) * this.canvas.width);
    this.iteration = (this.parC - this.minX) / 1000;
    this.scaleX = this.canvas.width / this.rangeX;
    this.scaleY = this.canvas.height / this.rangeY;

    // draw x and y axis
}

Graph.prototype.drawXAxis = function () {
    var context = this.context,
        xPosIncrement = this.unitsPerTickX * this.unitX,
        xPos,
        unit;
    context.save();
    context.beginPath();
    context.moveTo(0, this.centerY);
    context.lineTo(this.canvas.width, this.centerY);
    context.strokeStyle = this.axisColor;
    context.lineWidth = 2;
    context.stroke();

    // draw tick marks

    context.font = this.font;
    context.textAlign = 'center';
    context.textBaseline = 'top';

    // draw left tick marks
    xPos = this.centerX - xPosIncrement;
    unit = -1 * this.unitsPerTickX;
    while (xPos > 0) {
        context.moveTo(xPos, this.centerY - this.tickSize / 2);
        context.lineTo(xPos, this.centerY + this.tickSize / 2);
        context.stroke();
        context.fillText(unit, xPos, this.centerY + this.tickSize / 2 + 3);
        unit -= this.unitsPerTickX;
        xPos = Math.round(xPos - xPosIncrement);
    }

    // draw right tick marks
    xPos = this.centerX + xPosIncrement;
    unit = this.unitsPerTickX;
    while (xPos < this.canvas.width) {
        context.moveTo(xPos, this.centerY - this.tickSize / 2);
        context.lineTo(xPos, this.centerY + this.tickSize / 2);
        context.stroke();
        context.fillText(unit, xPos, this.centerY + this.tickSize / 2 + 3);
        unit += this.unitsPerTickX;
        xPos = Math.round(xPos + xPosIncrement);
    }
    context.restore();
};

Graph.prototype.drawYAxis = function () {
    var context = this.context,
        yPosIncrement = this.unitsPerTickY * this.unitY,
        yPos,
        unit;
    context.save();
    context.beginPath();
    context.moveTo(this.centerX, 0);
    context.lineTo(this.centerX, this.canvas.height);
    context.strokeStyle = this.axisColor;
    context.lineWidth = 2;
    context.stroke();

    //     draw tick marks

    context.font = this.font;
    context.textAlign = 'right';
    context.textBaseline = 'middle';

    // draw top tick marks
    yPos = this.centerY - yPosIncrement;
    unit = this.unitsPerTickY;
    while (yPos > 0) {
        context.moveTo(this.centerX - this.tickSize / 4, yPos);
        context.lineTo(this.centerX + this.tickSize / 4, yPos);
        context.stroke();
        context.fillText(unit, this.centerX + this.tickSize - 3, yPos);
        unit += this.unitsPerTickY;
        yPos = Math.round(yPos - yPosIncrement);
    }

    // draw bottom tick marks
    yPos = this.centerY + yPosIncrement;
    unit = -1 * this.unitsPerTickY;
    while (yPos < this.canvas.height) {
        context.moveTo(this.centerX - this.tickSize / 4, yPos);
        context.lineTo(this.centerX + this.tickSize / 4, yPos);
        context.stroke();
        context.fillText(unit, this.centerX + this.tickSize - 3, yPos);
        unit -= this.unitsPerTickY;
        yPos = Math.round(yPos + yPosIncrement);
    }
    context.restore();
};

Graph.prototype.drawEquation = function (equation, color, thickness) {
    var context = this.context,
        x,
        y;
    context.save();
    context.save();
    this.transformContext();

    context.beginPath();
    //context.moveTo(this.minX, equation(this.minX));

    for (x = this.minX; x < this.parC; x += this.iteration) {
        y = equation(x, this.parC, this.parT);
        context.lineTo(x, y);
        context.lineTo(x, -y);

    }

    context.restore();
    context.lineJoin = 'round';
    context.lineWidth = thickness;
    context.strokeStyle = color;
    context.stroke();
    context.restore();
};

Graph.prototype.transformContext = function () {
    var context = this.context;

    // move context to center of canvas
    this.context.translate(this.centerX, this.centerY);

    /*
     * stretch grid to fit the canvas window, and
     * invert the y scale so that that increments
     * as you move upwards
     */
    context.scale(this.scaleX, -this.scaleY);
};


//Equation from http://en.wikipedia.org/wiki/NACA_airfoil#Equation_for_a_symmetrical_4-digit_NACA_airfoil
function equation(x, c, t) {
    return 5 * t * c * (0.2969 * Math.sqrt(x / c) - 0.1260 * (x / c) - 0.3516 * Math.pow(x / c, 2) + 0.2843 * Math.pow(x / c, 3) - 0.1015 * Math.pow(x / c, 4));
}


//Function to fill the canvas with the image of the wing
function drawWing() {
    var c = document.getElementById('parC').value,
        t = document.getElementById('parT').value,
        angle = document.getElementById('parAngle').value,
        canvs = document.getElementById('myCanvas'),
        contx = canvs.getContext('2d'),
        myGraph;

    //Default values
    c = c || 10.0;
    t = t || 1.0;
    angle = angle || 0.0;

    //May be deleted after, now just to see the angle
    document.getElementById('ang').innerHTML = 'Angle ' + angle;
    //Clear the canvas
    contx.clearRect(0, 0, canvs.width, canvs.height);
    //Reset previous changes of the context
    contx.resetTransform();

    myGraph = new Graph({
        canvasId: 'myCanvas',
        minX: -0.01,
        minY: -c * t,
        maxX: 1.1 * c,
        maxY: c * t,
        unitsPerTickX: 0.5,
        unitsPerTickY: 1.0,
        parT: t,
        parC: c
    });

    //Transforming the 'rotating' point to the middle of the canvas' heigh
    contx.translate(0, canvs.height / 2);
    contx.rotate(angle * Math.PI / 180.0);
    //Transforming it back
    contx.translate(0, -canvs.height / 2);

    //Actually draw a new wing
    myGraph.drawEquation(function (x, c, t) {
        return equation(x, c, t);
    }, 'lightblue', 1.5);
    contx.resetTransform();

    //Draw the axis after the wing so they will be visible
    myGraph.drawXAxis();
    myGraph.drawYAxis();

}

//Draw the wing after the window finishes loading
window.onload = function () {
    drawWing();
};

//TODO Add the scaling to the canvas so the wing "won't escape"
//TODO maybe add the scaling to the X/Y axis for the user