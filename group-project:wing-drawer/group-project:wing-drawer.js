if (Meteor.isClient) {
    /*
     * Function to calculate the wiki's equation
     */
    function equation(x, c, t) {
        return 5 * t * c * (0.2969 * Math.sqrt(x / c) - 0.1260 * (x / c) - 0.3516 * Math.pow(x / c, 2) + 0.2843 * Math.pow(x / c, 3) - 0.1015 * Math.pow(x / c, 4));
    }

    function rounder(v, p) {
        var tens = Math.pow(10, p);
        return (Math.round(v * tens) / tens);
    }

    /*
     * Function to draw the area chart
     */
    function builtArea(config) {
        var y = new Array();
        var yp = new Array();
        var ang = config.angle * Math.PI / 180;
        for (var x = 0; x < config.c; x += 0.01) {
            val = equation(x, config.c, config.t);
            yp.push([x, val, -val]);
        }
        var x1, x2, val1, val2;
        yp.forEach(function (entry) {

            //            x1 = entry[0] * Math.cos(ang) - entry[1] * Math.sin(ang);
            x1 = entry[0];
            val1 = x1 * Math.sin(ang) + entry[1] * Math.cos(ang);

            //            x2 = entry[0] * Math.cos(ang) - entry[2] * Math.sin(ang);
            x2 = entry[0];
            val2 = x2 * Math.sin(ang) + entry[2] * Math.cos(ang);
            y.push([entry[0], val1, val2]);
        });

        $('#container-area').highcharts({

            chart: {
                type: 'arearange',
                zoomType: 'x'
            },

            title: {
                text: 'The wing drawing'
            },

            credits: {
                enabled: false
            },

            xAxis: {
                allowDecimals: true,
                title: {
                    text: 'X axis'
                },
                labels: {
                    formatter: function () {
                        return this.value;
                    }
                }
            },

            yAxis: {
                allowDecimals: true,
                title: {
                    text: 'Y axis'
                },
                labels: {
                    formatter: function () {
                        return this.value;
                    }
                }
            },

            tooltip: {
                formatter: function () {
                        //                        console.log("my object: %o", this);
                        return 'x: ' + rounder(this.point.low, 3) + '<br\>y: [' + rounder(this.point.high, 3) + ' ' + rounder(this.point.x, 3) + ']';
                    }
                    //                pointFormat: '{point.low:,.3f} {point.high:,.3f}'
            },

            plotOptions: {
                area: {
                    pointStart: 0,
                    marker: {
                        enabled: false,
                        symbol: 'circle',
                        radius: 2,
                        states: {
                            hover: {
                                enabled: true
                            }
                        }
                    }
                }
            },
            series: [
                {
                    data: y,
                    showInLegend: false
                }
            ]
        });
    }

    /*
     * Call the function to built the chart when the template is rendered
     */
    Template.groupProjectWingDrawer.rendered = function () {
        var _angle = 10;
        var _c = 10;
        var _t = 1;
        builtArea({
            c: _c,
            t: _t,
            angle: _angle
        });
    }
}

if (Meteor.isServer) {
    Meteor.startup(function () {
        // code to run on server at startup
    });
}