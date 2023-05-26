function loadCharacter()
{
    quickAnimAdd('shoot1', "Pico shoot 1");
    quickAnimAdd('shoot2', "Pico shoot 2");
    quickAnimAdd('shoot3', "Pico shoot 3");
    quickAnimAdd('shoot4', "Pico shoot 4");

    addOffset('shoot1', 0, 0);
    addOffset('shoot2', -1, -128);
    addOffset('shoot3', 412, -64);
    addOffset('shoot4', 439, -19);

    playAnim('shoot1');
}