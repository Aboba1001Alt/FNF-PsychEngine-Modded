package experimental.backend;

import flixel.FlxSprite;
import yloader.impl.js.XMLHttpRequestLoader;
import yloader.valueObject.Parameter;
import yloader.valueObject.Request;
import yloader.valueObject.Response;
import openfl.display.BitmapData; // Fixed import
import openfl.events.Event;
import openfl.net.URLRequest;
import haxe.Http;
import openfl.media.Sound;
import openfl.utils.ByteArray;
import openfl.geom.Point;
import flixel.sound.FlxSound;

class InternetLoader
{
    public function new() {}
    public function addUrlImage(sprite: FlxSprite, url: String):Void
    {
        var request = new Request(url);

        var loader = new XMLHttpRequestLoader(request); // or use Loader.create()
        loader.onResponse = function(response:Response) {
            if(response.success) {
        		var bitmap = new BitmapData().fromBytes(response.data); // Corrected BitmapData creation
                sprite.makeGraphic(bitmap.width, bitmap.height, 0);
                sprite.pixels.copyPixels(bitmap, bitmap.rect, new Point());
            }
        };
        loader.load();
    }

    public function getTextFromUrl(url: String, callback: String -> Void):Void // Changed return type
    {
        var request = new Request(url);

        var loader = new XMLHttpRequestLoader(request); // or use Loader.create()
        loader.onResponse = function(response:Response) {
            if(response.success)
        		callback(Std.string(response.data));
        	else
        		callback(null);
        };
        loader.load();
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
