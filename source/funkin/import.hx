package funkin;

#if !macro
import funkin._backend.MusicBeatState;
import funkin._backend.MusicBeatSubstate;
import haxe.Json;
import funkin._backend.chart.Section;
import funkin._backend.chart.Song;
import funkin._backend.chart.Conductor;
import funkin._backend.chart.TimingStruct;
import funkin._backend.chart.ChartEventHandler;
import funkin._backend.system.Main;
import funkin._backend.system.monitor.Debug;
import funkin._backend.utils.FNFShader;
import funkin._backend.utils.Paths;
import funkin.gameplay.PlayState;
import funkin._backend.utils.CoolUtil;
import funkin.menus.objects.Alphabet;
import funkin._backend.utils.CoolUtil;
import funkin._backend.system.Controls;
import funkin.menus.PsychTransition;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets as LimeAssets;
import funkin._backend.utils.HelperFunctions;
#if FEATURE_FILESYSTEM
import sys.io.File;
import sys.FileSystem;
#end
import openfl.Lib;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxState;
import flixel.FlxSubState;
#if FEATURE_DISCORD
import funkin._backend.utils.Discord.DiscordClient;
#end
#if (FEATURE_MP4VIDEOS && !html5)
import hxcodec.flixel.FlxVideo as VideoHandler;
import hxcodec.flixel.FlxVideoSprite as VideoSprite;
#else
import funkin._backend.media.webm.FlxVideo;
#end

using StringTools;
#end
