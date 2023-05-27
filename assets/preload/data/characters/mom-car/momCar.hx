function loadCharacter()
{
	quickAnimAdd('idle', "Mom Idle");
	quickAnimAdd('singUP', "Mom Up Pose");
	quickAnimAdd('singDOWN', "MOM DOWN POSE");
	quickAnimAdd('singLEFT', 'Mom Left Pose');
	quickAnimAdd('singRIGHT', 'Mom Pose Left');
	addByIndices('idleHair', "Mom Idle", [10, 11, 12, 13], "", 24, true);

	addOffset('idle', 0, 0);
	addOffset('idleHair', 0, 0);
	addOffset('singLEFT', 250, -23);
	addOffset('singDOWN', 20, -160);
	addOffset('singUP', 14, 71);
	addOffset('singRIGHT', 10, -60);
}
