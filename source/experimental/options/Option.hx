package experimental.options;

class Option {
    public var child: Alphabet;
    public var text(get, set): String;
    public var onChange: Dynamic -> Void = null;

    public var type(get, default): String = 'bool';
    public var scrollSpeed: Float = 50;
    public var variable: String = null;
    public var defaultValue: Dynamic = null;

    public var curOption: Int = 0;
    public var options: Array<String> = null;
    public var changeValue: Dynamic = 1;
    public var minValue: Dynamic = null;
    public var maxValue: Dynamic = null;
    public var decimals: Int = 1;

    public var displayFormat: String = '%v';
    public var description: String = '';
    public var name: String = 'Unknown';
    public var barVisible: Bool = false;
    public var barValue: Float = 0;
    public var barText: String = "";

    public function new(name: String, description: String = '', variable: String, type: String = 'bool', ?options: Array<String> = null) {
        this.name = name;
        this.description = description;
        this.variable = variable;
        this.type = type;
        this.defaultValue = Reflect.getProperty(ClientPrefs.defaultData, variable);
        this.options = options;

        if (defaultValue == 'null variable value') {
            setDefaultValuesByType();
        }

        if (getValue() == null) {
            setValue(defaultValue);
        }

        setAdditionalTypeAttributes();

        if (type == 'string') {
            updateCurOptionForStringType();
        } else if (type == 'percent') {
            setPercentTypeAttributes();
        }
    }

    private function setDefaultValuesByType() {
        switch (type) {
            case 'bool':
                defaultValue = false;
            case 'int' | 'float':
                defaultValue = 0;
            case 'percent':
                defaultValue = 1;
            case 'string':
                defaultValue = '';
                if (options.length > 0) {
                    defaultValue = options[0];
                }
            case 'functionnal':
                defaultValue = null;
        }
    }

    private function setAdditionalTypeAttributes() {
        switch (type) {
            case 'percent':
                displayFormat = '%v%';
                changeValue = 0.01;
                minValue = 0;
                maxValue = 1;
                scrollSpeed = 0.5;
                decimals = 2;
        }
    }

    private function updateCurOptionForStringType() {
        var num: Int = options.indexOf(getValue());
        if (num > -1) {
            curOption = num;
        }
    }

    private function setPercentTypeAttributes() {
        displayFormat = '%v%';
        changeValue = 0.01;
        minValue = 0;
        maxValue = 1;
        scrollSpeed = 0.5;
        decimals = 2;
    }

    public function change() {
        if (onChange != null) {
            onChange(getValue());
        }
    }

    public function getValue(): Dynamic {
        if (variable != null) return Reflect.getProperty(ClientPrefs.data, variable);
        return null;
    }

    public function setValue(value: Dynamic) {
        if (variable != null) Reflect.setProperty(ClientPrefs.data, variable, value);
    }

    private function get_text() {
        if (child != null) {
            return child.text;
        }
        return null;
    }

    private function set_text(newValue: String = '') {
        if (child != null) {
            child.text = newValue;
        }
        return null;
    }

    private function get_type() {
        var newValue: String = 'bool';
        switch (type.toLowerCase().trim()) {
            case 'int' | 'float' | 'percent' | 'string':
                newValue = type;
            case 'integer':
                newValue = 'int';
            case 'str':
                newValue = 'string';
            case 'fl':
                newValue = 'float';
            case 'functionnal':
                newValue = 'functionnal';
        }
        type = newValue;
        return type;
    }
}
