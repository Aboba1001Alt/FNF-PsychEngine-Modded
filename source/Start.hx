import h2d.Text;
import h3d.Engine;

class Start extends hxd.App {
    var fpsText:Text;
    override function init() {
        fpsText = new Text(hxd.res.DefaultFont.get());
        fpsText.y = 100;
        fpsText.scaleX = 0.5;
        fpsText.scaleY = 0.5;
    }
    public static function main() {
        new Main();
    }
    override function update(dt:Float) {
        fpsText.text = 'FPS: ${Engine.fps}';
    }
}