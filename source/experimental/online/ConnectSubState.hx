package experimental.online;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.ui.FlxInputText;

class ConnectSubState extends MusicBeatSubstate {
    private var connectButton: FlxButton;
    private var soloModeButton: FlxButton;
    private var ipInput: FlxInputText;

    private var onCloseCallback: (Dynamic, String) -> Void;

    public function new(onCloseCallback: (Dynamic, String) -> Void) {
        super();
        this.onCloseCallback = onCloseCallback;
    }

    override public function create():Void {
        super.create();

        // Create buttons
        connectButton = new FlxButton(100, 250, "Connect", onConnectButtonClick);
        soloModeButton = new FlxButton(100, 400, "Solo Mode", onSoloModeButtonClick);
        createButton = new FlxButton(100, 600, "Create Server", onCreateButtonClick);
        connectButton.scale.set(2,2);
        createButton.scale.set(2,2);
        soloModeButton.scale.set(2,2);
        soloModeButton.updateHitbox();
        createButton.updateHitbox();
        connectButton.updateHitbox();
        connectButton.screenCenter(X);
        soloModeButton.screenCenter(X);
        createButton.screenCenter(X);

        // Create text field input
        ipInput = new FlxInputText(100, 100, 200, "Enter IP");
        ipInput.scale.set(2,2);
        ipInput.updateHitbox();
        ipInput.screenCenter(X);


        // Add buttons and text field input to the substate
        add(connectButton);
        add(soloModeButton);
        add(ipInput);
    }

    private function onConnectButtonClick():Void {
        experimental.online.PlayOnlineState.playerMode = "opp";
        var ip:String = ipInput.text;
        onCloseCallback("multi", ip);
    }

    private function onCreateButtonClick():Void {
        experimental.online.PlayOnlineState.playerMode = "player";
        onCloseCallback("multi", "");
    }

    private function onSoloModeButtonClick():Void {
        onCloseCallback("solo", "");
    }
}