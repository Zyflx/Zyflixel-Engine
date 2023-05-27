function loadCharacter()
{
	quickAnimAdd('idle', 'monster idle');
	quickAnimAdd('singUP', 'monster up note');
	quickAnimAdd('singDOWN', 'monster down');
	quickAnimAdd('singLEFT', 'Monster left note');
	quickAnimAdd('singRIGHT', 'Monster Right note');

	addOffset('idle', 0, 0);
	addOffset('singLEFT', -30, 0);
	addOffset('singDOWN', -40, -94);
	addOffset('singUP', -20, 50);
	addOffset('singRIGHT', -51, 0);

	playAnim('idle');
}
