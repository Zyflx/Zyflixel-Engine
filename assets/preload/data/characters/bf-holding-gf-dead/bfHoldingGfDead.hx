function loadCharacter()
{
    quickAnimAdd('singUP', 'BF Dead with GF Loop');
    quickAnimAdd('firstDeath', 'BF Dies with GF');
    addByPrefix('deathLoop', 'BF Dead with GF Loop', 24, true);
    quickAnimAdd('deathConfirm', 'RETRY confirm holding gf');

    addOffset('firstDeath', 37, 14);
    addOffset('deathLoop', 37, -3);
    addOffset('deathConfirm', 37, 28);

    playAnim('firstDeath');

    set('flipX', true);
}