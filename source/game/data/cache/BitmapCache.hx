package game.data.cache;

import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;

using StringTools;

class BitmapCache
{
    public static var cache:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();

    public static function createBitmap(path:String)
    {
        var bitmapData:BitmapData = FlxAssets.getBitmapData(path);
        var tex = FlxG.stage.context3D.createTexture(bitmapData.width, bitmapData.height, BGRA, false);
        tex.uploadFromBitmapData(bitmapData);
        bitmapData.dispose();
        bitmapData.disposeImage();
        return BitmapData.fromTexture(tex);
    }

    public static function addToCache(path:String)
    {
        var graphic:FlxGraphic = FlxGraphic.fromBitmapData(createBitmap(path));
        graphic.persist = true;
        graphic.destroyOnNoUse = false;
        cache.set(path, graphic);
    }

    public static function exists(path:String)
    {
        return cache.exists(path);
    }
}