//
import funkin.options.OptionsMenu;
import flixel.text.FlxTextBorderStyle;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import hxvlc.flixel.FlxVideo;
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
var cutscene:FlxSprite;
var curSelected:Int = curMainMenuSelected;

var menuInfomation:FlxText;
var logoBl:FlxSprite;
var fire:FlxSprite;
var gorefield:FlxSprite;
var vigentte:FlxSprite;

var keyCombos:Map<String, Void->Void> = [
	"penkaru" => function () penk(),
	"TAE" => function () meme("t"),
	"NIFFIRG" => function () meme("niffirgflumbo"),
	"TANUKI" => function () meme("irl"),
	"CABROS" => function () meme("LOOOOL"),
	"CANDEL" => function () meme("idk what call this one")
];
var keyComboProgress:Map<String, Int> = [];
var canUseKeyCombos:Bool = true;

var glowShader:CustomShader;
var glitchShader:CustomShader;
var heatWaveShader:CustomShader;

function create() {
	CoolUtil.playMenuSong();
	FlxG.camera.bgColor = FlxColor.fromRGB(17,5,33);

	fire = new FlxSprite(-100, -60);
	fire.frames = Paths.getSparrowAtlas('stages/skyFire/fire_f4');
	fire.animation.addByPrefix("fire", "FIRE", 24, true);
	fire.animation.play("fire");
	add(fire); fire.visible = false;

	gorefield = new FlxSprite();
	gorefield.frames = Paths.getSparrowAtlas('menus/mainmenu/gorefield_menu');
	gorefield.animation.addByPrefix('idle', 'MenuIdle0000', 1);
	gorefield.animation.addByPrefix('beat', 'MenuIdle', 24,false);
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
	menuInfomation.setFormat("fonts/pixelart.ttf", 28, FlxColor.WHITE, "center");
	menuInfomation.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 50);
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

	cutscene = new FlxSprite();
	cutscene.frames = Paths.getSparrowAtlas('menus/mainmenu/garfield_menu_startup');
	cutscene.animation.addByPrefix('_', "GARFIELD", 24, false);
	cutscene.updateHitbox(); cutscene.screenCenter();
	cutscene.visible = false;

	if (!seenMenuCutscene) {
		selectedSomthin = seenMenuCutscene = true;
		var oldMembers = members.copy();
		for (mem in members) remove(mem);
		add(cutscene);

		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			cutscene.animation.play("_", cutscene.visible = true);
		});
		cutscene.animation.finishCallback = function () {
			changeItem(0);
			for (mem in oldMembers) add(mem);
			remove(cutscene);

			menuInfomation.y += 100;
			FlxTween.tween(menuInfomation, {y: menuInfomation.y - 100}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circOut});

			logoBl.alpha = 0;
			FlxTween.tween(logoBl, {alpha: 1 , angle: 0}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.circOut});

			menuItems.forEach(function(item:FlxSprite) {
				item.x -= 500;
				if (item.ID == curSelected) FlxTween.tween(item, {x: 580 - item.width + 50}, (Conductor.stepCrochet / 1000) * 2);
				else FlxTween.tween(item, {x: 520 - item.width}, (Conductor.stepCrochet / 1000) * 2);
			});
			selectedSomthin = false;
		}
	}
	else{
		changeItem(0);
	}

	vigentte = new FlxSprite().loadGraphic(Paths.image("menus/black_vignette"));
	vigentte.alpha = 0.2; vigentte.scrollFactor.set(0,0);
	add(vigentte);

	glowShader = new CustomShader("glow");
	glowShader.size = 8.0;// trailBloom.quality = 8.0;
    glowShader.dim = 1;// trailBloom.directions = 16.0;

	heatWaveShader = new CustomShader("heatwave");
    heatWaveShader.time = 0; heatWaveShader.speed = 1; 
    heatWaveShader.strength = 1; 

	glitchShader = new CustomShader("glitch");
    glitchShader.glitchAmount = .4;
}


function loadCheckpoint(point) {
	if(point == null) {
		FlxG.sound.play(Paths.sound("menu/story/locked"));
		return;
	}

	selectedSomthin = true;

	var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/confirmMenu")); sound.volume = 1; sound.play();

	(new FlxTimer()).start(2, function() {
		FlxG.camera.fade(FlxColor.RED, 3.2, false, function() {
			PlayState.storyWeek = point.storyWeek;
			PlayState.storyPlaylist = point.storyPlaylist;
			PlayState.isStoryMode = true;
			PlayState.campaignScore = point.campaignScore;
			PlayState.campaignMisses = point.campaignMisses;
			PlayState.campaignAccuracyTotal = point.campaignAccuracyTotal;
			PlayState.campaignAccuracyCount = point.campaignAccuracyCount;
			PlayState.opponentMode = point.opponentMode;
			PlayState.coopMode = point.coopMode;
			PlayState.chartingMode = false;
			PlayState.difficulty = point.difficulty;
			PlayState.__loadSong(PlayState.storyPlaylist[0], PlayState.difficulty);
			FlxG.switchState(new ModState("gorefield/LoadingScreen"));
		});
	});
}

function changeItem(change:Int = 0) {
	curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length-1);

	FlxG.sound.play(Paths.sound("menu/scrollMenu"));

	menuItems.forEach(function(item:FlxSprite) {
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

	var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/confirmMenu")); sound.volume = 1; sound.play();
	switch (options[curSelected]) {
		case "story_mode": 
			FlxG.sound.play(Paths.sound('menu/pressStorymode'));
			gorefield.animation.play('jeje'); gorefield.x = 250;
			gorefield.offset.y = 15; gorefield.offset.x = -25;
			gorefield.color = 0xFFDE8888;

			FlxG.sound.music.stop();
			FlxG.camera.shake(0.005, 5.2);

			FlxG.camera.flash(FlxColor.WHITE, 1);

			FlxG.camera.bgColor = 0xff80261f;
			fire.animation.play('fire');

			FlxTween.tween(vigentte, {alpha: .4}, 3.2);

			if (FlxG.save.data.glitch) gorefield.shader = glitchShader;
			if (FlxG.save.data.heatwave) fire.shader = heatWaveShader;
			if (FlxG.save.data.bloom) FlxG.camera.addShader(glowShader);

			for (member in members)
				if (Std.isOfType(member, FlxBasic)) member.visible = member == fire || member == gorefield || member == vigentte;

			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
			(new FlxTimer()).start(2, function() {
				FlxG.camera.fade(FlxColor.RED, 3.2, false, function() {
					PlayState.loadWeek({
						name: "Principal Week...",
						id: "Principal Week...",
						sprite: null,
						chars: [null, null, null],
						songs: [for (song in ["The Great Punishment", "Curious Cat", "Metamorphosis", "Hi Jon", "Terror in the Heights", "BIGotes"]) {name: song, hide: false}],
						difficulties: ['hard']
					}, "hard");
					FlxG.switchState(new ModState("gorefield/LoadingScreen"));
				});
			});
		case "freeplay": FlxG.switchState(new StoryMenuState());
		case "options": FlxG.switchState(new OptionsMenu());
		case "credits": FlxG.switchState(new ModState("gorefield/CreditsScreen"));
		default: selectedSomthin = false;
	}
}

var tottalTime:Float = 0;
var selectedSomthin:Bool = false;
function update(elapsed:Float) {
	tottalTime += elapsed;
	heatWaveShader.time = tottalTime;
	glitchShader.time = tottalTime;

	fire.y = -50 + (FlxMath.fastSin(tottalTime) * 10);
	if (gorefield.animation.name == "jeje") {
		gorefield.offset.y = 15 + FlxG.random.float(-6,6); gorefield.offset.x = -25 + FlxG.random.float(-2,2);
	}

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
		var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/cancelMenu")); sound.volume = 1; sound.play();
		FlxG.switchState(new TitleState());
	}
	if (controls.DOWN_P) changeItem(1);
	if (controls.UP_P) changeItem(-1);
	if (controls.ACCEPT) goToItem();


	if(FlxG.keys.justPressed.SHIFT) {
		loadCheckpoint(FlxG.save.data.gorePoint);
	}

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = !(persistentDraw = true);
		openSubState(new EditorPicker());
	}

	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = !(persistentDraw = true);
	}
}

var bgTween:FlxTween;

function beatHit(curBeat:Int) {
	logoBl.animation.play('bump',true);

	if (curBeat % 2 == 0)
		gorefield.animation.play('beat',true);
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