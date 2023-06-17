package funkin.gameplay.objects.note;

import funkin.editors.objects.SectionRender;
import funkin.editors.objects.ChartingBox;
import funkin._backend.utils.NoteskinHelpers;

using StringTools;

class NoteSpr extends FlxSprite
{
	public var _def:NoteDef;

	public var noteYOff:Float = 0;

	public static var swagWidth:Float = 160 * 0.7;
	public static final PURP_NOTE:Int = 0;
	public static final GREEN_NOTE:Int = 2;
	public static final BLUE_NOTE:Int = 1;
	public static final RED_NOTE:Int = 3;

	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx
	public var originAngle:Float = 0; // The angle the OG note of the sus note had (?)

	public static final dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];
	public static final quantityColor:Array<Int> = [RED_NOTE, 2, BLUE_NOTE, 2, PURP_NOTE, 2, GREEN_NOTE, 2];
	public static final arrowAngles:Array<Int> = [180, 90, 270, 0];

	public var stepHeight:Float = 0;

	public var distance:Float = 2000;

	public var originColor:Int = 0; // The sustain note's original note's color

	public var overrideDistance:Bool = false; // Set this to true if you know what are you doing.

	public var noteCharterObject:SustainRender;

	public var selectedBox:ChartingBox;

	var nullSafety:Bool = true;

	public var modAlpha:Float = 1;

	public function new()
	{
		super();
	}

	public function setupNote(noteDef:NoteDef):Void
	{
		_def = noteDef;

		_def.connectedNote = this;

		loadNote();
	}

	public function loadNote():Void
	{
		// defaults if no noteStyle was found in chart

		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		visible = false;

		if (_def.insideCharter)
		{
			if (PlayState.isPixelStage)
			{
				loadGraphic(NoteskinHelpers.generatePixelSprite(FlxG.save.data.noteskin, false, 'normal'), true, 17, 17);
				if (_def.isSustainNote)
					loadGraphic(NoteskinHelpers.generatePixelSprite(FlxG.save.data.noteskin, true, 'normal'), true, 7, 6);

				for (i in 0...4)
				{
					animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
					animation.add(dataColor[i] + 'hold', [i]); // Holds
					animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
				}

				setGraphicSize(Std.int(width * PlayState.SONGStyle.scaleFactor));
				updateHitbox();
			}
			else
			{
				frames = NoteskinHelpers.generateNoteskinSprite(FlxG.save.data.noteskin, _def.noteType, _def.noteStyle);

				for (i in 0...4)
				{
					animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + ' alone'); // Normal notes
					animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold'); // Hold
					animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' tail'); // Tails
				}

				setGraphicSize(Std.int(width * 0.7 * PlayState.SONGStyle.scaleFactor));
				updateHitbox();
			}

			antialiasing = FlxG.save.data.antialiasing && PlayState.SONGStyle.antialiasing;
		}
		else
		{
			if (PlayState.isPixelStage)
			{
				loadGraphic(NoteskinHelpers.generatePixelSprite(PlayStateChangeables.currentSkin, false, 'normal'), true, 17, 17);
				if (_def.isSustainNote)
					loadGraphic(NoteskinHelpers.generatePixelSprite(PlayStateChangeables.currentSkin, true, 'normal'), true, 7, 6);

				for (i in 0...4)
				{
					animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
					animation.add(dataColor[i] + 'hold', [i]); // Holds
					animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
				}

				setGraphicSize(Std.int(width * PlayState.SONGStyle.scaleFactor));
				updateHitbox();
			}
			else
			{
				frames = NoteskinHelpers.generateNoteskinSprite(PlayStateChangeables.currentSkin, _def.noteType, _def.noteStyle);

				for (i in 0...4)
				{
					animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + ' alone'); // Normal notes
					animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold'); // Hold
					animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' tail'); // Tails
				}

				setGraphicSize(Std.int(width * 0.7 * PlayState.SONGStyle.scaleFactor));
				updateHitbox();
			}

			antialiasing = FlxG.save.data.antialiasing && PlayState.SONGStyle.antialiasing;

			if (!_def.insideCharter)
				x += swagWidth * (_def.noteData % 4);

			animation.play(dataColor[_def.noteData] + 'Scroll');
			originColor = _def.noteData; // The note's origin color will be checked by its sustain notes

			if (FlxG.save.data.stepMania && !_def.isSustainNote)
			{
				var col:Int = 0;

				var beatRow = Math.floor((_def.beat * 48) + 0.5);

				// STOLEN ETTERNA CODE (IN 2002)

				if (beatRow % (192 / 4) == 0)
					col = quantityColor[0];
				else if (beatRow % (192 / 8) == 0)
					col = quantityColor[2];
				else if (beatRow % (192 / 12) == 0)
					col = quantityColor[4];
				else if (beatRow % (192 / 16) == 0)
					col = quantityColor[6];
				else if (beatRow % (192 / 24) == 0)
					col = quantityColor[4];
				else if (beatRow % (192 / 32) == 0)
					col = quantityColor[4];

				animation.play(dataColor[col] + 'Scroll');

				localAngle -= arrowAngles[col];
				localAngle += arrowAngles[_def.noteData];
				originAngle = localAngle;

				originColor = col;
			}

			if (_def.isSustainNote && _def.prevNote != null)
			{
				stepHeight = (((0.45 * PlayState.instance.fakeNoteStepCrochet)) * FlxMath.roundDecimal(PlayState.instance.scrollSpeed == 1 ? PlayState.SONG.speed : PlayState.instance.scrollSpeed,
					2) * _def.speedMultiplier);

				noteYOff = -stepHeight + swagWidth * 0.5;

				if (PlayStateChangeables.useDownscroll)
					flipY = true;

				originColor = _def.prevNote.connectedNote.originColor;
				originAngle = _def.prevNote.connectedNote.originAngle;

				animation.play(dataColor[originColor] + 'holdend'); // This works both for normal colors and quantization colors

				updateHitbox();

				// if (noteStyleCheck == 'pixel')
				//	x += 30;

				if (_def.insideCharter)
					x += 30;

				if (_def.prevNote.isSustainNote)
				{
					_def.prevNote.connectedNote.animation.play(dataColor[_def.prevNote.connectedNote.originColor] + 'hold');
					_def.prevNote.connectedNote.updateHitbox();

					_def.prevNote.connectedNote.scale.y *= (stepHeight / _def.prevNote.connectedNote.height);
					_def.prevNote.connectedNote.updateHitbox();

					if (antialiasing)
						_def.prevNote.connectedNote.scale.y *= 1.0 + (1.0 / _def.prevNote.connectedNote.frameHeight);

					_def.prevNote.connectedNote.updateHitbox();
					updateHitbox();
				}
			}
		}

		angle = localAngle + modAngle;
		moves = false;
	}

	override function update(elapsed:Float)
	{
		// This updates hold notes height to current scroll Speed in case of scroll Speed changes.
		super.update(elapsed);

		if (!_def.insideCharter)
		{
			if (_def.isSustainNote)
			{
				var newStepHeight = (((0.45 * PlayState.instance.fakeNoteStepCrochet)) * FlxMath.roundDecimal(PlayState.instance.scrollSpeed == 1 ? PlayState.SONG.speed : PlayState.instance.scrollSpeed,
					2) * _def.speedMultiplier);

				if (stepHeight != newStepHeight)
				{
					stepHeight = newStepHeight;
					if (_def.isSustainNote)
					{
						noteYOff = -stepHeight + swagWidth * 0.5;
					}
				}
			}

			angle = localAngle + modAngle;

			if (_def.mustPress)
			{
				switch (_def.noteType)
				{
					case 'hurt': // Really hard to hit
						if (_def.strumTime - Conductor.songPosition <= ((Ratings.timingWindows[0].timingWindow) * 0.2)
							&& _def.strumTime - Conductor.songPosition >= (-Ratings.timingWindows[0].timingWindow) * 0.4)
						{
							_def.canBeHit = true;
						}
						else
						{
							_def.canBeHit = false;
						}
						if (_def.strumTime - Conductor.songPosition < -Ratings.timingWindows[0].timingWindow && !_def.wasGoodHit)
							_def.tooLate = true;
					default:
						// PLAYER NOTES
						if (_def.strumTime - Conductor.songPosition <= (((Ratings.timingWindows[0].timingWindow) * _def.lateHitMult))
							&& _def.strumTime - Conductor.songPosition >= (((-Ratings.timingWindows[0].timingWindow) * _def.earlyHitMult)))
							_def.canBeHit = true;
						else
							_def.canBeHit = false;

						if (_def.strumTime - Conductor.songPosition < (-Ratings.timingWindows[0].timingWindow) && !_def.wasGoodHit)
							_def.tooLate = true;
				}
			}

			if (_def.isSustainNote)
			{
				_def.isSustainEnd = _def.spotInLine == _def.parent.children.length - 1;
				alpha = !_def.sustainActive
					&& (_def.parent.tooLate || _def.parent.wasGoodHit) ? (modAlpha * FlxG.save.data.alpha) / 2 : modAlpha * FlxG.save.data.alpha; // This is the correct way
			}
			else if (_def.tooLate && !_def.wasGoodHit)
			{
				if (alpha > modAlpha * 0.3)
					alpha = modAlpha * 0.3;
			}
		}
	}

	@:noCompletion
	override function set_y(value:Float):Float
	{
		if (_def != null)
			if (_def.isSustainNote)
				if (PlayStateChangeables.useDownscroll)
					value -= height - swagWidth;
		return super.set_y(value);
	}

	override function destroy()
	{
		if (noteCharterObject != null)
			noteCharterObject.destroy();

		_def = null;

		super.destroy();
	}

	@:noCompletion
	override function set_clipRect(rect:FlxRect):FlxRect
	{
		clipRect = rect;

		if (frames != null)
			frame = frames.frames[animation.frameIndex];

		return rect;
	}
}
