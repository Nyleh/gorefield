//
import funkin.options.OptionsMenu;
import flixel.text.FlxTextBorderStyle;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.backend.MusicBeatState;

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

var keyCombos:Map<String, Void->Void> = [
	"PENK" => function () penk(),
	"PENKA" => function () penk(),
	"PENKR" => function () penk(),
	"PENKARU" => function () penk()
];
var keyComboProgress:Map<String, Int> = [];
var canUseKeyCombos:Bool = true;

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
function update(elapsed:Float) {
	if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

	if (selectedSomthin) return;

	var lastPressed = FlxG.keys.firstJustPressed();
	if (lastPressed != -1 && canUseKeyCombos)
		for (fullPhrase => func in keyCombos) {
			if (!keyComboProgress.exists(fullPhrase)) keyComboProgress.set(fullPhrase, 0);
			if (lastPressed == fullPhrase.charCodeAt(keyComboProgress.get(fullPhrase))) {
				var progress = keyComboProgress.get(fullPhrase) == null ? 0 : keyComboProgress.get(fullPhrase);
				keyComboProgress.set(fullPhrase, progress+1);
				if (fullPhrase.length == keyComboProgress.get(fullPhrase)) {
					keyComboProgress.set(fullPhrase, 0);
					if (func != null) func();
				}
			}
		}

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

// easter eggs
var penkOrder:Array<Int> = [1, 2, 3, 4];
var penkProgress:Int = 0;
function penk() {
	if (penkProgress == 0)
		for (i in 0...penkOrder.length-1) {
			var j = FlxG.random.int(i, penkOrder.length-1); var tmp = penkOrder[i];
			penkOrder[i] = penkOrder[j]; penkOrder[j] = tmp;
		}

	keyCombos.remove(switch (penkProgress) {
		case 1:	"PENK";
		case 2:	"PENKA";
		case 3:	"PENKR";
		case 4:	"PENKARU";
	});

	FlxG.sound.play(Paths.sound("vineboom"));
	FlxG.sound.music.volume -= 0.25;

	var newSprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/wow i love easter what about you/penkarue (" + Std.string(penkOrder[penkProgress++]) + ")"));
	newSprite.updateHitbox(); newSprite.antialiasing = true; newSprite.alpha = 0; newSprite.angle = FlxG.random.float(-900, 900);
	newSprite.setPosition(FlxG.random.float(0, FlxG.width-newSprite.width), FlxG.random.float(0, FlxG.height-newSprite.height));
	add(newSprite); newSprite.scale.set(1.2, 1.2); canUseKeyCombos = false;

	FlxG.camera.shake(0.002, 0.3);
	FlxTween.tween(newSprite, {"scale.x": 1, "scale.y": 1, alpha: 1, angle: 0}, 0.3, {ease: FlxEase.qaudInOut, onComplete: function () {if (penkProgress != 4) canUseKeyCombos = true;}});
	if (penkProgress != 4) return;
	(new FlxTimer()).start(.3, function (_) {
		FlxTween.tween(FlxG.camera, {zoom: 3, alpha:0, angle: -800}, 2, {ease: FlxEase.circInOut, onComplete: function () {
			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
			FlxG.switchState(new ModState("gorefield/easteregg/Penkaru"));
		}});
	});
}