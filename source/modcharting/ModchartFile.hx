package modcharting;
import flixel.math.FlxMath;
import haxe.Exception;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
#if LEATHER
import states.PlayState;
import game.Note;
import game.Conductor;
#if polymod
import polymod.backends.PolymodAssets;
#end
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end
using StringTools;

typedef ModchartJson = 
{
    var modifiers:Array<Array<Dynamic>>;
    var events:Array<Array<Dynamic>>;
    var playfields:Int;
}


class ModchartFile
{

    //used for indexing
    public static final MOD_NAME = 0; //the modifier name
    public static final MOD_CLASS = 1; //the class/custom mod it uses
    public static final MOD_TYPE = 2; //the type, which changes if its for the player, opponent, a specific lane or all
    public static final MOD_PF = 3; //the playfield that mod uses
    public static final MOD_LANE = 4; //the lane the mod uses

    public static final EVENT_TYPE = 0; //event type (set or ease)
    public static final EVENT_DATA = 1; //event data
    public static final EVENT_REPEAT = 2; //event repeat data

    public static final EVENT_TIME = 0; //event time (in beats)
    public static final EVENT_SETDATA = 1; //event data (for sets)
    public static final EVENT_EASETIME = 1; //event ease time
    public static final EVENT_EASE = 2; //event ease
    public static final EVENT_EASEDATA = 3; //event data (for eases)

    public static final EVENT_REPEATBOOL = 0; //if event should repeat
    public static final EVENT_REPEATCOUNT = 1; //how many times it repeats
    public static final EVENT_REPEATBEATGAP = 2; //how many beats in between each repeat


    public var data:ModchartJson = null;
    private var renderer:PlayfieldRenderer;
    public var scriptListen:Bool = false;
    public var customModifiers:Map<String, CustomModifierScript> = new Map<String, CustomModifierScript>();
    public function new(renderer:PlayfieldRenderer)
    {

        data = loadFromJson(PlayState.SONG.song.toLowerCase());
        this.renderer = renderer;
        renderer.modchart = this;
        loadPlayfields();
        loadModifiers();
        loadEvents();
    }

    public function loadFromJson(folder:String):ModchartJson //load da shit
    {
        var rawJson = null;
        var folderShit:String = "";
        #if sys
        #if PSYCH
		var moddyFile:String = Paths.modsJson(Paths.formatToSongPath(folder) + '/modchart');
		if(FileSystem.exists(moddyFile)) {
			rawJson = File.getContent(moddyFile).trim();
            folderShit = moddyFile.replace("modchart.json", "customMods/");
		}
		#end
        #end
        if (rawJson == null)
        {
            #if LEATHER
            var filePath = Paths.json("song data/" + folder + '/modchart');
            folderShit = PolymodAssets.getPath(filePath.replace("modchart.json", "customMods/"));
            #else 
            var filePath = Paths.json(folder + '/modchart');
            folderShit = filePath.replace("modchart.json", "customMods/");
            #end
            
            //trace(filePath);
            #if sys
            if(FileSystem.exists(filePath))
                rawJson = File.getContent(filePath).trim();
            else #end //should become else if i think???
                if (Assets.exists(filePath))
                    rawJson = Assets.getText(filePath).trim();
                
        }
        var json:ModchartJson = null;
        if (rawJson != null)
        {
            json = cast Json.parse(rawJson);
            //trace('loaded json');
            trace(folderShit);
            #if sys
            if (FileSystem.isDirectory(folderShit))
            {
                //trace("folder le exists");
                for (file in FileSystem.readDirectory(folderShit))
                {
                    //trace(file);
                    if(file.endsWith('.hx')) //custom mods!!!!
                    {
                        var script = new CustomModifierScript(file);
                        //trace('loaded custom mod: ' + file);
                    }
                }
            }
            #end
        }
        else 
        {
            json = {modifiers: [], events: [], playfields: 1};
        }
        return json;
    }
    public function loadEmpty()
    {
        data.modifiers = [];
        data.events = [];
        data.playfields = 1;
    }

    public function loadModifiers()
    {
        if (data == null || renderer == null)
            return;
        renderer.modifierTable.clear();
        for (i in data.modifiers)
        {
            ModchartFuncs.startMod(i[MOD_NAME], i[MOD_CLASS], i[MOD_TYPE], Std.parseInt(i[MOD_PF]), renderer.instance);
            if (i[MOD_LANE] != null)
                ModchartFuncs.setModTargetLane(i[MOD_NAME], i[MOD_LANE], renderer.instance);
        }
        renderer.modifierTable.reconstructTable();
    }
    public function loadPlayfields()
    {
        if (data == null || renderer == null)
            return;

        renderer.playfields = [];
        for (i in 0...data.playfields)
            renderer.addNewPlayfield(0,0,0,1);
    }
    public function loadEvents()
    {
        if (data == null || renderer == null)
            return;
        renderer.eventManager.clearEvents();
        for (i in data.events)
        {
            if (i[EVENT_REPEAT] == null) //add repeat data if it doesnt exist
                i[EVENT_REPEAT] = [false, 1, 0];

            if (i[EVENT_REPEAT][EVENT_REPEATBOOL])
            {
                for (j in 0...(Std.int(i[EVENT_REPEAT][EVENT_REPEATCOUNT])+1))
                {
                    addEvent(i, (j*i[EVENT_REPEAT][EVENT_REPEATBEATGAP]));
                }
            }
            else 
            {
                addEvent(i);
            }

        }
    }
    private function addEvent(i:Array<Dynamic>, ?beatOffset:Float = 0)
    {
        switch(i[EVENT_TYPE])
        {
            case "ease": 
                ModchartFuncs.ease(Std.parseFloat(i[EVENT_DATA][EVENT_TIME])+beatOffset, Std.parseFloat(i[EVENT_DATA][EVENT_EASETIME]), i[EVENT_DATA][EVENT_EASE], i[EVENT_DATA][EVENT_EASEDATA], renderer.instance);
            case "set": 
                ModchartFuncs.set(Std.parseFloat(i[EVENT_DATA][EVENT_TIME])+beatOffset, i[EVENT_DATA][EVENT_SETDATA], renderer.instance);
            case "hscript": 
                //maybe just run some code???
        }
    }

    public function createDataFromRenderer() //a way to convert script modcharts into json modcharts
    {
        if (renderer == null)
            return;

        data.playfields = renderer.playfields.length;
        scriptListen = true;
    }
}

class CustomModifierScript extends brew.BrewScript
{
    public function new(file:String)
    {
        try
        {
            if (file == null)
			    file = '';
			
		    super(null, false, false);
            doFile(file);

            preset();
            execute();
        }
        catch(e)
        {
            lime.app.Application.current.window.alert(e.message, 'Error on custom mod .hx!');
            return;
        }
    }
    override function preset()
    {
        super.preset();
        set('Math', Math);
        set('PlayfieldRenderer', PlayfieldRenderer);
        set('ModchartUtil', ModchartUtil);
        set('Modifier', Modifier);
        set('ModifierSubValue', Modifier.ModifierSubValue);
        set('BeatXModifier', Modifier.BeatXModifier);
        set('NoteMovement', NoteMovement);
        set('NotePositionData', NotePositionData);
        set('ModchartFile', ModchartFile);
        set('FlxG', flixel.FlxG);
		set('FlxSprite', flixel.FlxSprite);
        set('FlxMath', FlxMath);
		set('FlxCamera', flixel.FlxCamera);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('PlayState', states.PlayState);
		set('game', states.PlayState.instance);
		set('Paths', backend.Paths);
		set('Conductor', backend.Conductor);
        set('StringTools', StringTools);
        set('Note', objects.Note);

        #if PSYCH
        set('ClientPrefs', backend.ClientPrefs);
        set('ColorSwap', shaders.ColorSwap);
        #end
    }
    public function initMod(mod:Modifier)
    {
        try {
            if (exists("initMod")) call("initMod", [mod]);
        }
        catch(e)
        {
            lime.app.Application.current.window.alert(e.message, 'Error on custom mod .hx!');
        }
    }
}
