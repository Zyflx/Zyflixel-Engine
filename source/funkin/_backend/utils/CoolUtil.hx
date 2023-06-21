package funkin._backend.utils;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets as LimeAssets;
import flixel.text.FlxText; #if FEATURE_FILESYSTEM import sys.io.File; #end

using StringTools;

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = ['Easy', "Normal", "Hard"];

	public static var customDifficulties:Array<String> = [];

	public static var difficultyArray:Array<String> = getGlobalDiffs();

	public static var pauseMenuItems:Array<String> = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];

	public static function difficultyFromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String>;

		try
		{
			daList = OpenFlAssets.getText(path).trim().split('\n');
		}
		catch (e)
		{
			daList = null;
		}

		if (daList != null)
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}

		return daList;
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, value));
	}

	public static function dashToSpace(string:String):String
	{
		return string.replace("-", " ");
	}

	public static function spaceToDash(string:String):String
	{
		return string.replace(" ", "-");
	}

	public static function swapSpaceDash(string:String):String
	{
		return StringTools.contains(string, '-') ? dashToSpace(string) : spaceToDash(string);
	}

	public static function coolStringFile(path:String):Array<String>
	{
		var daList:Array<String> = path.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function destroySong(daSong:SongData)
	{
		for (section in daSong.notes)
			for (songNotes in section.sectionNotes)
			{
				songNotes.resize(0);
				songNotes = null;
			}

		daSong.notes.resize(0);

		daSong.notes = null;

		daSong.eventObjects.resize(0);

		daSong.eventObjects = null;

		daSong = null;
	}

	// alphabet sort (ascending) for string arrays
	public static function sortByAlphabet(arr:Array<String>):Array<String>
	{
		var sort = function(a:String, b:String):Int
		{
			a = a.toUpperCase();
			b = b.toUpperCase();

			if (a < b)
				return -1;
			else if (a > b)
				return 1;
			else
				return 0;
		};

		arr.sort(sort);
		return arr;
	}

	/**
		* Similar to FileSystem.readDirectory() using OpenFLAssets (manifest.json)
		** WARNING: This function doesn't replace FileSystem.readDirectory(), this only lists the assets that came with the build, 
		* if you drag new files to the assets folder it won't be detected!
		** NOTE: Newer files dragged via ModCore/Polymod are detected!
		* @param path The specific directory you want to read.
		* @param library The library you want to scan. Ex: shared.
	 */
	public static function readAssetsDirectoryFromLibrary(path:String, type:String, library:String = 'default'):Array<String>
	{
		var lib = LimeAssets.getLibrary(library);
		var list:Array<String> = lib.list(type);
		var stringList = [];
		for (hmm in list)
		{
			if (hmm.startsWith(path))
			{
				stringList.push(hmm);
			}
		}

		return stringList;
	}

	/**
	 * Convert a Dynamic value to a Defined Class Type Value.
	 		* @param value The value you want to be converted
	 		* @param type The type you want the input value to be converted
	 */
	public static function parseType(value:Dynamic, type:String)
	{
		switch (type.toLowerCase())
		{
			case "float":
				value = Std.parseFloat(value);
			case "string":
				value = Std.string(value);
			case "int":
				value = Std.parseInt(value);
			case "bool":
				if (value.toLowerCase() == "true")
					value = true;
				else
					value = false;
			case "array":
				// Split the string at commas
				var stringValue = Std.string(value);

				if (stringValue.indexOf('[') == -1 && stringValue.indexOf(']') == -1)
				{
					var a:Array<String> = stringValue.split(",");
					Debug.logTrace(a);
					value = a;
				}
				else
				{
					// If the string has array structure directly parse it to convert it to a haxe array.

					try
					{
						var a:Array<String> = haxe.Json.parse(stringValue);

						value = a;
					}
					catch (e)
					{
						Debug.logError(e);
						// Debug.logError('Fucking dumbass fag piece of shit your array is broken kill yourself');
					}
				}
		}
		return value;
	}

	public static function getSuffixFromDiff(diff:String):String
	{
		var suffix = '';
		if (diff != 'Normal')
			suffix = '-${diff.toLowerCase()}';

		return suffix;
	}

	static function getGlobalDiffs():Array<String>
	{
		var returnArray:Array<String> = [];
		if (defaultDifficulties.length > 0)
			for (el in defaultDifficulties)
				returnArray.push(el);

		if (customDifficulties.length > 0)
			for (el2 in customDifficulties)
				returnArray.push(el2);

		return returnArray;
	}
}

/*
	For some reason Flixel doesn't like FlxUINumericSteppers in multiple FlxUI boxes and memory starts ramping up asf.
 */
class CoolNumericStepper extends FlxSpriteGroup
{
	public var currentValue:Float;

	public var stepperValue:Float;

	public var stepperAddValue:Float;

	public var stepperSubstractValue:Float;

	public var inputText:FlxUIInputText;

	public var callback:Float->Void = null;

	public var canInput:Bool = true;

	public function new(x:Float, y:Float, width:Int, currentValue:String, stepperValue:Float, textSize:Int, name:String, Callback:Float->Void)
	{
		super(x, y);
		this.currentValue = Std.parseFloat(currentValue);
		this.stepperValue = stepperValue;
		this.stepperAddValue = stepperValue;
		this.stepperSubstractValue = stepperValue;

		var inputText:FlxUIInputText = new FlxUIInputText(0, 0, width, currentValue, textSize);

		inputText.customFilterPattern = ~/[^0-9.]*/g;
		inputText.filterMode = 4;
		this.inputText = inputText;
		add(inputText);

		callback = Callback;

		var plusButton:FlxUIButton = new FlxUIButton(width, -3, "+", function()
		{
			this.currentValue += this.stepperAddValue;
			currentValue = Std.string(this.currentValue);
			inputText.text = Std.string(this.currentValue);

			if (this.currentValue <= 0 || inputText.text == '' || inputText.text == 'nan' || this.currentValue == Math.NaN)
			{
				this.currentValue = 0.1;
				inputText.text = '0.1';
			}

			if (callback != null)
				callback(this.currentValue);
		});

		add(plusButton);
		plusButton.resize(20, plusButton.height);
		var minusButton:FlxUIButton = new FlxUIButton(plusButton.x + (plusButton.width / 2) - 4, -3, "-", function()
		{
			this.currentValue -= this.stepperSubstractValue;
			currentValue = Std.string(this.currentValue);
			inputText.text = Std.string(this.currentValue);

			if (this.currentValue <= 0 || inputText.text == '' || inputText.text == 'nan' || this.currentValue == Math.NaN)
			{
				this.currentValue = 0.1;
				inputText.text = '0.1';
			}

			if (callback != null)
				callback(this.currentValue);
		});
		minusButton.resize(20, plusButton.height);

		add(minusButton);

		var nameText:FlxUIText = new FlxUIText(-2, -17, name);
		add(nameText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (inputText.hasFocus)
		{
			inputText.hasFocus = canInput;
		}

		if (currentValue != Std.parseFloat(inputText.text))
		{
			currentValue = Std.parseFloat(inputText.text);

			callback(currentValue);
		}

		if (currentValue <= 0 || inputText.text == '' || currentValue == Math.NaN)
		{
			currentValue = 0.1;
			inputText.text = '0.1';
		}
	}
}

/**
	* Helper Class of FlxBitmapText
	** WARNING: NON-LEFT ALIGNMENT might break some position properties such as X,Y and functions like screenCenter()
	** NOTE: IF YOU WANT TO USE YOUR CUSTOM FONT MAKE SURE THEY ARE SET TO SIZE = 32
	* @param 	sizeX	Be aware that this size property can could be not equal to FlxText size.
	* @param 	sizeY	Be aware that this size property can could be not equal to FlxText size.
	* @param 	bitmapFont	Optional parameter for component's font prop
 */
class CoolText extends FlxBitmapText
{
	public function new(xPos:Float, yPos:Float, sizeX:Float, sizeY:Float, ?bitmapFont:FlxBitmapFont)
	{
		super(bitmapFont);
		x = xPos;
		y = yPos;
		scale.set(sizeX / (font.size - 2), sizeY / (font.size - 2));
		text = '';

		updateHitbox();
	}

	override function destroy()
	{
		super.destroy();
	}

	override function update(elapsed)
	{
		super.update(elapsed);
	}
	/*public function centerXPos()
		{
			var offsetX = 0;
			if (alignment == FlxTextAlign.LEFT)
				x = ((FlxG.width - textWidth) / 2);
			else if (alignment == FlxTextAlign.CENTER)
				x = ((FlxG.width - (frameWidth - textWidth)) / 2) - frameWidth;
				
	}*/
}
