package experimental.backend;

import backend.CoolUtil;
import lime.utils.Assets;
import haxe.Json;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import states.PlayState;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

using StringTools;

class AdditionalStageData {
	public var stage:String = "";

	private var stage_Data:AddedStageData;

	public var stage_Objects:Array<Array<Dynamic>> = [];

	public function updateStage(?newStage:String) {
		if (newStage != null)
			stage = newStage;

		if (stage != "") {
			var JSON_Data:String = "";

			JSON_Data = File.getContent(Paths.mods("stages/" + stage + "-stage.json"));
			stage_Data = cast Json.parse(JSON_Data);
		}

		if (stage != "") {
			switch (stage) {
				// CUSTOM SHIT
				default:
					{
						if (stage_Data != null) {
							var null_Object_Name_Loop:Int = 0;

							for (Object in stage_Data.objects) {
								var Sprite = new psychlua.ModchartSprite(Object.position[0], Object.position[1]);

								if (Object.color != null && Object.color != [])
									Sprite.color = FlxColor.fromRGB(Object.color[0], Object.color[1], Object.color[2]);

								Sprite.antialiasing = Object.antialiased;
								Sprite.scrollFactor.set(Object.scroll_Factor[0], Object.scroll_Factor[1]);

								if (Object.object_Name != null && Object.object_Name != "")
									stage_Objects.push([Object.object_Name, Sprite, Object]);
								else {
									stage_Objects.push(["undefinedSprite" + null_Object_Name_Loop, Sprite, Object]);
									null_Object_Name_Loop++;
								}

								if (Object.is_Animated) {
									Sprite.frames = Paths.getSparrowAtlas(stage + "/" + Object.file_Name);

									for (Animation in Object.animations) {
										var Anim_Name = Animation.name;

										if (Animation.indices == null) {
											Sprite.animation.addByPrefix(Anim_Name, Animation.animation_name, Animation.fps, Animation.looped);
										} else if (Animation.indices.length == 0) {
											Sprite.animation.addByPrefix(Anim_Name, Animation.animation_name, Animation.fps, Animation.looped);
										} else {
											Sprite.animation.addByIndices(Anim_Name, Animation.animation_name, Animation.indices, "", Animation.fps,
												Animation.looped);
										}
									}

									if (Object.start_Animation != "" && Object.start_Animation != null && Object.start_Animation != "null")
										Sprite.animation.play(Object.start_Animation);
								} else
									Sprite.loadGraphic(Paths.image(stage + "/" + Object.file_Name));

								if (Object.uses_Frame_Width)
									Sprite.setGraphicSize(Std.int(Sprite.frameWidth * Object.scale));
								else
									Sprite.setGraphicSize(Std.int(Sprite.width * Object.scale));

								if (Object.updateHitbox || Object.updateHitbox == null)
									Sprite.updateHitbox();

								if (Object.alpha != null)
									Sprite.alpha = Object.alpha;

                                PlayState.instance.modchartSprites.set(Object.name, Sprite);

								if(Object.front != null && Object.front)
                                    psychlua.LuaUtils.getTargetInstance().add(Sprite);
                                else
                                    PlayState.instance.insert(PlayState.instance.members.indexOf(psychlua.LuaUtils.getLowestCharacterGroup()), Sprite);
							}
						}
					}
			}
		}
	}

	public function new(stageName:String) {
		stage = stageName;
		updateStage();
	}
}

typedef AddedStageData = {
	var objects:Array<StageObject>;
}

typedef StageObject = {
	// General Sprite Object Data //
    var name:String;
	var position:Array<Float>;
	var scale:Float;
	var antialiased:Bool;
	var scroll_Factor:Array<Float>;

	var color:Array<Int>;
	var uses_Frame_Width:Bool;
	var object_Name:Null<String>;
	var layer:Null<String>; // default is bg, but fg is possible
	var alpha:Null<Float>;
    var front:Null<Bool>;
	var updateHitbox:Null<Bool>;
	// Image Info //
	var file_Name:String;
	var is_Animated:Bool;
	// Animations //
	var animations:Array<CharacterAnimation>;
	var start_Animation:String;
}

typedef CharacterAnimation =
{
	var name:String;
	var animation_name:String;
	var indices:Null<Array<Int>>;
	var fps:Int;
	var looped:Bool;
}