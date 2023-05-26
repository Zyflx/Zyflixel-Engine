function loadCharacter()
{
    quickAnimAdd('idle', "Mom Idle");
	quickAnimAdd('singUP', "Mom Up Pose");
	quickAnimAdd('singDOWN', "MOM DOWN POSE");
	quickAnimAdd('singLEFT', 'Mom Left Pose');
	quickAnimAdd('singRIGHT', 'Mom Pose Left');

    addOffset('idle', 0, 0);
    addOffset('singLEFT', 250, -23);
    addOffset('singDOWN', 20, -160);
    addOffset('singUP', 14, 71);
    addOffset('singRIGHT', 10, -60);

    playAnim('idle');
}