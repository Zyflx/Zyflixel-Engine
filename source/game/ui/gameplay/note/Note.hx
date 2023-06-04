package game.ui.gameplay.note;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import game.objects.shaders.ColorSwap;
import game.state.menus.options.PreferencesMenu;
import game.state.PlayState;
import game.data.backend.Conductor;

using StringTools;

#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	private var willMiss:Bool = false;

	public var altNote:Bool = false;
	public var invisNote:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var colorSwap:ColorSwap;
	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public static var arrowColors:Array<Float> = [1, 1, 1, 1];
	public static var colorArray:Array<String> = ['purple', 'blue', 'green', 'red'];

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 98.5;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		if (PlayState.isPixel)
		{
			loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

			animation.add('greenScroll', [6]);
			animation.add('redScroll', [7]);
			animation.add('blueScroll', [5]);
			animation.add('purpleScroll', [4]);

			if (isSustainNote)
			{
				loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

				animation.add('purpleholdend', [4]);
				animation.add('greenholdend', [6]);
				animation.add('redholdend', [7]);
				animation.add('blueholdend', [5]);

				animation.add('purplehold', [0]);
				animation.add('greenhold', [2]);
				animation.add('redhold', [3]);
				animation.add('bluehold', [1]);
			}

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			updateHitbox();
		}
		else
		{
			frames = Paths.getSparrowAtlas('NOTE_assets');

			animation.addByPrefix(colorArray[noteData] + 'Scroll', colorArray[noteData] + ' instance');
			if (isSustainNote)
			{
				animation.addByPrefix(colorArray[noteData] + 'hold', colorArray[noteData] + ' hold piece');
				if (colorArray[noteData] != 'purple')
				{
					animation.addByPrefix(colorArray[noteData] + 'holdend', colorArray[noteData] + ' hold end');
				}
				// Have to make a separate animation.addByPrefix() for this because the fuckin anim name is different
				animation.addByPrefix('purpleholdend', 'pruple end hold');
			}

			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = true;
		}

		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		updateColors();

		x += swagWidth * noteData;
		animation.play(colorArray[noteData] + 'Scroll');
		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			if (PreferencesMenu.getPref('downscroll'))
				angle = 180;

			x += width / 2;

			animation.play(colorArray[noteData] + 'holdend');

			updateHitbox();

			x -= width / 2;

			if (PlayState.isPixel) x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(colorArray[prevNote.noteData] + 'hold');
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	public function updateColors():Void
	{
		colorSwap.update(arrowColors[noteData]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// miss on the NEXT frame so lag doesnt make u miss notes
			if (willMiss && !wasGoodHit)
			{
				tooLate = true;
				canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset)
				{ // The * 0.5 is so that it's easier to hit them too late, instead of too early
					if (strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
						canBeHit = true;
				}
				else
				{
					canBeHit = true;
					willMiss = true;
				}
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
