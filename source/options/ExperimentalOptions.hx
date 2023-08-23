package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;

class ExperimentalOptions extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;
	public function new()
	{
		title = 'Experimental Options';
		rpcTitle = 'Experimental Options'; //for Discord Rich Presence

		var option:Option = new Option('Experimental',
			"Uncheck this if you wanna normal fnf psych engine! !not Finished 5%!",
			'experimental',
			'bool');
		addOption(option);

		var option:Option = new Option('Old versions Support !not Done!',
			"Check this if you wanna have backwards for properties functions!",
			'oldSupport',
			'bool');
		addOption(option);

		var option:Option = new Option('Less Lag',
			"Uncheck this if you wanna see your rating and combo!",
			'lessLag',
			'bool');
		addOption(option);

		var option:Option = new Option('Fast Song Loading',
			"Check this if you wanna load song faster after game over!",
			'noDataClear',
			'bool');
		addOption(option);

		super();
	}	
}
