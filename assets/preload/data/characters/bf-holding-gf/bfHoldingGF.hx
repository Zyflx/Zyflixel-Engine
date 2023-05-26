function loadCharacter()
{
    quickAnimAdd('idle', 'BF idle dance');
    quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
    quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
    quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
    quickAnimAdd('singUP', 'BF NOTE UP0');

    quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
    quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
    quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
    quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
    quickAnimAdd('bfCatch', 'BF catches GF');

    addOffset('idle', 0, 0);
    addOffset('singLEFT', 12, 7);
    addOffset('singDOWN', -10, -10);
    addOffset('singUP', -29, 10);
    addOffset('singRIGHT', -41, 23);
    addOffset('singLEFTmiss', 12, 7);
    addOffset('singDOWNmiss', -10, -10);
    addOffset('singUPmiss', -29, 10);
    addOffset('singRIGHTmiss', -41, 23);
    
    playAnim('idle');

    set('flipX', true);
}