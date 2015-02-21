if (Meteor.isClient) {
    /*
     * Function to calculate the wiki's equation
     */
    function equation(x, c, t) {
        return 5 * t * c * (0.2969 * Math.sqrt(x / c) - 0.1260 * (x / c) - 0.3516 * Math.pow(x / c, 2) + 0.2843 * Math.pow(x / c, 3) - 0.1015 * Math.pow(x / c, 4));
    }

    /*
     * Function to draw the area chart
     */
    function builtArea(config) {
        var y = new Array();

        for (var x = 0; x < config.c; x += 0.01) {
            //TODO - tilt it somehow
            //tried tilts
            //            val = equation(x, 10, 1) - 5 * x / 10;
            //            y.push([x,
            //                val, -val - 10 * x / 10
            //                ]);
            //            xp = x * Math.cos(config.angle) - val * Math.sin(config.angle);
            //            valp = x * Math.sin(config.angle) + val * Math.cos(config.angle);

            val = equation(x, config.c, config.t);
            y.push([x,
            val, -val]);
        }

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
                pointFormat: '{point.y:,.3f} {point.x:,.3f}'
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
            series: [{
                data: y,
                showInLegend: false
        }]
        });
    }

    /*
     * Call the function to built the chart when the template is rendered
     */
    Template.groupProjectWingDrawer.rendered = function () {
        var _angle = 45;
        var _c = 15;
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