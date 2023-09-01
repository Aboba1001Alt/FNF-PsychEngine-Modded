package experimental.options;

import objects.Alphabet;
import experimental.options.OptimizationOptions;

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
        option.barValue = 25;
        option.barText = "Progress: " + option.barValue + "%";
        option.onChange = function(value: Dynamic) {
            if (value == true) Main.toast.create('Experimental', 0xFFFF0000, 'Enabled');
            else Main.toast.create('Experimental', 0xFFFF0000, 'Disabled');
        }

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
            close();
            openSubState(new OptimizationOptions());
        }

        super();
    }
}
