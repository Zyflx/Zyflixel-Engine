function loadCharacter()
{
	quickAnimAdd('idle', 'Parent Christmas Idle');
	quickAnimAdd('singUP', 'Parent Up Note Dad');
	quickAnimAdd('singDOWN', 'Parent Down Note Dad');
	quickAnimAdd('singLEFT', 'Parent Left Note Dad');
	quickAnimAdd('singRIGHT', 'Parent Right Note Dad');

	quickAnimAdd('singUP-alt', 'Parent Up Note Mom');

	quickAnimAdd('singDOWN-alt', 'Parent Down Note Mom');
	quickAnimAdd('singLEFT-alt', 'Parent Left Note Mom');
	quickAnimAdd('singRIGHT-alt', 'Parent Right Note Mom');

	addOffset('idle', 0, 0);
	addOffset('singLEFT', -30, 16);
	addOffset('singDOWN', -31, -29);
	addOffset('singUP', -47, 24);
	addOffset('singRIGHT', -1, -23);
	addOffset('singLEFT-alt', -30, 15);
	addOffset('singDOWN-alt', -30, -27);
	addOffset('singUP-alt', -47, 24);
	addOffset('singRIGHT-alt', -1, -24);

	playAnim('idle');
}
