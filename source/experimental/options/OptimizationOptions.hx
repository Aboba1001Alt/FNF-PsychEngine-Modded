package experimental.options;

import objects.Alphabet;

import experimental.options.ExperimentalOptions;
import options.OptionsState;

import flixel.FlxG;

class OptimizationOptions extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization Options';
		rpcTitle = 'Optimization Options'; //for Discord Rich Presence

		var option:Option = new Option('No char and no game cam',
			"Check this if you want the game to be faster and no game cam will be visible",
			'nocamGame',
			'bool');
		addOption(option);

		var option:Option = new Option('Less Lag',
			"Uncheck this if you wanna see your rating and combo!",
			'lessLag',
			'bool');
		addOption(option);

		var option:Option = new Option('Fast Song Loading',
			"Check this if you wanna load song faster after game over! it can optimize something unless if the memory is fully!?",
			'noDataClear',
			'bool');
		addOption(option);

		super();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK) {
			try {
				close();
			    //FlxG.resetState();
			    ClientPrefs.saveSettings();
			    //openSubState(new ExperimentalOptions());
			} catch(e:Dynamic) lime.app.Application.current.window.alert(e.toString(), "error:");
		}
		super.update(elapsed);
	}
}