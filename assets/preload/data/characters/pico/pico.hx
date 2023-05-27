function loadCharacter()
{
	quickAnimAdd('idle', "Pico Idle Dance");
	quickAnimAdd('singUP', 'pico Up note0');
	quickAnimAdd('singDOWN', 'Pico Down Note0');
	if (isPlayer)
	{
		quickAnimAdd('singLEFT', 'Pico NOTE LEFT0');
		quickAnimAdd('singRIGHT', 'Pico Note Right0');
		quickAnimAdd('singRIGHTmiss', 'Pico Note Right Miss');
		quickAnimAdd('singLEFTmiss', 'Pico NOTE LEFT miss');
	}
	else
	{
		quickAnimAdd('singLEFT', 'Pico Note Right0');
		quickAnimAdd('singRIGHT', 'Pico NOTE LEFT0');
		quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss');
		quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss');
	}
	quickAnimAdd('singUPmiss', 'pico Up note miss');
	quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS');

	addOffset('idle', 0, 0);
	addOffset('singLEFT', 65, 9);
	addOffset('singDOWN', 200, -70);
	addOffset('singUP', -29, 27);
	addOffset('singRIGHT', -68, -7);
	addOffset('singLEFTmiss', 62, 64);
	addOffset('singDOWNmiss', 210, -28);
	addOffset('singUPmiss', -19, 67);
	addOffset('singRIGHTmiss', -60, 41);

	set('flipX', true);

	playAnim('idle');
}
