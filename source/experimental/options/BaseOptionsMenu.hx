package experimental.options;

import objects.CheckboxThingie;
import objects.AttachedText;
import flixel.addons.transition.FlxTransitionableState;
import experimental.options.Option;
import flixel.ui.FlxBar;
import objects.Alphabet;

class BaseOptionsMenu extends MusicBeatSubstate {
    private var curOption: Option = null;
    private var curSelected: Int = 0;
    private var optionsArray: Array<Option> = [];

    private var grpOptions: FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
    private var checkboxGroup: FlxTypedGroup<CheckboxThingie> = new FlxTypedGroup<CheckboxThingie>();
    private var grpTexts: FlxTypedGroup<AttachedText> = new FlxTypedGroup<AttachedText>();

    private var descBox: FlxSprite;
    private var descText: FlxText;

    public var title: String = 'Options';
    public var rpcTitle: String = 'Options Menu';

    public var bar: FlxBar;
    public var barText: Alphabet;

    public function new() {
        super();

        #if desktop
        DiscordClient.changePresence(rpcTitle, null);
        #end

        setupBackground();

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        grpTexts = new FlxTypedGroup<AttachedText>();
        add(grpTexts);

        checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
        add(checkboxGroup);

        setupTitleAndDescription();

        setupOptions();
    }

    private function setupBackground() {
        var bg: FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.color = 0xFFea71fd;
        bg.screenCenter();
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);
    }

    private function setupTitleAndDescription() {
        var titleText: Alphabet = new Alphabet(75, 45, title, true);
        titleText.setScale(0.6);
        titleText.alpha = 0.4;
        add(titleText);

        descText = new FlxText(50, 600, 1180, "", 32);
        descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        descText.scrollFactor.set();
        descText.borderSize = 2.4;
        add(descText);
    }

    private function setupOptions() {
        for (i in 0...optionsArray.length) {
            var option = optionsArray[i];
            var optionText: Alphabet = createOptionText(option, i);
            createOptionElement(option, optionText, i);
            updateTextFrom(option);
        }
        setupProgressBar();
        changeSelection();
        reloadCheckboxes();
    }

    private function createOptionText(option: Option, index: Int): Alphabet {
        var optionText: Alphabet = new Alphabet(290, 260, option.name, false);
        optionText.isMenuItem = true;
        optionText.targetY = index;
        grpOptions.add(optionText);
        return optionText;
    }

    private function createOptionElement(option: Option, optionText: Alphabet, index: Int) {
        if (option.type == 'bool') {
            var checkbox: CheckboxThingie = createCheckbox(option, optionText, index);
            checkboxGroup.add(checkbox);
        } else {
            createValueText(option, optionText, index);
        }
    }

    private function createCheckbox(option: Option, optionText: Alphabet, index: Int): CheckboxThingie {
        var checkbox: CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, option.getValue() == true);
        checkbox.sprTracker = optionText;
        checkbox.ID = index;
        return checkbox;
    }

    private function createValueText(option: Option, optionText: Alphabet, index: Int) {
        optionText.x -= 80;
        optionText.startPosition.x -= 80;
        var valueText: AttachedText = new AttachedText('' + option.getValue(), optionText.width + 60);
        valueText.sprTracker = optionText;
        valueText.copyAlpha = true;
        valueText.ID = index;
        grpTexts.add(valueText);
        option.child = valueText;
    }

    private function setupProgressBar() {
        bar = new FlxBar(0, 90, LEFT_TO_RIGHT, 1000, 25, null, "", 0, 100, true);
        bar.createColoredFilledBar(0xFFFF0000, true, 0xFFFFFFFF);
        bar.screenCenter(X);
        bar.visible = false;
        bar.value = 0;
        add(bar);

        barText = new Alphabet(80, 10, "");
        barText.visible = false;
        add(barText);
    }

    public function addOption(option: Option) {
        optionsArray.push(option);
    }

    override function update(elapsed: Float) {
        handleUpDownInput();
        handleBackInput();
        handleOptionChangeInput();
        handleResetInput();

        if (nextAccept > 0) {
            nextAccept -= 1;
        }
        super.update(elapsed);
    }

    private function handleUpDownInput() {
        if (controls.UI_UP_P) {
            changeSelection(-1);
        }
        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }
    }

    private function handleBackInput() {
        if (controls.BACK) {
            #if android
            FlxTransitionableState.skipNextTransOut = true;
            FlxG.resetState();
            ClientPrefs.saveSettings();
            #else
            close();
            #end
            ClientPrefs.saveSettings();
        }
    }

    private function handleOptionChangeInput() {
        var usesCheckbox = curOption.type == 'bool';
        if (nextAccept <= 0) {
            if (usesCheckbox) {
                handleCheckboxInput();
            } else {
                handleNonCheckboxInput();
            }
        }
    }

    private function handleCheckboxInput() {
        if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            curOption.setValue(!curOption.getValue());
            curOption.change();
            reloadCheckboxes();
        }
    }

    private function handleNonCheckboxInput() {
        if (controls.UI_LEFT || controls.UI_RIGHT) {
            handleNonCheckboxKeyPress();
        } else if (controls.UI_LEFT_R || controls.UI_RIGHT_R) {
            clearHold();
        }
    }

    private function handleNonCheckboxKeyPress() {
        var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
        if (holdTime > 0.5 || pressed) {
            handleKeyPressValueChange(pressed);
        }

        if (curOption.type != 'string') {
            holdTime += elapsed;
        }
    }

    private function handleKeyPressValueChange(pressed: Bool) {
        var add: Dynamic = null;
        if (curOption.type != 'string') {
            add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
        }

        switch (curOption.type) {
            case 'int':
                handleIntValueChange(add, pressed);

            case 'float' | 'percent':
                handleFloatOrPercentValueChange(add, pressed);
        }
    }

    private function handleIntValueChange(add: Dynamic, pressed: Bool) {
        holdValue = curOption.getValue() + add;
        handleValueLimits();
        curOption.setValue(Math.round(holdValue));
        updateTextAndChangeOption();
    }

    private function handleFloatOrPercentValueChange(add: Dynamic, pressed: Bool) {
        holdValue = curOption.getValue() + add;
        handleValueLimits();
        curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
        updateTextAndChangeOption();
    }

    private function handleValueLimits() {
        if (holdValue < curOption.minValue) holdValue = curOption.minValue;
        else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;
    }

    private function updateTextAndChangeOption() {
        updateTextFrom(curOption);
        curOption.change();
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }

    private function clearHold() {
        if (holdTime > 0.5) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        holdTime = 0;
    }

    private function handleResetInput() {
        if (controls.RESET #if android || MusicBeatSubstate._virtualpad.buttonC.justPressed #end) {
            resetAllOptions();
        }
    }

    private function resetAllOptions() {
        for (i in 0...optionsArray.length) {
            var leOption: Option = optionsArray[i];
            leOption.setValue(leOption.defaultValue);
            if (leOption.type != 'bool') {
                if (leOption.type == 'string') {
                    leOption.curOption = leOption.options.indexOf(leOption.getValue());
                }
                updateTextFrom(leOption);
            }
            leOption.change();
        }
        FlxG.sound.play(Paths.sound('cancelMenu'));
        reloadCheckboxes();
    }

    private function updateTextFrom(option: Option) {
        var text: String = option.displayFormat;
        var val: Dynamic = option.getValue();
        if (option.type == 'percent') val *= 100;
        var def: Dynamic = option.defaultValue;
        option.text = text.replace('%v', val).replace('%d', def);
    }

    private function changeSelection(change: Int = 0) {
        curSelected += change;
        if (curSelected < 0) curSelected = optionsArray.length - 1;
        if (curSelected >= optionsArray.length) curSelected = 0;

        updateDescriptionAndOptionSelection();
        updateProgressBar();
    }

    private function updateDescriptionAndOptionSelection() {
        descText.text = optionsArray[curSelected].description;
        descText.screenCenter(Y);
        descText.y += 270;

        var bullShit: Int = 0;

        for (item in grpOptions.members) {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;
            if (item.targetY == 0) {
                item.alpha = 1;
            }
        }
        for (text in grpTexts) {
            text.alpha = 0.6;
            if (text.ID == curSelected) {
                text.alpha = 1;
            }
        }

        descBox.setPosition(descText.x - 10, descText.y - 10);
        descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
        descBox.updateHitbox();

        curOption = optionsArray[curSelected];
        FlxG.sound.play(Paths.sound('scrollMenu'));

        updateProgressBarVisibility();
    }

    private function updateProgressBarVisibility() {
        if (curOption.barVisible) {
            bar.visible = true;
            bar.value = curOption.barValue;
            barText.visible = true;
            barText.updateText(curOption.barText);
        } else {
            bar.visible = false;
            barText.visible = false;
        }
    }

    private function updateProgressBar() {
        if (curOption.barVisible) {
            bar.visible = true;
            bar.value = curOption.barValue;
            barText.visible = true;
            barText.updateText(curOption.barText);
        } else {
            bar.visible = false;
            barText.visible = false;
        }
    }

    private function reloadCheckboxes() {
        for (checkbox in checkboxGroup) {
            checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
        }
    }
}
