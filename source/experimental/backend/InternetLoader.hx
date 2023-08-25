package experimental.backend;

import flixel.FlxSprite;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.URLRequest;
import haxe.Http;
import openfl.media.Sound;
import openfl.utils.ByteArray;
import openfl.geom.Point;
import flixel.sound.FlxSound;

class InternetLoader
{
    public function addUrlImage(sprite: FlxSprite, url: String):Void
    {
        var loader: Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event: Event)
        {
            var loadedBitmap: Bitmap = cast(loader.content, Bitmap);
            var bitmapData = loadedBitmap.bitmapData;

            sprite.makeGraphic(Std.int(bitmapData.width), Std.int(bitmapData.height), 0);
            sprite.pixels.copyPixels(bitmapData, bitmapData.rect, new Point());
        });
        loader.load(new URLRequest(url));
    }

    public function getTextFromUrl(url: String, callback: String -> String -> Void):Void
    {
        var http: Http = new Http(url);
        http.onData = function(data: String):Void
        {
            callback("data", data);
        };
        http.onError = function(error: Dynamic):Void
        {
            callback("error", error);
        };
        http.request();
    }

    public function getSoundFromUrl(url: String, callback: String -> Dynamic -> Void):Void
    {
        var http: Http = new Http(url);
        http.onData = function(data: String):Void
        {
            try
            {
                var sound: Sound = new Sound();
                var bytes: ByteArray = new ByteArray();
                bytes.writeBytes(haxe.io.Bytes.ofString(data));

                sound.loadCompressedDataFromByteArray(bytes, bytes.length);

                var flxSound: FlxSound = new FlxSound();
                flxSound.loadEmbedded(sound);

                callback("data", flxSound);
            }
            catch (e: Dynamic)
            {
                callback("error", "Error loading sound: " + Std.string(e));
            }
        };
        http.onError = function(error: Dynamic):Void
        {
            callback("error", "HTTP Error: " + Std.string(error));
        };
        http.request();
    }
}
