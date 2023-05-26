function loadCharacter()
{
    quickAnimAdd('idle', 'BF IDLE');
    quickAnimAdd('singUP', 'BF UP NOTE');
    quickAnimAdd('singLEFT', 'BF LEFT NOTE');
    quickAnimAdd('singRIGHT', 'BF RIGHT NOTE');
    quickAnimAdd('singDOWN', 'BF DOWN NOTE');
    quickAnimAdd('singUPmiss', 'BF UP MISS');
    quickAnimAdd('singLEFTmiss', 'BF LEFT MISS');
    quickAnimAdd('singRIGHTmiss', 'BF RIGHT MISS');
    quickAnimAdd('singDOWNmiss', 'BF DOWN MISS');

    addOffset('idle', 0, 0);
    addOffset('singLEFT', 0, 0);
    addOffset('singDOWN', 0, 0);
    addOffset('singUP', 0, 0);
    addOffset('singRIGHT', 0, 0);
    addOffset('singLEFTmiss', 0, 0);
    addOffset('singDOWNmiss', 0, 0);
    addOffset('singUPmiss', 0, 0);
    addOffset('singRIGHTmiss', 0, 0);
    
    playAnim('idle');

    setGraphicSize(Std.int(get('width') * 6));

    set('width', get('width') - 100);
    set('height', get('height') - 100);
    set('antialiasing', false);
    set('flipX', true);
}