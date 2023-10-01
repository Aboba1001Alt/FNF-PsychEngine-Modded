package experimental.online;

import flixel.FlxButton;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxInputText;

class ConnectSubState extends MusicBeatSubstate {
    private var connectButton: FlxButton;
    private var soloModeButton: FlxButton;
    private var ipInput: FlxInputText;

    private var onCloseCallback: Dynamic -> Void;

    public function new(onCloseCallback: Dynamic -> Void) {
        super();
        this.onCloseCallback = onCloseCallback;
    }

    override public function create():Void {
        super.create();

        // Create buttons
        connectButton = new FlxButton(100, 150, "Connect", onConnectButtonClick);
        soloModeButton = new FlxButton(100, 200, "Solo Mode", onSoloModeButtonClick);

        // Create text field input
        ipInput = new FlxInputText(100, 100, 200, "Enter IP");

        // Add buttons and text field input to the substate
        add(connectButton);
        add(soloModeButton);
        add(ipInput);
    }

    private function onConnectButtonClick():Void {
        var ip:String = ipInput.text;
        onCloseCallback("multi", ip);
    }

    private function onSoloModeButtonClick():Void {
        onCloseCallback("solo");
    }
}