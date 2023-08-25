package experimental.backend;

import flixel.FlxSprite;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.URLRequest;
import haxe.Http;
import openfl.media.Sound;
import openfl.geom.Point; // Import the correct class for Point
import flixel.sound.FlxSound; // Import the correct class for FlxSound

class InternetLoader
{
    public function addUrlImage(sprite: FlxSprite, url: String):Void
    {
        var loader: Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event: Event)
        {
            var loadedBitmap: Bitmap = cast(loader.content, Bitmap);
            sprite.makeGraphic(loadedBitmap.width, loadedBitmap.height, 0);
            // Create a placeholder graphic
            sprite.pixels.copyPixels(loadedBitmap.bitmapData, loadedBitmap.bitmapData.rect, sprite.pixels.rect);
            // Copy the loaded image data
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
                sound.loadCompressedDataFromByteArray(haxe.io.Bytes.ofString(data)); // Use Bytes.ofString to convert data to Bytes

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
