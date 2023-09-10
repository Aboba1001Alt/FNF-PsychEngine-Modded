package experimental.backend;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

import tjson.TJSON as Json;
import psychlua.*;
import states.PlayState;

typedef SpriteData = {
    var name:String;
    var x:Int;
    var y:Int;
    @:optional var angle:Int;
    var animated:Bool;
    var image:String;
    @:optional var animToPlay:String;
    @:optional var scale:Array<Int>;
    @:optional var scroll:Array<Int>;
    var front:Bool;
    @:optional var order:Int;
}

typedef JsonData = {
    var sprites:Array<SpriteData>;
}

class AdditionalStageData {
    public function loadStage(name:String) {
        var game:PlayState = PlayState.instance;

        var modPath = "stages/" + name + "-stage.json"; // Fixed path concatenation
        if (FileSystem.exists(modPath)) {
            var jsonData:JsonData = cast haxe.Json.parse(File.getContent(modPath));

            for (spriteData in jsonData.sprites) {
                var sprite:SpriteData = cast spriteData;
                var leSprite:ModchartSprite = new ModchartSprite(sprite.x, sprite.y);
                if (!sprite.animated && sprite.image != null) {
                    leSprite.loadGraphic(Paths.image(sprite.image));
                }
                if (sprite.animated) {
                    LuaUtils.loadFrames(leSprite, sprite.image, "sparrow");
                    if (sprite.animToPlay != null) {
                        leSprite.animation.addByPrefix(sprite.animToPlay, sprite.animToPlay, 24, true);
                    }
                }
                if (sprite.scroll != null) leSprite.scrollFactor.set(sprite.scroll[0], sprite.scroll[1]);
                if (sprite.scale != null) {
                    leSprite.scale.set(sprite.scale[0], sprite.scale[1]);
                    leSprite.updateHitbox();
                }
                if (sprite.angle != null) leSprite.angle = sprite.angle;
                if (sprite.front != null && !sprite.front) {
                    game.insert(game.members.indexOf(LuaUtils.getLowestCharacterGroup()), leSprite);
                } else if (sprite.front != null && sprite.front) {
                    game.add(leSprite);
                }
                if (sprite.order != null) game.insert(sprite.order, leSprite);
                game.modchartSprites.set(sprite.name, leSprite);
            }
        }
    }
}
