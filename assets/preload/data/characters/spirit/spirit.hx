function loadCharacter()
{
    quickAnimAdd('idle', "idle spirit_");
    quickAnimAdd('singUP', "up_");
    quickAnimAdd('singRIGHT', "right_");
    quickAnimAdd('singLEFT', "left_");
    quickAnimAdd('singDOWN', "spirit down_");

    addOffset('idle', -220, -280);
    addOffset('singLEFT', -200, -280);
    addOffset('singDOWN', 170, 110);
    addOffset('singUP', -220, -280);
    addOffset('singRIGHT', -220, -280);

    playAnim('idle');

    setGraphicSize(Std.int(get('width') * 6));

    set('antialiasing', false);
}