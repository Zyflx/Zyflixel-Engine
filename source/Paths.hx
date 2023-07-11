package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

import openfl.utils.Assets;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, ?type:AssetType, ?library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline public static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function video(key:String)
	{
		return 'assets/videos/$key.mp4';
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	/*inline static public function stageImage(week:String ,key:String, ?subfolder:String = '')
	{
		return 'assets/$week/$subfolder' + key;
	}*/

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function character(folder:String, ?character:String = '')
	{
		return getPath('data/characters/$folder/$character');
	}

	inline static public function getCharacterAtlas(char:String, folder:String, ?isPackerAtlas:Bool = false)
	{
		if (isPackerAtlas)
			return FlxAtlasFrames.fromSpriteSheetPacker(character(folder, char + '.png'), character(folder, char + '.txt'));
		return FlxAtlasFrames.fromSparrow(character(folder, char + '.png'), character(folder, char + '.xml'));
	}

	public static function fileExists(key:String)
	{
		if (FileSystem.exists(key))
		{
			return true;
		}
		return false;
	}

	public static function getContent(key:String)
	{
		#if sys
		if (FileSystem.exists(key))
		{
			return File.getContent(key);
		}
		#else
		return Assets.getText(key);
		#end
		else
			return null;
	}

	public static function getSongs()
	{
		var songs = OpenFlAssets.list(AssetType.MUSIC);

		var songNames = [];
		
		for (song in songs)
		{
			var songSplit = song.split('/');
			var file = songSplit[2];
			songNames.push(file);
		}

		return songNames;
	}

	public static function getSounds()
	{
		var sounds = OpenFlAssets.list(AssetType.SOUND);

		var soundFiles = [];
		
		for (sound in sounds)
		{
			for (i in FileSystem.readDirectory('assets/sounds/'))
			{
				if (i.endsWith('.$SOUND_EXT'))
				{
					soundFiles.push(i);
				}
			}

			for (i in FileSystem.readDirectory('assets/shared/sounds/'))
			{
				if (i.endsWith('.$SOUND_EXT'))
				{
					soundFiles.push(i);
				}
			}
		}

		return soundFiles;
	}
		
	public static function getImages()
	{
		var imgs = OpenFlAssets.list(AssetType.IMAGE);

		var imgFiles = [];

		for (img in imgs)
		{
			// var split = img.split('/');
			// var img = split[split.length - 1];
			imgFiles.push(img);
		}

		return imgFiles;
	}

	public static function stageImage(week:String, key:String)
	{
		return getPreloadPath('$week/$key');
	}

	public static function getCharImages()
	{
		var charList = OpenFlAssets.list(AssetType.IMAGE);

		var charNames = [];

		for (char in charList)
		{
			if (char.contains('data/characters/'))
			{
				var split = char.split('/');
				var name = split[3];
				charNames.push(name);
			}
		}

		var imgFiles = [];

		for (char in charNames)
		{
			if (fileExists(character(char, char + '.png')))
			{
				imgFiles.push(char);
			}
		}

		return imgFiles;
	}
}
