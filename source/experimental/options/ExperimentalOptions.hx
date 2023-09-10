package experimental.options;

import objects.Alphabet;
import experimental.options.OptimizationOptions;
import experimental.options.ModOptions;

import backend.Paths;
import backend.Mods;

import flixel.FlxG;

class ExperimentalOptions extends BaseOptionsMenu {
    public function new() {
        title = 'Experimental Options';
        rpcTitle = 'Experimental Options'; // for Discord Rich Presence

        var option: Option = new Option('Experimental',
            "Uncheck this if you want the normal fnf psych engine! (Not Finished!)",
            'experimental',
            'bool'
        );
        addOption(option);
        option.barVisible = true;
        option.barValue = 40;
        option.barText = "Progress: " + option.barValue + "%";
        option.onChange = function(value: Dynamic) {
            if (value == true) Main.toast.create('Experimental', 0xFFFFC000, 'Enabled');
            else Main.toast.create('Experimental', 0xFFFF0000, 'Disabled');
        }

        var option: Option = new Option('Ultimate ModChart Functions',
            "Credits to TheZoroForce240 and pull request #47",
            'ultiModchart',
            'bool'
        );
        addOption(option);

        var option: Option = new Option('Old versions Support (Not Done!)',
            "Check this if you want support for older properties and functions!",
            'oldSupport',
            'bool'
        );
        addOption(option);

        var option: Option = new Option('Optimization Options',
            "Press Enter to enter optimization options",
            null,
            'functionnal'
        );
        addOption(option);
        option.onChange = function(value: Dynamic) {
            try {
			ClientPrefs.saveSettings();
            openSubState(new OptimizationOptions());
            } catch(e:Dynamic) lime.app.Application.current.window.alert(e.toString(), "error:");
        }

        var option: Option = new Option('Mod Options',
            "Press Enter to enter mods options!Not Fixed YET!",
            null,
            'functionnal'
        );
        addOption(option);
        option.onChange = function(value: Dynamic) {
            try {
			ClientPrefs.saveSettings();
            var mods:Array<String> = Mods.getModDirectories();
            mods.insert(0, 'Global');

            for (mod in mods) {
                if (!Paths.optionsExist(mod == 'Global' ? '' : mod)) {
                    mods.remove(mod);
			    }
		    }
            openSubState(new ModOptions(mods));
            } catch(e:Dynamic) lime.app.Application.current.window.alert(e.toString(), "error:");
        }

        super();
    }
}
