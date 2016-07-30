var express = require('express');
var bodyParser = require('body-parser');
var piblaster = require('pi-blaster.js');
var Updater = require('./UpdaterEvent');


//pins
// 11, 15, 18

var redPinNumber = 22;
var greenPinNumber = 17;
var bluePinNumber = 24;

var redIsOpen = 0;
var enableFade = false;
var enableStrobe = false;
var strobeOn = false;
var strobeDuration = 0.25;
var colorStep = 0.01;
var colorCtrl = 0;

var colorStep1 = 0.01;
var colorStep2 = 0.1;

var currentRed = 0;
var currentGreen = 0;
var currentBlue = 0;

turnOffAll();
var app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded( { extended: false } ));
app.set('port', process.env.PORT || 3000);

app.get ( '/heartBeat', function ( req, res ) {
	console.log ( "heartBeat" );
	res.send( "heartBeat" );
});

app.get ( '/currentColors', function ( req, res ) {
	console.log ( "currentColors" );
	res.send( { "data": { "red": currentRed, "green": currentGreen, "blue": currentBlue } } );
	//res.send( "currentColors" );
});

app.get ( '/allOn', function ( req, res ) {
	console.log ( "all on" );
	enableStrobe = false;
	enableFade = false;
	turnOnAll();
	res.send( "allOn" );
});

app.get ( '/allOff', function ( req, res ) {
	console.log ( "all off" );
	enableStrobe = false;
	enableFade = false;
	turnOffAll();
	res.send( "allOff" );
});

app.get ( '/redOn', function ( req, res ) {
	console.log ( "redOn" );
	enableStrobe = false;
	enableFade = false;
	setRed( 1 );
	res.send( "redOn" );
});

app.get ( '/redHalf', function ( req, res ) {
	console.log ( "redHalf" );
	enableStrobe = false;
	enableFade = false;
	setRed( 0.5 );
	res.send( "redHalf" );
});

app.get ( '/redOff', function ( req, res ) {
	console.log ( "redOff" );
	enableStrobe = false;
	enableFade = false;
	setRed( 0 );
	res.send( "redOff" );
});

app.post ( '/redValue/', function ( req, res ) {
	var value = parseFloat( req.body.value );
	console.log( "redValue: " + value );
	enableStrobe = false;
	enableFade = false;
	setRed( value );
	res.send( "redValue" );
});

app.get ( '/greenOn', function ( req, res ) {
	console.log ( "greenOn" );
	enableStrobe = false;
	enableFade = false;
	setGreen( 1 );
	res.send( "greenOn" );
});

app.get ( '/greenHalf', function ( req, res ) {
	console.log ( "greenHalf" );
	enableStrobe = false;
	enableFade = false;
	setGreen( 0.5 );
	res.send( "greenHalf" );
});

app.get ( '/greenOff', function ( req, res ) {
	console.log ( "greenOff" );
	enableStrobe = false;
	enableFade = false;
	setGreen( 0 );
	res.send( "greenOff" );
});

app.post ( '/greenValue/', function ( req, res ) {
	var value = parseFloat( req.body.value );
	console.log( "greenValue: " + value );
	enableStrobe = false;
	enableFade = false;
	setGreen( value );
	res.send( "greenValue" );
});

app.get ( '/blueOn', function ( req, res ) {
	console.log ( "blueOn" );
	enableStrobe = false;
	enableFade = false;
	setBlue( 1 );
	res.send( "blueOn" );
});

app.get ( '/blueHalf', function ( req, res ) {
	console.log ( "blueHalf" );
	enableStrobe = false;
	enableFade = false;
	setBlue( 0.5 );
	res.send( "blueHalf" );
});

app.get ( '/blueOff', function ( req, res ) {
	console.log ( "blueOff" );
	enableStrobe = false;
	enableFade = false;
	setBlue( 0 );
	res.send( "blueOn" );
});

app.post ( '/blueValue/', function ( req, res ) {
	var value = parseFloat( req.body.value );
	console.log( "blueValue: " + value );
	enableStrobe = false;
	enableFade = false;
	setBlue( 0 );
	res.send( "blueValue" );
});

app.get ( '/fade', function ( req, res ) {
	console.log( "fade" );
	enableStrobe = false;
	enableFade = true
	res.send( "fade" );
});

app.get ( '/fade1', function ( req, res ) {
	console.log( "fade1" );
	colorStep = colorStep1;
	enableStrobe = false;
	enableFade = true;
	res.send( "fade1" );
});

app.get ( '/fade2', function ( req, res ) {
	console.log( "fade2" );
	colorStep = colorStep2;
	enableStrobe = false;
	enableFade = true;
	res.send( "fade2" );
});

app.get ( '/strobe', function ( req, res ) {
	console.log( "strobe" );
	enableStrobe = true;
	enableFade = false;
	res.send( "strobe" );
});


var server = app.listen(app.get('port'), function() {
	console.log('listening on port %d', server.address().port);
});


var timeStep = 100;
var u = new Updater(timeStep);
u.init();
u.on('Event',function () 
{
   	//console.log("Event catched!");
	if ( enableFade )
	{
		colorCtrl += colorStep;

		var minValue = 0.15;
		var maxValue = 1;

		var fadeValue = Math.abs(  Math.sin ( colorCtrl ) *  (maxValue - minValue) ) + minValue;
		setRed( fadeValue );

		fadeValue = Math.abs(  Math.sin ( colorCtrl / 2 ) *  (maxValue - minValue) ) + minValue;
		setGreen( fadeValue );

		fadeValue = Math.abs( Math.sin ( colorCtrl / 1.25 ) *  (maxValue - minValue) ) + minValue;
		setBlue( fadeValue );

		//console.log ( "fadeValue: " + fadeValue );
	}
	else if ( enableStrobe )
	{
		colorCtrl += colorStep;
		console.log ( "colorCtrl: " + colorCtrl );
		if ( colorCtrl > strobeDuration )
		{
			colorCtrl = 0;

			var colorValue = 0;
			if ( strobeOn == true )
			{
				colorValue = 1;
			}
			else
			{
				colorValue = 0;
			}
			strobeOn = !strobeOn;

			console.log ( "color value: " + colorValue );

			setRed( colorValue );
			setGreen( colorValue );
			setBlue( colorValue );
		}
	}
});


function setRed ( value )
{
	currentRed = value * 255;
	piblaster.setPwm ( redPinNumber, value );
}

function setGreen ( value )
{
	currentGreen = value * 255;
	piblaster.setPwm ( greenPinNumber, value );
}

function setBlue ( value )
{
	currentBlue = value * 255;
	piblaster.setPwm ( bluePinNumber, value );
}


function turnOnAll ()
{
	setRed( 1 );
	setGreen( 1 );
	setBlue( 1 );
	// piblaster.setPwm( greenPinNumber, 1 );
	// piblaster.setPwm( redPinNumber, 1 );
	// piblaster.setPwm( bluePinNumber, 1 );
}

function turnOffAll ()
{
	setRed( 0 );
	setGreen( 0 );
	setBlue( 0 );
	// piblaster.setPwm( greenPinNumber, 0 );
	// piblaster.setPwm( redPinNumber, 0 );
	// piblaster.setPwm( bluePinNumber, 0 );
}

