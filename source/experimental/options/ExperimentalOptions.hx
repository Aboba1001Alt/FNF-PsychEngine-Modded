package experimental.options;

import objects.Alphabet;

import experimental.options.OptimizationOptions;
import options.OptionsState;

class ExperimentalOptions extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Experimental Options';
		rpcTitle = 'Experimental Options'; //for Discord Rich Presence

		var option:Option = new Option('Experimental',
			"Uncheck this if you wanna normal fnf psych engine! !not Finished!",
			'experimental',
			'bool');
		addOption(option);
		option.barVisible = true;
		option.barValue = 25;
		option.barText = "Progress: " + option.barValue + "%";
		option.onChange = function(value:Dynamic) {
			if (value == true) Main.toast.create('Experimental', 0xFFFF0000, 'Enabled');
			else Main.toast.create('Experimental', 0xFFFF0000, 'Disabled');
		}

		var option:Option = new Option('Old versions Support !not Done!',
			"Check this if you wanna have backwards for properties functions!",
			'oldSupport',
			'bool');
		addOption(option);

		var option:Option = new Option('Optimization Options',
			"Press Enter to enter optimization options",
			null,
			'functionnal');
		addOption(option);
		option.onChange = function(value:Dynamic) {
			close();
			backend.MusicBeatState.openSubState(new OptimizationOptions());
		}

		super();
	}	
}
