package experimental.backend;

import flixel.FlxSprite;
import com.akifox.asynchttp.*;
import openfl.display.Bitmap;

class InternetLoader
{
    public function addUrlImage(sprite: FlxSprite, url: String):Void
    {
        var request = new HttpRequest({
    		url : url,
            async : false,
			callback : function(response:HttpResponse) {
					if (response.isOK) {
						var bitmapData = new Bitmap(response.toBitmapData());
                        sprite.makeGraphic(bitmapData.width, bitmapData.height, 0);
                        sprite.pixels.copyPixels(bitmapData, bitmapData.rect, new Point());
					} else {
							trace('ERROR (HTTP STATUS ${response.status})');
		        	}
			}
		});
		request.send();
        
    }

    public function getTextFromUrl(url: String, callback: String -> Void): Void
    {
        var request = new HttpRequest({
                url : url,
                callback : function(response:HttpResponse):Void {
                    if (response.isOK) {
                        return response.toText();
                    } else {
                        return null;
                    }
                }  
        });

        request.send();
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
