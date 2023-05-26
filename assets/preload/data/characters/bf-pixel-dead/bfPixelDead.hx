function loadCharacter()
{
    quickAnimAdd('singUP', "BF Dies pixel");
    quickAnimAdd('firstDeath', "BF Dies pixel");
    addByPrefix('deathLoop', "Retry Loop", 24, true);
    quickAnimAdd('deathConfirm', "RETRY CONFIRM");

    addOffset('firstDeath', 0, 0);
    addOffset('deathLoop', -30, -12);
    addOffset('deathConfirm', -30, -12);

    playAnim('firstDeath');

    setGraphicSize(Std.int(get('width') * 6));
    
    set('antialiasing', false);
    set('flipX', true);
}