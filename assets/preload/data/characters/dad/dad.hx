function loadCharacter()
{
	quickAnimAdd('idle', 'Dad idle dance');
	quickAnimAdd('singUP', 'Dad Sing Note UP');
	quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT');
	quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
	quickAnimAdd('singLEFT', 'Dad Sing Note LEFT');

	addOffset('idle', 0, 0);
	addOffset('singUP', -6, 50);
	addOffset('singRIGHT', 0, 27);
	addOffset('singLEFT', -10, 10);
	addOffset('singDOWN', 0, -30);

	playAnim('idle');
}
