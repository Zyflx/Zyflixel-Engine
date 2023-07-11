package game.state;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

import openfl.Assets;
import openfl.system.System;
import openfl.utils.Assets as OpenFlAssets;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import game.data.cache.BitmapCache;

using StringTools;

class CacheState extends FlxState
{
    var txt:FlxText;

    var images:Array<String> = [];
    var chars:Array<String> = [];
    var songs:Array<String> = [];
    var sounds:Array<String> = [];

    var cachedImages:Bool = false;
    var cachedChars:Bool = false;
    var cachedSongs:Bool = false;
    var cachedSounds:Bool = false;
    var cachedAll:Bool = false;

    var nextState:FlxState = new game.state.menus.TitleState();

    override function create()
    {
        txt = new FlxText(0, 0, 0, 'Caching...', 30);
        txt.setFormat(Paths.font('vcr.ttf'), 30);
        txt.screenCenter(XY);
        add(txt);
        
        #if sys
        sys.thread.Thread.create(() -> {
            cacheSongs();
        });
        #else
        cacheSongs();
        #end

        super.create();
    }

    override function update(elapsed:Float)
    {
        txt.screenCenter(XY);
        
        if (cachedAll) {
            System.gc();
            new FlxTimer().start(1, function(tmr:FlxTimer) { txt.text = 'Done!'; });
            new FlxTimer().start(2, function(tmr:FlxTimer)
            {
                FlxG.switchState(nextState);
            });
        }

        super.update(elapsed);
    }

    function cacheSongs()
    {
        var songList = Paths.getSongs();

        for (i in songList)
        {
            if (Assets.exists(Paths.inst(i)))
            {
                FlxG.sound.cache(Paths.inst(i));
                songs.push(i);
            }
            
            if (Assets.exists(Paths.voices(i)))
            {
                FlxG.sound.cache(Paths.voices(i));
            }
        }

        trace('Songs Cached.');
        txt.text = 'Songs Cached...';
        cachedSongs = true;
        cacheSounds();
    }

    function cacheSounds()
    {
        var soundList = Paths.getSounds();

        for (i in soundList)
        {
            var replace = i.replace('.${Paths.SOUND_EXT}', '');

            if (Assets.exists(Paths.sound(replace, 'shared')))
            {
                FlxG.sound.cache(Paths.sound(replace, 'shared'));
                sounds.push(i);
            }
            else {
                FlxG.sound.cache(Paths.sound(replace));
                sounds.push(i);
            }
        }

        trace('Sounds Cached.');
        txt.text = 'Sounds Cached...';
        cachedSounds = true;
        cacheImages();
    }

    function cacheImages()
    {
        var imgs = Paths.getImages();

        for (i in FileSystem.readDirectory('assets/images/'))
        {
            if (i.endsWith('.png'))
            {
                var path = Paths.getPath('images/$i', IMAGE);
                BitmapCache.addToCache(path);
                images.push(i);
            }
        }
    
        for (i in FileSystem.readDirectory('assets/shared/images/'))
        {
            if (i.endsWith('.png'))
            {
                var path = Paths.image(i.replace('.png', ''), 'shared');
                BitmapCache.addToCache(path);
                images.push(i);
            }
        }

        trace('Images Cached.');
        txt.text = 'Images Cached...';
        cachedImages = true;
        cacheCharacters();
    }

    function cacheCharacters()
    {
        var characters = Paths.getCharImages();

        for (i in characters)
        {
            var path = Paths.character(i, i + '.png');
            BitmapCache.addToCache(path);
            chars.push(i);
        }

        trace('Characters Cached.');
        txt.text = 'Characters Cached...';
        cachedChars = true;
        cachedAll = true;
    }
}