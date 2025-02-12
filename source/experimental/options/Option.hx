package experimental.options;

class Option
{
	public var child:Alphabet;
	public var text(get, set):String;
	public var onChange: Dynamic -> Void = null; //Pressed enter (on Bool type options) or pressed/held left/right (on other types)

	public var type(get, default):String = 'bool'; //bool, int (or integer), float (or fl), percent, string (or str)
	// Bool will use checkboxes
	// Everything else will use a text

	public var scrollSpeed:Float = 50; //Only works on int/float, defines how fast it scrolls per second while holding left/right
	private var variable:String = null; //Variable from ClientPrefs.hx
	public var defaultValue:Dynamic = null;

	public var curOption:Int = 0; //Don't change this
	public var options:Array<String> = null; //Only used in string type
	public var changeValue:Dynamic = 1; //Only used in int/float/percent type, how much is changed when you PRESS
	public var minValue:Dynamic = null; //Only used in int/float/percent type
	public var maxValue:Dynamic = null; //Only used in int/float/percent type
	public var decimals:Int = 1; //Only used in float/percent type

	public var displayFormat:String = '%v'; //How String/Float/Percent/Int values are shown, %v = Current value, %d = Default value
	public var description:String = '';
	public var name:String = 'Unknown';
    public var barVisible:Bool = false;
    public var barValue:Float = 0;
	public var barText:String = "";
	public var modded:Bool = false;

	public function new(name:String, description:String = '', variable:String, type:String = 'bool', ?options:Array<String> = null ,?modded:Bool = false)
	{
		this.name = name;
		this.description = description;
		this.variable = variable;
		this.type = type;
		this.modded = modded;
		this.defaultValue = Reflect.getProperty(ClientPrefs.defaultData, variable);
		this.options = options;

		if(defaultValue == 'null variable value')
		{
			switch(type)
			{
				case 'bool':
					defaultValue = false;
				case 'int' | 'float':
					defaultValue = 0;
				case 'percent':
					defaultValue = 1;
				case 'string':
					defaultValue = '';
					if(options.length > 0) {
						defaultValue = options[0];
					}
				case 'functionnal':
				    defaultValue = null;
			}
		}

		if(getValue() == null) {
			setValue(defaultValue);
		}

		switch(type)
		{
			case 'string':
				var num:Int = options.indexOf(getValue());
				if(num > -1) {
					curOption = num;
				}
	
			case 'percent':
				displayFormat = '%v%';
				changeValue = 0.01;
				minValue = 0;
				maxValue = 1;
				scrollSpeed = 0.5;
				decimals = 2;
		}
	}

	public function change()
	{
		if(onChange != null) {
			onChange(getValue());
		}
	}

	public function getValue():Dynamic
	{
		if (!modded && variable != null) return Reflect.getProperty(ClientPrefs.data, variable);
		if (modded && variable != null && ClientPrefs.data.moddedSaves.exists(variable)) return ClientPrefs.data.moddedSaves.get(variable);
		return null;
	}
	public function setValue(value:Dynamic)
	{
		if (!modded && variable != null) Reflect.setProperty(ClientPrefs.data, variable, value);
		if (modded && variable != null) return ClientPrefs.data.moddedSaves.set(variable, value);
	}

	private function get_text()
	{
		if(child != null) {
			return child.text;
		}
		return null;
	}
	private function set_text(newValue:String = '')
	{
		if(child != null) {
			child.text = newValue;
		}
		return null;
	}

	private function get_type()
	{
		var newValue:String = 'bool';
		switch(type.toLowerCase().trim())
		{
			case 'int' | 'float' | 'percent' | 'string | functionnal': newValue = type;
			case 'integer': newValue = 'int';
			case 'str': newValue = 'string';
			case 'fl': newValue = 'float';
			case 'func': newValue = 'functionnal';
		}
		type = newValue;
		return type;
	}
}