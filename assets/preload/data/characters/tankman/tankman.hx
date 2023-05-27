function loadCharacter()
{
	quickAnimAdd('idle', "Tankman Idle Dance");

	if (isPlayer)
	{
		quickAnimAdd('singLEFT', 'Tankman Note Left ');
		quickAnimAdd('singRIGHT', 'Tankman Right Note ');
		quickAnimAdd('singLEFTmiss', 'Tankman Note Left MISS');
		quickAnimAdd('singRIGHTmiss', 'Tankman Right Note MISS');
	}
	else
	{
		quickAnimAdd('singLEFT', 'Tankman Right Note ');
		quickAnimAdd('singRIGHT', 'Tankman Note Left ');
		quickAnimAdd('singLEFTmiss', 'Tankman Right Note MISS');
		quickAnimAdd('singRIGHTmiss', 'Tankman Note Left MISS');
	}

	quickAnimAdd('singUP', 'Tankman UP note ');
	quickAnimAdd('singDOWN', 'Tankman DOWN note ');
	quickAnimAdd('singUPmiss', 'Tankman UP note MISS');
	quickAnimAdd('singDOWNmiss', 'Tankman DOWN note MISS');

	quickAnimAdd('singDOWN-alt', 'PRETTY GOOD');
	quickAnimAdd('singUP-alt', 'TANKMAN UGH');

	// Using Psych Tankman offsets because the base game ones are ass
	addOffset('idle', 0, 0);
	addOffset('singLEFT', 100, -14);
	addOffset('singDOWN', 76, -101);
	addOffset('singDOWN-alt', 1, 16);
	addOffset('singUP', 48, 54);
	addOffset('singUP-alt', -15, -8);
	addOffset('singRIGHT', -21, -31);
	addOffset('singLEFTmiss', 84, -14);
	addOffset('singDOWNmiss', 76, -101);
	addOffset('singUPmiss', 48, 54);
	addOffset('singRIGHTmiss', -21, -31);

	playAnim('idle');

	set('flipX', true);
}
