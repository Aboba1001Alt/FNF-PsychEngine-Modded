package experimental.online.scripting;

import flixel.FlxBasic;
import objects.Character;
import psychlua.CustomSubstate;
import psychlua.FunkinLua;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import haxe.io.Bytes;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.display.BitmapData;
import flixel.FlxSprite;

#if (HSCRIPT_ALLOWED && BrewScript)
import brew.BrewScript;
class OnlineScript extends BrewScript
{
	override public function new(url:String)
	{
		super(null, false, false);
		doScript(experimental.backend.InternetLoader.getTextFromUrl(url));
		preset();
		execute();
	}

	override function preset()
	{
		#if (BrewScript)
		super.preset();

		// Some very commonly used classes
		set('FlxG', flixel.FlxG);
		set('FlxSprite', flixel.FlxSprite);
		set('FlxCamera', flixel.FlxCamera);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxColor', CustomFlxColor.instance);
		set('PlayState', PlayState);
		set('Paths', Paths);
		set('Conductor', Conductor);
		set('ClientPrefs', ClientPrefs);
		set('Character', Character);
		set('Alphabet', Alphabet);
		set('Note', objects.Note);
		set('CustomSubstate', CustomSubstate);
		set('Countdown', backend.BaseStage.Countdown);
		#if (!flash && sys)
		set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);
		#end
		set('ShaderFilter', openfl.filters.ShaderFilter);
		set('StringTools', StringTools);

		// Functions & Variables
		set('setVar', function(name:String, value:Dynamic)
		{
			experimental.online.PlayState.instance.variables.set(name, value);
		});
		set('getVar', function(name:String)
		{
			var result:Dynamic = null;
			if(experimental.online.PlayState.instance.variables.exists(name)) result = experimental.online.PlayState.instance.variables.get(name);
			return result;
		});
		set('removeVar', function(name:String)
		{
			if(experimental.online.PlayState.instance.variables.exists(name))
			{
				experimental.online.PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
		set('debugPrint', function(text:String, ?color:FlxColor = null) {
			if(color == null) color = FlxColor.WHITE;
			experimental.online.PlayState.instance.addTextToDebug(text, color);
		});

        set("setSpriteImage", function(sprite:FlxSprite, image:String) {
            var http = new haxe.Http("https://raw.githubusercontent.com/Hiho2950/modsOnline/main/image/" + image + ".png");

            http.onBytes = function(data:Bytes)
            {
                var imageData:BitmapData = BitmapData.fromBytes(data);
                sprite.loadGraphic(imageData);
            };

            http.request(false);
		});

        set("setAnimatedSpriteImage", function(sprite:FlxSprite, image:String) {
            var http = new haxe.Http("https://raw.githubusercontent.com/Hiho2950/modsOnline/main/images/" + image + ".png");

            http.onBytes = function(data:Bytes)
            {
                var imageData:BitmapData = BitmapData.fromBytes(data);
                sprite.frames = FlxAtlasFrames.fromSparrow(imageData, experimental.backend.InternetLoader.getTextFromUrl("https://raw.githubusercontent.com/Hiho2950/modsOnline/main/images/" + image + ".xml"));
            };

            http.request(false);
		});

		set('this', this);
		set('game', experimental.online.PlayState.instance);
		set('buildTarget', FunkinLua.getBuildTarget());
		set('customSubstate', CustomSubstate.instance);
		set('customSubstateName', CustomSubstate.name);

		set('Function_Stop', FunkinLua.Function_Stop);
		set('Function_Continue', FunkinLua.Function_Continue);
		set('Function_StopLua', FunkinLua.Function_StopLua);
		set('Function_StopHScript', FunkinLua.Function_StopHScript);
		set('Function_StopAll', FunkinLua.Function_StopAll);
		
		set('add', function(obj:FlxBasic) experimental.online.PlayState.instance.add(obj));
		set('addBehindGF', function(obj:FlxBasic) experimental.online.PlayState.instance.addBehindGF(obj));
		set('addBehindDad', function(obj:FlxBasic) experimental.online.PlayState.instance.addBehindDad(obj));
		set('addBehindBF', function(obj:FlxBasic) experimental.online.PlayState.instance.addBehindBF(obj));
		set('insert', function(pos:Int, obj:FlxBasic) experimental.online.PlayState.instance.insert(pos, obj));
		set('remove', function(obj:FlxBasic, splice:Bool = false) experimental.online.PlayState.instance.remove(obj, splice));
		#end
	}

	public function destroy()
	{
		active = false;
	}
}
#end

@:publicFields
class CustomFlxColor
{
	static var instance:CustomFlxColor = new CustomFlxColor();
	function new() {}

	var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	var WHITE(default, null):Int = FlxColor.WHITE;
	var GRAY(default, null):Int = FlxColor.GRAY;
	var BLACK(default, null):Int = FlxColor.BLACK;

	var GREEN(default, null):Int = FlxColor.GREEN;
	var LIME(default, null):Int = FlxColor.LIME;
	var YELLOW(default, null):Int = FlxColor.YELLOW;
	var ORANGE(default, null):Int = FlxColor.ORANGE;
	var RED(default, null):Int = FlxColor.RED;
	var PURPLE(default, null):Int = FlxColor.PURPLE;
	var BLUE(default, null):Int = FlxColor.BLUE;
	var BROWN(default, null):Int = FlxColor.BROWN;
	var PINK(default, null):Int = FlxColor.PINK;
	var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	var CYAN(default, null):Int = FlxColor.CYAN;

	function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
	{
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);
	}
	function getRGB(color:Int):Array<Int>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.red, flxcolor.green, flxcolor.blue, flxcolor.alpha];
	}
	function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);
	}
	function getRGBFloat(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.redFloat, flxcolor.greenFloat, flxcolor.blueFloat, flxcolor.alphaFloat];
	}
	function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}
	function getCMYK(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.cyan, flxcolor.magenta, flxcolor.yellow, flxcolor.black, flxcolor.alphaFloat];
	}
	function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);
	}
	function getHSB(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.hue, flxcolor.saturation, flxcolor.brightness, flxcolor.alphaFloat];
	}
	function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);
	}
	function getHSL(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.hue, flxcolor.saturation, flxcolor.lightness, flxcolor.alphaFloat];
	}
	function fromString(str:String):Int
	{
		return cast FlxColor.fromString(str);
	}
	function getHSBColorWheel(Alpha:Int = 255):Array<Int>
	{
		return cast FlxColor.getHSBColorWheel(Alpha);
	}
	function interpolate(Color1:Int, Color2:Int, Factor:Float = 0.5):Int
	{
		return cast FlxColor.interpolate(Color1, Color2, Factor);
	}
	function gradient(Color1:Int, Color2:Int, Steps:Int, ?Ease:Float->Float):Array<Int>
	{
		return cast FlxColor.gradient(Color1, Color2, Steps, Ease);
	}
	function multiply(lhs:Int, rhs:Int):Int
	{
		return cast FlxColor.multiply(lhs, rhs);
	}
	function add(lhs:Int, rhs:Int):Int
	{
		return cast FlxColor.add(lhs, rhs);
	}
	function subtract(lhs:Int, rhs:Int):Int
	{
		return cast FlxColor.subtract(lhs, rhs);
	}
	function getComplementHarmony(color:Int):Int
	{
		return cast FlxColor.fromInt(color).getComplementHarmony();
	}
	function getAnalogousHarmony(color:Int, Threshold:Int = 30):CustomHarmony
	{
		return cast FlxColor.fromInt(color).getAnalogousHarmony(Threshold);
	}
	function getSplitComplementHarmony(color:Int, Threshold:Int = 30):CustomHarmony
	{
		return cast FlxColor.fromInt(color).getSplitComplementHarmony(Threshold);
	}
	function getTriadicHarmony(color:Int):CustomTriadicHarmony
	{
		return cast FlxColor.fromInt(color).getTriadicHarmony();
	}
	function to24Bit(color:Int):Int
	{
		return color & 0xffffff;
	}
	function toHexString(color:Int, Alpha:Bool = true, Prefix:Bool = true):String
	{
		return cast FlxColor.fromInt(color).toHexString(Alpha, Prefix);
	}
	function toWebString(color:Int):String
	{
		return cast FlxColor.fromInt(color).toWebString();
	}
	function getColorInfo(color:Int):String
	{
		return cast FlxColor.fromInt(color).getColorInfo();
	}
	function getDarkened(color:Int, Factor:Float = 0.2):Int
	{
		return cast FlxColor.fromInt(color).getDarkened(Factor);
	}
	function getLightened(color:Int, Factor:Float = 0.2):Int
	{
		return cast FlxColor.fromInt(color).getLightened(Factor);
	}
	function getInverted(color:Int):Int
	{
		return cast FlxColor.fromInt(color).getInverted();
	}
}
typedef CustomHarmony = {
	original:Int,
	warmer:Int,
	colder:Int
}
typedef CustomTriadicHarmony = {
	color1:Int,
	color2:Int,
	color3:Int
}