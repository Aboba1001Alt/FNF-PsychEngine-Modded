package experimental.online;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

import objects.HealthIcon;
import states.editors.ChartingState;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import experimental.backend.InternetLoader;

using StringTools;

class FreeplayOnlineState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	// var selector:FlxText;
	var curSelected:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	var bg:FlxSprite;
	var scoreBG:FlxSprite;

	override function create()
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var initSonglist = CoolUtil.listFromString(InternetLoader.getTextFromUrl("https://raw.githubusercontent.com/Hiho2950/modsOnline/main/MusicList.txt"));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i]));
		}

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
			songText.targetY = i;
			songText.isMenuItem = true;
			grpSongs.add(songText);

			songText.scaleX = Math.min(1, 980 / songText.width);
			songText.snapToPosition();

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		changeSelection();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		#if mobile
		addVirtualPad(FULL, A_B_C);
		#end

		super.create();
	}

	public function addSong(songName:String)
	{
		songs.push(new SongMetadata(songName));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (FlxG.mouse.wheel != 0)
			changeSelection(-Math.round(FlxG.mouse.wheel / 4));

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new states.MainMenuState());
		}

		if (accepted)
		{
			try {
			experimental.online.PlayState.SONG = Song.loadJsonFromUrl(songs[curSelected].songName.toLowerCase());
			experimental.online.PlayState.isStoryMode = false;

			var http = new haxe.Http("https://github.com/Hiho2950/modsOnline/blob/main/songs/" + curSong + "/Inst.ogg");

			http.onBytes = function(data:Bytes) {
				experimental.online.PlayState.modinst = new Sound();
				var byteArray:ByteArray = ByteArray.fromBytes(data);
				experimental.online.PlayState.modinst.loadCompressedDataFromByteArray(byteArray, byteArray.length);
			}

			http.onError = function(e) {
				lime.app.Application.current.window.alert(e.toString(), "error:");
			}
			http.request(false);

            if (experimental.online.PlayState.SONG.needsVoices) {
			var http = new haxe.Http("https://github.com/Hiho2950/modsOnline/blob/main/songs/" + curSong + "/Voices.ogg");

			http.onBytes = function(data:Bytes) {
				experimental.online.PlayState.modvocals = new Sound();
				var byteArray:ByteArray = ByteArray.fromBytes(data);
				experimental.online.PlayState.modvocals.loadCompressedDataFromByteArray(byteArray, byteArray.length);
			}

			http.onError = function(e) {
				lime.app.Application.current.window.alert(e.toString(), "error:");
			}

			http.request(false);
			}

			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new experimental.online.PlayState());
			} catch(e:String) {
				Main.toast.create('Error', 0xFFFF0000, 'while loading song:' + songs[curSelected].songName.toLowerCase());
			}
			FlxG.sound.music.volume = 0;
		}
	}


	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		// lerpScore = 0;

		var bullShit:Int = 0;


		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";

	public function new(song:String)
	{
		this.songName = song;
	}
}