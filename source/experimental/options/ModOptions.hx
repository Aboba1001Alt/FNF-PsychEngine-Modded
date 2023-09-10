package experimental.options;

#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.util.FlxSave;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import experimental.options.Option;
import backend.Mods;
import backend.Paths;

using StringTools;

typedef OptionData = {
	// ALL VALUES
	var name:String;
	var description:String;
	var saveKey:String;
	var type:String;
	var defaultValue:Dynamic;

	// STRING
	var options:Array<String>;
	// NUMBER
	var minValue:Dynamic;
	var maxValue:Dynamic;
	var changeValue:Dynamic;
	var scrollSpeed:Float;
	// BOTH STRING AND NUMBER
	var displayFormat:String;
}

class ModOptions extends BaseOptionsMenu {
	private var addedOptions:Array<Option>;

	public function new(modsList:Array<String>) {

		title = 'Mod Options Menu';
		rpcTitle = 'Mod Options Menu'; // for Discord Rich Presence

		for (mod in modsList) {
		var directory:String = Paths.mods(mod + '/options');
		if (FileSystem.exists(directory)) {
			for (file in FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);

				if (!FileSystem.isDirectory(path) && file.endsWith('.json')) {
					var jsonFile:OptionData = cast Json.parse(File.getContent(path));
					var defVal:Dynamic = null;
					defVal = defVal == null ? defVal = jsonFile.defaultValue : defVal;

					var option:Option = new Option(jsonFile.name, jsonFile.description, jsonFile.saveKey, jsonFile.type, jsonFile.options);
					option.defaultValue = defVal;
					option.modded = true;

					option.displayFormat = quickTernary(jsonFile.displayFormat, '%v');

					if (jsonFile.type == 'int' || jsonFile.type == 'float' || jsonFile.type == 'percent') {
						option.minValue = jsonFile.minValue;
						option.maxValue = jsonFile.maxValue;
						option.changeValue = quickTernary(jsonFile.changeValue, 1);
						option.scrollSpeed = quickTernary(jsonFile.scrollSpeed, 50);
					}

					addOption(option);
				};
			};
		};
		}

		super();
	}

	private function quickTernary(variable:Dynamic, defaultValue:Dynamic):Dynamic
	{
		return variable != null ? variable : defaultValue;
	}
}