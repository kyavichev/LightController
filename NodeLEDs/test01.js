var gpio = require('pi-gpio');

var greenPinNumber = 11;
var redPinNumber = 15;

closeAll();
gpio.open ( greenPinNumber, "output", function () { write( greenPinNumber ) } );
gpio.open ( redPinNumber, "output", function () { write( redPinNumber ) } );


function closeAll ()
{
	gpio.close( greenPinNumber );
	gpio.close( redPinNumber );
	//gpio.close( pinNumber );
}

function write( pinNumber )
{
	gpio.write ( pinNumber, 255, function() 
	{ 
		//gpio.close( pinNumber );
		
		//if (err) throw err; 
		console.log( "written to pin " + pinNumber ); 
	});
}