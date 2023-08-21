package dashadertools; 
import dashadertools.Flxfixedshaders;  
using StringTools; 
class Effect {
	public function setValue(shader:Flxfixedshaders, variable:String, value:Float){
		Reflect.setProperty(Reflect.getProperty(shader, 'variable'), 'value', [value]);
	}
	
}