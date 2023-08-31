package android;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import openfl.display.Shape;
import android.flixel.FlxButton;

/**
 * A zone with 4 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class FlxNewHitbox extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
    
    public var buttonSpace:FlxButton = new FlxButton(0, 0);
    
	/**
	 * Create the zone.
	 */
	public function new():Void
	{
		super();
        if (ClientPrefs.data.hitboxExtend != true){
            add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[0][0]));
		    add(buttonDown = createHint(FlxG.width / 4, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[1][0]));
		    add(buttonUp = createHint(FlxG.width / 2, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[2][0]));
		    add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[3][0]));
        }
        else{
            if (ClientPrefs.data.hitboxLocation == 'Bottom'){
        
		        add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[0][0]));
		        add(buttonDown = createHint(FlxG.width / 4, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[1][0]));
		        add(buttonUp = createHint(FlxG.width / 2, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[2][0]));
		        add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[3][0]));
                add(buttonSpace = createHint(0, (FlxG.height / 5) * 4, FlxG.width, Std.int(FlxG.height / 5), 0xFFFF00));
		    
		    }
		    else if (ClientPrefs.data.hitboxLocation == 'Top'){
		        add(buttonLeft = createHint(0, (FlxG.height / 5) * 1, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[0][0]));
		        add(buttonDown = createHint(FlxG.width / 4, (FlxG.height / 5) * 1, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[1][0]));
		        add(buttonUp = createHint(FlxG.width / 2, (FlxG.height / 5) * 1, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[2][0]));
		        add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), (FlxG.height / 5) * 1, Std.int(FlxG.width / 4), Std.int(FlxG.height * 0.8), ClientPrefs.data.arrowRGB[3][0]));
                add(buttonSpace = createHint(0, 0, FlxG.width, Std.int(FlxG.height / 5), 0xFFFF00));		    
		    
		    }
		    
		    else{
		        add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 5), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[0][0]));
		        add(buttonDown = createHint(FlxG.width / 5 * 1, 0, Std.int(FlxG.width / 5), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[1][0]));
		        add(buttonUp = createHint(FlxG.width / 5 * 3, 0, Std.int(FlxG.width / 5), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[2][0]));
		        add(buttonRight = createHint(FlxG.width / 5 * 4 , 0, Std.int(FlxG.width / 5), Std.int(FlxG.height * 1), ClientPrefs.data.arrowRGB[3][0]));
                add(buttonSpace = createHint(FlxG.width / 5 * 2, 0, Std.int(FlxG.width / 5), Std.int(FlxG.height * 1), 0xFFFF00));		    
		    
		    }
		}
		
		scrollFactor.set();
	}

	/**
	 * Clean up memory.
	 */
	override function destroy():Void
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;
		
		buttonSpace = null;
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF):FlxButton
	{
		var hint:FlxButton = new FlxButton(X, Y);
		hint.loadGraphic(Width, Height,  0xFFFFFF);
		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.color = Color;
		hint.onDown.callback = hint.onOver.callback = function()
		{
			if (hint.alpha != ClientPrefs.data.hitboxalpha)
				hint.alpha = ClientPrefs.data.hitboxalpha;
		}
		hint.onUp.callback = hint.onOut.callback = function()
		{
			if (hint.alpha != 0.00001)
				hint.alpha = 0.00001;
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}
}
