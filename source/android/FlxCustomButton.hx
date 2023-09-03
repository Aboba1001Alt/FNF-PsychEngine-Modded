package android;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import openfl.display.Shape;
import android.flixel.FlxButton;

class FlxCustomButton extends FlxButton {
    public function new() {
        super(0,0);
    }
    private function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF):BitmapData
	{
		var shape:Shape = new Shape();

			shape.graphics.beginFill(Color);
			shape.graphics.lineStyle(3, Color, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.lineStyle(0, 0, 0);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();
			shape.graphics.beginGradientFill(RADIAL, [Color, FlxColor.TRANSPARENT], [0.6, 0], [0, 255], null, null, null, 0.5);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF):FlxButton
	{
		this.x = X;
        this.Y = Y;
		this.loadGraphic(createHintGraphic(Width, Height, Color));
		this.solid = false;
		this.immovable = true;
		this.scrollFactor.set();
		this.alpha = 0.00001;
		this.onDown.callback = this.onOver.callback = function()
		{
			if (this.alpha != ClientPrefs.data.hitboxalpha)
				this.alpha = ClientPrefs.data.hitboxalpha;
		}
		this.onUp.callback = this.onOut.callback = function()
		{
			if (this.alpha != 0.00001)
				this.alpha = 0.00001;
		}
		#if FLX_DEBUG
		this.ignoreDrawDebug = true;
		#end
		return this;
	}
}