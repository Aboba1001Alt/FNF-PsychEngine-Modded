package states;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var updateLog:String;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var http = new haxe.Http("https://raw.githubusercontent.com/Hiho2950/FNF-PsychEngine-Modded/main/updateText.txt");

		http.onData = function (data:String)
		{
			updateLog = data;
		}

		http.onError = function (error) {
			trace('error: $error');
		}

		http.request();

		warnText = new FlxText(0, 0, FlxG.width,
			"Sup bro, looks like you're running an   \n
			outdated version of Unknown Engine (" + MainMenuState.unknownEngineVersion + "),\n
			please update to " + TitleState.updateVersion + "!\n
			What's new?\n" + updateLog + "\n
			Press B to proceed anyway.\n
			\n
			Thank you for using the Engine!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		warnText.screenCenter(Y);
		add(warnText);

    #if mobile
    addVirtualPad(NONE, A_B);
    #end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/Hiho2950/FNF-PsychEngine-Modded/releases");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
