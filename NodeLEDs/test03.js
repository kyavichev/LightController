var express = require('express');
var bodyParser = require('body-parser');
var piblaster = require('pi-blaster.js');

//pins
// 11, 15, 18

var redPinNumber = 22;
var greenPinNumber = 17;
var bluePinNumber = 24;

var redIsOpen = 0;

turnOffAll();
var app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded( { extended: false } ));
app.set('port', process.env.PORT || 3000);

app.get ( '/allOn', function ( req, res ) {
	console.log ( "all on" );
	turnOnAll();
	res.send( "allOn" );
});

app.get ( '/allOff', function ( req, res ) {
	console.log ( "all off" );
	turnOffAll();
	res.send( "allOff" );
});

app.get ( '/redOn', function ( req, res ) {
	console.log ( "redOn" );
	piblaster.setPwm ( redPinNumber, 1 );
	res.send( "redOn" );
});

app.get ( '/redOff', function ( req, res ) {
	console.log ( "redOff" );
	piblaster.setPwm ( redPinNumber, 0 );
	res.send( "redOff" );
});

app.post ( '/redValue/', function ( req, res ) {
	var value = parseFloat( req.body.value );
	console.log( "redValue: " + value );
	piblaster.setPwm ( redPinNumber, value );
	res.send( "redValue" );
});

app.get ( '/greenOn', function ( req, res ) {
	console.log ( "greenOn" );
	piblaster.setPwm ( greenPinNumber, 1 );
	res.send( "greenOn" );
});

app.get ( '/greenOff', function ( req, res ) {
	console.log ( "greenOff" );
	piblaster.setPwm ( greenPinNumber, 0 );
	res.send( "greenOff" );
});

app.post ( '/greenValue/', function ( req, res ) {
	var value = parseFloat( req.body.value );
	console.log( "greenValue: " + value );
	piblaster.setPwm ( greenPinNumber, value );
	res.send( "greenValue" );
});

app.get ( '/blueOn', function ( req, res ) {
	console.log ( "blueOn" );
	piblaster.setPwm( bluePinNumber, 1 );
	res.send( "blueOn" );
});

app.get ( '/blueOff', function ( req, res ) {
	console.log ( "blueOff" );
	piblaster.setPwm( bluePinNumber, 0 );
	res.send( "blueOn" );
});

app.post ( '/blueValue/', function ( req, res ) {
	var value = parseFloat( req.body.value );
	console.log( "blueValue: " + value );
	piblaster.setPwm ( bluePinNumber, value );
	res.send( "blueValue" );
});

var server = app.listen(app.get('port'), function() {
	console.log('listening on port %d', server.address().port);
});


function turnOnAll ()
{
	piblaster.setPwm( greenPinNumber, 1 );
	piblaster.setPwm( redPinNumber, 1 );
	piblaster.setPwm( bluePinNumber, 1 );
}

function turnOffAll ()
{
	piblaster.setPwm( greenPinNumber, 0 );
	piblaster.setPwm( redPinNumber, 0 );
	piblaster.setPwm( bluePinNumber, 0 );
}

