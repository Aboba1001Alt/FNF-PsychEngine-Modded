package experimental.online;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
import backend.ClientPrefs;
import backend.Paths;

using StringTools;

class OnlineHealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;

            var file:Dynamic = null;

			var http = new haxe.Http("https://raw.githubusercontent.com/Hiho2950/modsOnline/main/images/" + name + ".png");

			http.onBytes = function(data:Bytes)
			{
				var imageData:BitmapData = BitmapData.fromBytes(data);
				file = imageData;
			};

			http.onError = function(e) {
				file = Paths.image('icons/icon-face');
			}

			http.request(false);

			loadGraphic(file); //Load stupidly first for getting the file size
			var width2 = width;
			if (width > 310) {
				loadGraphic(file, true, Math.floor(width / 3), Math.floor(height));
				iconOffsets[0] = (width - 150) / 3;
				iconOffsets[1] = (width - 150) / 3;
				iconOffsets[2] = (width - 150) / 3;
			} else if (width >= 290 && width <= 310) {
				loadGraphic(file, true, Math.floor(width / 2), Math.floor(height));
				iconOffsets[0] = (width - 150) / 2;
				iconOffsets[1] = (width - 150) / 2;
			} else {
				loadGraphic(file, true, Math.floor(width), Math.floor(height));
				iconOffsets[0] = 0 - width;
				iconOffsets[1] = 0;
			}
			
			updateHitbox();
			if (width2 > 310) {
				animation.add(char, [0, 1, 2], 0, false, isPlayer);
			} else if (width2 >= 290 && width2 <= 310) {
				animation.add(char, [0, 1], 0, false, isPlayer);
			} else {
				animation.add(char, [0], 0, false, isPlayer);
			}
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.data.antialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}