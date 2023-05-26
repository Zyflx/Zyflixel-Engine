function loadCharacter()
{
    quickAnimAdd('idle', 'monster idle');
    quickAnimAdd('singUP', 'monster up note');
    quickAnimAdd('singDOWN', 'monster down');
    quickAnimAdd('singLEFT', 'Monster left note');
    quickAnimAdd('singRIGHT', 'Monster Right note');
    
    addOffset('idle', 0, 0);
    addOffset('singLEFT', -30, 20);
    addOffset('singDOWN', -50, -80);
    addOffset('singUP', -20, 94);
    addOffset('singRIGHT', -51, 30);

    playAnim('idle');
}