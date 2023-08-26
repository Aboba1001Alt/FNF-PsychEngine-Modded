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

            sprite.makeGraphic(bitmapData.width, bitmapData.height, 0);
            sprite.pixels.copyPixels(bitmapData, bitmapData.rect, new Point());
        });
        loader.load(new URLRequest(url));
    }

    public function getTextFromUrl(url: String, callback: String -> Void): Void
    {
        var http: Http = new Http(url);
        http.onData = function(data: String)
        {
            callback(data);
        };
        http.onError = function(error: Dynamic)
        {
            Main.toast.create('Error', 0xFFFF0000, "there is an error");
        };
        http.request();
    }

    public function getSoundFromUrl(url: String, callback: FlxSound -> Void):Void
    {
        var http: Http = new Http(url);
        http.onData = function(data: String)
        {
            try
            {
                var sound: Sound = new Sound();
                var bytes: ByteArray = new ByteArray();
                bytes.writeBytes(haxe.io.Bytes.ofString(data));

                sound.loadCompressedDataFromByteArray(bytes, bytes.length);

                var flxSound: FlxSound = new FlxSound();
                flxSound.loadEmbedded(sound);

                callback(flxSound);
            }
            catch (e: Dynamic)
            {
                callback(null); // Handle error here
            }
        };
        http.onError = function(error: Dynamic)
        {
            callback(null); // Handle error here
        };
        http.request();
    }
}
