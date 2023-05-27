function loadCharacter()
{
	quickAnimAdd('idle', 'BF idle dance');
	quickAnimAdd('singUP', 'BF NOTE UP0');
	quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
	quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
	quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
	quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
	quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
	quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
	quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
	quickAnimAdd('hey', 'BF HEY');
	quickAnimAdd('firstDeath', "BF dies");
	quickAnimAdd('deathConfirm', "BF Dead confirm");

	addByPrefix('deathLoop', "BF Dead Loop", 24, true);
	addByPrefix('scared', 'BF idle shaking', 24, true);

	addOffset('idle', -5, 0);
	addOffset('singUP', -29, 27);
	addOffset('singRIGHT', -38, -7);
	addOffset('singLEFT', 12, -6);
	addOffset('singDOWN', -10, -50);
	addOffset('singUPmiss', -29, 27);
	addOffset('singRIGHTmiss', -30, 21);
	addOffset('singLEFTmiss', 12, 24);
	addOffset('singDOWNmiss', -11, -19);
	addOffset('hey', 7, 4);
	addOffset('firstDeath', 37, 11);
	addOffset('deathLoop', 37, 5);
	addOffset('deathConfirm', 37, 69);
	addOffset('scared', -4, 0);

	playAnim('idle');

	set('flipX', true);
}
