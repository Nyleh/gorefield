//
import funkin.options.OptionsMenu;
import flixel.text.FlxTextBorderStyle;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;

var options:Array<String> = [
	'story_mode',
	'freeplay',
	'options',
	'credits',
];

var optionsTexts:Map<String, String> = [
	'story_mode' => "Be very careful, be cautious!!",
	'freeplay' => "Sing along with GoreField",
	'options' => "The options you expected?",
	'credits' => "Credits to those who helped!",
];

// SPANISH - Jloor
var optionsTextsSPANISH:Map<String, String> = [
	'story_mode' => "Ten mucho cuidado, se cauteloso!!",
	'freeplay' => "Canta junto a Gorefield...",
	'options' => "Opciones..., Que esperabas?",
	'credits' => "Quienes trabajaron en el Mod!",
];

var menuItems:FlxTypedGroup<FlxSprite>;
var curSelected:Int = curMainMenuSelected;

var menuInfomation:FlxText;
var logoBl:FlxSprite;
var particleShader;
function create() {
	CoolUtil.playMenuSong();
	FlxG.camera.bgColor = FlxColor.fromRGB(17,5,33);

	var gorefield = new FlxSprite();
	gorefield.frames = Paths.getSparrowAtlas('menus/mainmenu/gorefield_menu');
	gorefield.animation.addByPrefix('idle', 'MenuIdle', 24);
	gorefield.animation.addByPrefix('jeje', 'JEJE', 24);
	gorefield.animation.play('idle');
	gorefield.updateHitbox();
	gorefield.x = 586; gorefield.y = 40;
	gorefield.antialiasing = true;
	add(gorefield);

	logoBl = new FlxSprite();
	logoBl.frames = Paths.getSparrowAtlas('menus/logoMod');
	logoBl.animation.addByPrefix('bump', 'logo bumpin', 24,false);
	logoBl.animation.play('bump');
	logoBl.scale.set(0.6, 0.6);
	logoBl.updateHitbox();
	logoBl.x = 80;
	logoBl.antialiasing = true;
	add(logoBl);

	menuInfomation = new FlxText(0, 675, FlxG.width, "Please select a option.", 28);
	menuInfomation.setFormat("fonts/pixelart.ttf", 28, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	menuInfomation.borderSize = 2;
	add(menuInfomation);

	menuItems = new FlxTypedGroup();
	add(menuItems);

	for (i=>option in options)
	{
		var menuItem:FlxSprite = new FlxSprite(0, 0);
		menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menu_' + option);
		menuItem.animation.addByPrefix('idle', option + " basic", 24);
		menuItem.animation.addByPrefix('selected', option + " white", 24);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		menuItem.antialiasing = true;

		menuItem.x = 520 - menuItem.width - (100 + (i*50));
		menuItem.y = 320 + ((menuItem.ID = i) * 92.5);

		menuItems.add(menuItem);
	}

	changeItem(0);
}

function changeItem(change:Int = 0) {
	curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length-1);

	FlxG.sound.play(Paths.sound("menu/scrollMenu"));

	menuItems.forEach(function(item:FlxSprite)
	{
		FlxTween.cancelTweensOf(item);
		item.animation.play(item.ID == curSelected ? 'selected' : 'idle');

		item.updateHitbox();

		if (item.ID == curSelected)
			FlxTween.tween(item, {x: 580 - item.width + 50}, (Conductor.stepCrochet / 1000), {ease: FlxEase.quadInOut});
		else
			FlxTween.tween(item, {x: 520 - item.width}, (Conductor.stepCrochet / 1000) * 1.5, {ease: FlxEase.circOut});
	});

	if (FlxG.save.data.spanish) {
		menuInfomation.text = optionsTextsSPANISH.get(options[curSelected]);
	} else {
		menuInfomation.text = optionsTexts.get(options[curSelected]);
	}
}

function goToItem() {
	selectedSomthin = true;

	FlxG.sound.play(Paths.sound("menu/confirmMenu"));
	new FlxTimer().start(0.35, (_) -> 	
	switch (options[curSelected]) {
		case "story_mode": FlxG.switchState(new StoryMenuState());
		case "freeplay": FlxG.switchState(new FreeplayState());
		case "options": FlxG.switchState(new OptionsMenu());
		case "credits": FlxG.switchState(new ModState("gorefield/CreditsState"));
		default: selectedSomthin = false;
	});
}

var selectedSomthin:Bool = false;
var t:Float = 0;
function update(elapsed:Float) {
	if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

	if (selectedSomthin) return;

	if (controls.BACK) {
		FlxG.sound.play(Paths.sound("menu/cancelMenu"));
		new FlxTimer().start(0.45, (_) -> 	FlxG.switchState(new TitleState()));
	}
	if (controls.DOWN_P) changeItem(1);
	if (controls.UP_P) changeItem(-1);
	if (controls.ACCEPT) goToItem();

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = !(persistentDraw = true);
		openSubState(new EditorPicker());
	}


	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = !(persistentDraw = true);
	}
}

function beatHit() {
	logoBl.animation.play('bump',true);
}

function onDestroy() {FlxG.camera.bgColor = FlxColor.fromRGB(0,0,0);curMainMenuSelected = curSelected;}