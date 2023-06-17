package funkin._backend.system;

#if FEATURE_DISCORD
import funkin._backend.utils.Discord.DiscordClient;
#end
import openfl.display.BlendMode;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
#if !html5
// crash handler stuff
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
#end
import funkin.menus.TitleState;
import funkin._backend.polymod.ModCore;
import funkin._backend.system.monitor.StatsCounter;

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var watermarks = true; // Whether to put Kade Engine literally anywhere

	public static var focused:Bool = true; // Whether the game is currently focused or not.

	public static var appName:String = ''; // Application name.

	public static var internetConnection:Bool = false; // If the user is connected to internet.

	public static var gameContainer:Main = null; // Main instance to access when needed.

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		// quick checks

		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		// Run this first so we can see logs.
		Debug.onInitProgram();

		// Gotta run this before any assets get loaded.
		#if FEATURE_MODCORE
		ModCore.initialize();
		#end

		#if FEATURE_DISCORD
		DiscordClient.initialize();
		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
			FlxG.save.close();
		});
		#end

		game.framerate = Application.current.window.displayMode.refreshRate;

		#if !mobile
		fpsCounter = new StatsCounter(10, 10, 0xFFFFFF);
		#end
		gameContainer = this;

		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));

		FlxG.fixedTimestep = false;

		FlxG.signals.focusGained.add(function()
		{
			focused = true;
			setFPSCap(FlxG.save.data.fpsCap);
		});
		FlxG.signals.focusLost.add(function()
		{
			focused = false;
		});

		FlxG.signals.postStateSwitch.add(function()
		{
			Paths.runGC();
		});

		#if !mobile
		addChild(fpsCounter);
		#end

		// Finish up loading debug tools.
		Debug.onGameStart();

		#if desktop
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		// Get first window in case the coder creates more windows.
		@:privateAccess
		appName = openfl.Lib.application.windows[0].__backend.parent.__attributes.title;
		#end
	}

	var fpsCounter:StatsCounter;

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
	}

	public function setFPSCap(cap:Int)
	{
		FlxG.updateFramerate = cap;
		FlxG.drawFramerate = FlxG.updateFramerate;
	}

	public function checkInternetConnection()
	{
		Debug.logInfo('Checking Internet connection through URL: https://www.google.com"');
		var http = new haxe.Http("https://www.google.com");
		http.onStatus = function(status:Int)
		{
			switch status
			{
				case 200: // success
					internetConnection = true;
					Debug.logInfo('CONNECTED');
				default: // error
					internetConnection = false;
					Debug.logInfo('NO INTERNET CONNECTION');
			}
		};

		http.onError = function(e)
		{
			internetConnection = false;
			Debug.logInfo('NO INTERNET CONNECTION');
		}

		http.request();
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if !html5 // because of how it show up on desktop
	function onCrash(e:UncaughtErrorEvent):Void
	{
		if (FlxG.fullscreen)
			FlxG.fullscreen = !FlxG.fullscreen;

		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		path = "./crash/" + "KadeEngine_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: "
			+ e.error
			+ "\nPlease report this error to My Github page: https://github.com/BoloVEVO/Kade-Engine\n\nCrash dump saved in crash folder as "
			+ "KadeEngine_"
			+ dateNow
			+ ".txt"
			+ "\n\n> Crash Handler written by: sqirra-rng";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
}
