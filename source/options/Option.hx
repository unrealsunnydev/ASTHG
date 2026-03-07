package options;

enum OptionType { BOOL; STRING; INT; FLOAT; }

class Option {
	public var flag:String = "Unknown Option";
	public var desc:String = "This option does not have a description.";
	public var type:OptionType = OptionType.BOOL;
	public var saveVar(default, null):Null<String>;
	public var options:Dynamic;
	public var value(get, set):Dynamic;
	public var defaultV:Null<Dynamic>;
	
	public var child:AsthgText;
	public var text(get, set):Null<String>;

	inline public function new(flag:String = "", saveVar:String = "", ?type:OptionType = OptionType.BOOL, ?options:Dynamic) {
		_name = flag;

		this.flag = Locale.getString(flag, "options");
		this.desc = Locale.getString('${flag}_desc', "options");
		this.type = type;
		this.saveVar = saveVar;
		this.options = options;
		this.value = Reflect.getProperty(ClientPrefs.data, saveVar);

		switch (type) {
			case OptionType.BOOL:
				defaultV ??= false;
			case OptionType.FLOAT:
				this.options = {min: 0.0, max: 10.0, amount: 0.5, display: "%v"};
				defaultV ??= 0.0;
			case OptionType.INT:
				this.options = {min: 0, max: 10, amount: 1, display: "%v"};
				defaultV ??= 0;
			case OptionType.STRING:
				this.options = {list: ["No Options"], display: "%v"};
				defaultV ??= options?.list[0];
		}
	}

	private function get_value():Dynamic { return Reflect.getProperty(ClientPrefs.data, saveVar); }

	private function set_value(value:Dynamic):Dynamic {
		Reflect.setProperty(ClientPrefs.data, saveVar, value);
		return value;
	}

	var _name:String = null;
	var _text:String = null;

	private function get_text()
		return _text;

	private function set_text(newValue:String = '')
	{
		if (child != null)
		{
			_text = newValue;
			child.text = Locale.getString('$_name-${value}', "options") ?? _text;
			return _text;
		}

		return null;
	}
}

typedef OptionSettings = {
	/**
		Set's a display format, how the option will look	
		Default: `%v` 
	**/
	display:String,

	/**
		Minimal value for this `INT`/`FLOAT` option	
		Default: `0.0`
	**/
	min:Float,

	/**
		Maximum value for this `INT`/`FLOAT` option	
		Default: `10.0`
	**/
	max:Float,

	/**
		How much increase/decrease values when changing `INT`/`FLOAT` options
	**/
	amount:Float,

	/**
		Only available for `STRING` options.
		Set's a list of values for this option.
	**/
	list:Array<String>
}