package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;

class VisualsUISubState extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;
	public function new()
	{
		title = 'Misc Options';
		rpcTitle = 'Misc Options'; //for Discord Rich Presence

		var option:Option = new Option('Experimental',
			"Uncheck this if you wanna normal fnf psych engine! !not Started!",
			'experimental',
			'bool');
		addOption(option);

		super();
	}	
}
