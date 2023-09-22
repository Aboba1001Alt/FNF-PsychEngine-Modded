package experimental.backend;

import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import openfl.media.Sound;
import haxe.io.Bytes;

class InternetLoader {
    public static function getTextFromUrl(url:String) {
        var text:String = "";
        var http = new haxe.Http(url);

        http.onData = function (data:String)
        {
            text = data;
        }
        http.request();
        return text;
    }
    public static function setLuaSpriteFromUrl(url:String) {
        var http = new haxe.Http(url);

        http.onBytes = function(data:Bytes)
        {
            var imageData:BitmapData = BitmapData.fromBytes(data);
            return imageData;
        };

        http.request();
        return;
    }
    public static function playURLSound(url:String):flixel.system.FlxSoundAsset {
        var http = new haxe.Http(url);

        http.onBytes = function(data:Bytes) {
            var byteArray:ByteArray = ByteArray.fromBytes(data);
            var soundb:Sound = new Sound();
            soundb.loadCompressedDataFromByteArray(byteArray, byteArray.length);
            return soundb;
        }

        http.request();
        return null;
    }
}
