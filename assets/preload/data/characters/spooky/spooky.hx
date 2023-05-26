function loadCharacter()
{
    quickAnimAdd('singUP', 'spooky UP NOTE');
    quickAnimAdd('singDOWN', 'spooky DOWN note');
    quickAnimAdd('singLEFT', 'note sing left');
    quickAnimAdd('singRIGHT', 'spooky sing right');
    addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], 12, false);
    addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], 12, false);
    
    addOffset('danceLeft', 0, 0);
    addOffset('danceRight', 0, 0);
    addOffset('singLEFT', 130, -10);
    addOffset('singDOWN', -50, -130);
    addOffset('singUP', -20, 26);
    addOffset('singRIGHT', -130, -14);
    
    playAnim('danceRight');
}