var gpio = require('pi-gpio');
var express = require('express');
var bodyParser = require('body-parser');

var redPinNumber = 15;
var greenPinNumber = 11;
var bluePinNumber = 18;

var redIsOpen = 0;

closeAll();
var app = express();
app.use(bodyParser.json());
app.set('port', process.env.PORT || 3000);

app.put ( '/:allOff', function ( req, res ) {
	closeAll();
	res.send( 200, {} );
});

app.get ( '/:redOn', function ( req, res ) {
	turnOn ( redPinNumber, redIsOpen );
	res.send( 200, {} );
	redIsOpen = 1;
});

app.get ( '/:greenOn', function ( req, res ) {
	turnOn ( greenPinNumber, 0 );
	res.send( 200, {} );
});

app.get ( '/:blueOn', function ( req, res ) {
	turnOn ( bluePinNumber, 0 );
	res.send( 200, {} );
});

var server = app.listen(app.get('port'), function() {
	console.log('listening on port %d', server.address().port);
});



//gpio.open ( greenPinNumber, "output", function () { write( greenPinNumber ) } );
//gpio.open ( redPinNumber, "output", function () { write( redPinNumber ) } );

function closeAll ()
{
	gpio.close( greenPinNumber );
	gpio.close( redPinNumber );
	gpio.close( bluePinNumber );
}

function turnOn ( pinNumber, isOpen )
{
	if ( isOpen == 0 )
	{
		gpio.open ( pinNumber, "output", function () { write( pinNumber ) } );
	}
	else
	{
		 write( pinNumber )
	}
}

function write( pinNumber )
{
	gpio.pwmWrite ( pinNumber, 255, function() 
	{ 
		gpio.close( pinNumber );
		
		//if (err) throw err; 
		console.log( "written to pin " + pinNumber ); 
	});
}