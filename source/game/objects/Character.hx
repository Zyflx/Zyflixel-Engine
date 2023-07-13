package game.objects;

import game.data.backend.Section.SwagSection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxSort;
import haxe.io.Path;

#if sys
import sys.FileSystem;
#end

import game.state.*;
import game.data.backend.*;
import game.objects.stages.background.*;
import game.data.scripts.*;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var animationNotes:Array<Dynamic> = [];

	private static var characterScripts:Array<Script> = [];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		initCharacter(curCharacter);

		if (curCharacter == 'pico-speaker')
			loadMappedAnims();

		dance();
		animation.finish();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	function initCharacter(char:String)
	{
		var charScripts:Array<Script> = [];

		var sprType:String = 'sparrow';

		if (FileSystem.exists(Paths.character(char, char + '.txt')))
		{
			sprType = 'packer';
		}

		switch (sprType)
		{
			case 'packer':
				frames = Paths.getCharacterAtlas(char, char, true);
			default:
				frames = Paths.getCharacterAtlas(char, char);
		}

		// This is so if the character doesn't exist, it replaces it with bf to prevent a crash
		var charExists:Bool = Paths.fileExists(Paths.character(char));
		if (!charExists)
			frames = Paths.getCharacterAtlas('bf', 'bf');

		var character:String = (!charExists ? 'bf' : char);
		Script.runScripts(charScripts, ['data/characters/$character']);

		for (i in charScripts)
		{
			i.set('quickAnimAdd', function(animName:String, animPrefix:String)
			{
				animation.addByPrefix(animName, animPrefix, 24, false);
			});
			i.set('addByPrefix', function(animName:String, animPrefix:String, ?framerate:Int = 24, ?loop:Bool = false)
			{
				animation.addByPrefix(animName, animPrefix, framerate, loop);
			});
			i.set('addByIndices', function(animName:String, animPrefix:String, indices:Array<Int>, ?framerate:Int = 24, ?loop:Bool = false)
			{
				animation.addByIndices(animName, animPrefix, indices, '', framerate, loop);
			});
			i.set('addOffset', function(name:String, x:Float, y:Float)
			{
				addOffset(name, x, y);
			});
			i.set('set', function(variable:String, value:Dynamic)
			{
				Reflect.setProperty(this, variable, value);
			});
			i.set('get', function(variable:String)
			{
				return Reflect.getProperty(this, variable);
			});
			i.set('setGraphicSize', function(width:Int, height:Int)
			{
				setGraphicSize(width, height);
				updateHitbox();
			});
			i.set('playAnim', function(animName:String, ?forced:Bool = false, ?reversed:Bool = false, ?frames:Int = 0)
			{
				playAnim(animName, forced, reversed, frames);
			});
			i.set('isPlayer', isPlayer);
			i.callFunction('loadCharacter');
		}
	}

	public function loadMappedAnims()
	{
		var swagshit = Song.loadFromJson('picospeaker', 'stress');

		var notes = swagshit.notes;

		for (section in notes)
		{
			for (idk in section.sectionNotes)
			{
				animationNotes.push(idk);
			}
		}

		TankmenBG.animationNotes = animationNotes;

		// trace(animationNotes);
		animationNotes.sort(sortAnims);
	}

	function sortAnims(val1:Array<Dynamic>, val2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, val1[0], val2[0]);
	}

	function quickAnimAdd(name:String, prefix:String)
	{
		animation.addByPrefix(name, prefix, 24, false);
	}
	
	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		if (curCharacter.endsWith('-car'))
		{
			// looping hair anims after idle finished
			if (!animation.curAnim.name.startsWith('sing') && animation.curAnim.finished)
				playAnim('idleHair');
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
			case "pico-speaker":
				// for pico??
				if (animationNotes.length > 0)
				{
					if (Conductor.songPosition > animationNotes[0][0])
					{
						// trace('played shoot anim' + animationNotes[0][1]);

						var shootAnim:Int = 1;

						if (animationNotes[0][1] >= 2)
							shootAnim = 3;

						shootAnim += FlxG.random.int(0, 1);

						playAnim('shoot' + shootAnim, true);
						animationNotes.shift();
					}
				}

				if (animation.curAnim.finished)
				{
					playAnim(animation.curAnim.name, false, false, animation.curAnim.numFrames - 3);
				}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gf-tankmen':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'pico-speaker':
				// lol weed
				// playAnim('shoot' + FlxG.random.int(1, 4), true);

				case 'tankman':
					if (!animation.curAnim.name.endsWith('DOWN-alt'))
						playAnim('idle');

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
