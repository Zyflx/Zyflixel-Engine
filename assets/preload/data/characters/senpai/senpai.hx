function loadCharacter()
{
	if (PlayState.SONG.song.toLowerCase() == 'roses')
	{
		coping();
	}
	else
	{
		happi();
	}

	addOffset('idle', 0, 0);
	addOffset('singLEFT', 40, 0);
	addOffset('singDOWN', 14, 0);
	addOffset('singUP', 5, 37);
	addOffset('singRIGHT', 0, 0);

	playAnim('idle');

	setGraphicSize(Std.int(get('width') * 6));

	set('antialiasing', false);
}

function happi()
{
	quickAnimAdd('idle', 'Senpai Idle');
	quickAnimAdd('singUP', 'SENPAI UP NOTE');
	quickAnimAdd('singLEFT', 'SENPAI LEFT NOTE');
	quickAnimAdd('singRIGHT', 'SENPAI RIGHT NOTE');
	quickAnimAdd('singDOWN', 'SENPAI DOWN NOTE');
}

function coping()
{
	quickAnimAdd('idle', 'Angry Senpai Idle');
	quickAnimAdd('singUP', 'Angry Senpai UP NOTE');
	quickAnimAdd('singLEFT', 'Angry Senpai LEFT NOTE');
	quickAnimAdd('singRIGHT', 'Angry Senpai RIGHT NOTE');
	quickAnimAdd('singDOWN', 'Angry Senpai DOWN NOTE');
}
