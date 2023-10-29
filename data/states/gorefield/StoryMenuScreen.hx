//
import flixel.FlxObject;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.AssetsLibraryList.AssetSource;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.FlxInterpolateColor;

var canMove:Bool = true;

var menuOptions:Array<FlxSprite> = [];
var menuLocks:Array<FlxSprite> = [];
var selector:FlxSprite;

var weeks:Array<Dynamic> = [];
var curWeek:Int = curStoryMenuSelected;

var camBG:FlxCamera = null;
var bgSprite:FlxBackdrop;
var camText:FlxCamera = null;

var bloomShader:CustomShader = null;
var warpShader:CustomShader = null;

var weekText:FlxText;
var flavourText:FlxText;
var textBG:FlxSprite;

var scoreText:FlxText;
var textInfoBG:FlxSprite;
var black:FlxSprite;
var bgShader:CustomShader;

var weeks:Array = [
	{name: "Principal Week...", songs: ["The Great Punishment", "Curious Cat", "Metamorphosis", "Hi Jon", "Terror in the Heights", "BIGotes"]},
	{name: "Lasagna Boy Week...", songs: ["Fast Delivery", "Health Inspection"]},
	{name: "Sansfield Week...", songs: ["Cat Patella", "Mondaylovania", "ULTRA FIELD"]},
	{name: "ULTRA Week...", songs: ["The Complement", "R0ses and Quartzs"]},
	{name: "Cryfield Week...", songs: ["Cryfield", "Nocturnal Meow"]},
	{name: "FINALE Week...", songs: ["CATaclysm"]},
];

var weeksUnlocked:Array<Bool> = [true, true, true, true, true, true];
var weeksFinished:Array<Bool> = [true, true, true, true, true, true];
var weekDescs:Array<String> = [
	"Lasagna smells delicious...",
	"Midnight meal???\n(yum)",
	"Purring Determination...",
	"A Big Little Problem.",
	"He Just Wants To Go Home...",
	"Layers on layers,\nHe will always be there..."
];

// SPANISH - Jloor 
// hi jloor -lunar
var weekDescsSPANISH:Array<String> = [
	"La Lasaña huele deliciosa...",
	"Comida de medianoche???\n(yum)",
	"Un ronroneo de determinacion...",
	"Un pequeno gran problema.",
	"El solo quiere volver a casa...",
	"Capas tras capas,\nEl siempre estara ahi..."
];

var lerpColors = [];

var subMenuOpen:Bool = false;
var curSubMenuSelected:Int = 0;
var subOptions:Array<FlxText> = [];
var subOptionsData:Array<Dynamic> = [];
var subMenuSelector:FlxSprite;
var selectorBloom:CustomShader;
var selectorCam:FlxCamera = null;

function create() {
	FlxG.cameras.remove(FlxG.camera, false);

	camBG = new FlxCamera(0, 0);
	selectorCam = new FlxCamera(0,0);
	camText = new FlxCamera(0, 0);

	for (cam in [camBG, FlxG.camera, selectorCam, camText])
		{FlxG.cameras.add(cam, cam == FlxG.camera); cam.bgColor = 0x00000000; cam.antialiasing = true;}

	CoolUtil.playMenuSong();
	camBG.bgColor = FlxColor.fromRGB(17,5,33);

	warpShader = new CustomShader("warp");
	warpShader.distortion = 0;
	if (FlxG.save.data.warp) FlxG.camera.addShader(warpShader);

	bgSprite = new FlxBackdrop(Paths.image("menus/storymenu/WEA_ATRAS"), 0x11, 0, 0);
	bgSprite.cameras = [camBG];
	bgSprite.velocity.set(100, 100);
	add(bgSprite);

	FlxTween.color(bgSprite, 5.4, 0xFFFFFFFF, 0xFFF07A31, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/});

	bgShader = new CustomShader("warp");
	bgShader.distortion = 2;
	if (FlxG.save.data.warp) camBG.addShader(bgShader);

	bloomShader = new CustomShader("glow");
	bloomShader.size = 18.0;// trailBloom.quality = 8.0;
    bloomShader.dim = 1;// trailBloom.directions = 16.0;
	if (FlxG.save.data.bloom) bgSprite.shader = bloomShader;

	for (i in 0...6) {
		var sprite:FlxSprite = new FlxSprite();
		sprite.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
		sprite.animation.addByPrefix("_", "STORY MENU 0" + Std.string(i + 1));
		sprite.animation.play("_");

		sprite.updateHitbox();
		sprite.offset.set();

		sprite.screenCenter("X");
		sprite.y = (sprite.height + 35) * i;

		sprite.ID = i;
		menuOptions.push(add(sprite));

		lerpColors[i * 2 + 0] = new FlxInterpolateColor(-1);

		var lock:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/candado"));
		lock.scale.set(.7,.7);
		lock.color = 0xFF92A2FF;
		lock.updateHitbox();
		menuLocks.push(add(lock));

		lerpColors[i * 2 + 1] = new FlxInterpolateColor(-1);
	}

	selector = new FlxSprite();
	selector.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
	selector.animation.addByPrefix("_", "SELECT");
	selector.animation.play("_");

	subMenuSelector = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/sub_selector"));
	subMenuSelector.visible = subMenuSelector.active = false;
	subMenuSelector.antialiasing = true;
	subMenuSelector.cameras = [selectorCam];

	selector.updateHitbox();

	selector.alpha = 0;
	selector.angle = 45;
	add(selector);

	weekText = new FunkinText(32, 20, FlxG.width, "WEEK NAME", 42, true);
	weekText.setFormat("fonts/pixelart.ttf", 54, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	weekText.borderSize = 4;
	weekText.scrollFactor.set();
	weekText.cameras = [camText];

	flavourText = new FunkinText(weekText.x, weekText.y + weekText.height + 10, FlxG.width, "Current Story Menu Description\nAnd Larger...", 18, true);
	flavourText.setFormat("fonts/pixelart.ttf", 18, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	flavourText.borderSize = 2;
	flavourText.scrollFactor.set();
	flavourText.cameras = [camText];

	textBG = new FlxSprite().makeSolid(1, 1, 0xFF000000);
	textBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textBG.updateHitbox();
	textBG.alpha = 0.4;
	textBG.scrollFactor.set();
	add(textBG);
	add(weekText);
	add(flavourText);

	scoreText = new FunkinText(weekText.x, 0, FlxG.width, "WEEK SCORE - 10000000,   4 SONGS,    UNLOCKED!", 18, true);
	scoreText.setFormat("fonts/pixelart.ttf", 18, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	scoreText.borderSize = 2;
	scoreText.scrollFactor.set();
	scoreText.cameras = [camText];

	scoreText.applyMarkup("WEEK SCORE - $" + "10000000" + "$,   4 SONGS,    #" + "UNLOCKED!#", [
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "$"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00FF00), "#"),
	]);

	textInfoBG = new FlxSprite().makeSolid(1, 1, 0xFF000000);
	textInfoBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textInfoBG.updateHitbox();
	textInfoBG.alpha = 0.4;
	textInfoBG.scrollFactor.set();
	add(textInfoBG);
	add(scoreText);

	black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    add(black); black.alpha = 0;

	var vigentte:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/black_vignette"));
	vigentte.cameras = [camText];
	vigentte.alpha = 0.5;
	add(vigentte);
	
	FlxTween.tween(selector, {angle: -90, alpha: 1}, 0.2, {ease: FlxEase.circInOut});

	changeWeek(0);
}

var __firstFrame = true;
var __totalTime:Float = 0;

var colorLerpSpeed:Float = 1;
var selectingWeek:Bool = false;
function update(elapsed:Float) {
	__totalTime += elapsed;

	if (controls.BACK && !selectingWeek) {
		if (subMenuOpen) 
			closeSubMenu();
		else {
			canMove = false; 
			var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/cancelMenu")); sound.volume = 1; sound.play();
			FlxG.switchState(new MainMenuState());
		}
	}

	if (canMove) {
		if (subMenuOpen) {
			var oldSubSelected:Int = curSubMenuSelected;

			var change = controls.DOWN_P ? 1 : controls.UP_P ? -1 : 0;
			curSubMenuSelected = FlxMath.bound(curSubMenuSelected + change, 0, subOptions.length-1);

			if (oldSubSelected != curSubMenuSelected) FlxG.sound.play(Paths.sound('menu/scrollMenu'));
			if (controls.ACCEPT) subOptionsData[curSubMenuSelected].callback();
		} else {
			if (controls.DOWN_P)
				changeWeek(1);
			else if (controls.UP_P)
				changeWeek(-1);
			else if (controls.ACCEPT)
				selectWeek();
		}

	}

	for (i=>menuOption in menuOptions) {
		var y:Float = ((FlxG.height - menuOption.height) / 2) + ((menuOption.ID - curWeek) * menuOption.height);
		var x:Float = 50 - ((Math.abs(Math.cos((menuOption.y + (menuOption.height / 2) - (FlxG.camera.scroll.y + (FlxG.height / 2))) / (FlxG.height * 1.25) * Math.PI)) * 150)) + Math.floor(15 * Math.sin(__totalTime + (0.8*i)));

		var lock = menuLocks[i];

		if (i == curWeek && selectingWeek) {
			menuOption.y = CoolUtil.fpsLerp(menuOption.y, (FlxG.height/2) - (menuOption.height/2), 0.075);
			menuOption.x = CoolUtil.fpsLerp(menuOption.x, (FlxG.width/2) - (menuOption.width/2), 0.075);
		} else {
			menuOption.y = __firstFrame ? y : CoolUtil.fpsLerp(menuOption.y, y, 0.25);
			menuOption.x = __firstFrame ? x : CoolUtil.fpsLerp(menuOption.x, FlxG.width - menuOption.width + 50 + x, 0.25);
			if (__firstFrame) menuOption.x += 1200 + (i *200);
		}


		lerpColors[i * 2 + 0].fpsLerpTo(subMenuOpen ? 0xFF343434 : weeksUnlocked[i] ? 0xFFFFFFFF : 0xFFBDBEFF, (1/75) * colorLerpSpeed);
		menuOption.color = lerpColors[i * 2 + 0].color;
		if(!selectingWeek) menuOption.alpha = weeksUnlocked[i] ? 1 : 0.75;

		lerpColors[i * 2 + 1].fpsLerpTo(subMenuOpen ? 0xFF343434 : 0xFF92A2FF, (1/75) * colorLerpSpeed);

		lock.visible = !weeksUnlocked[i];
		lock.x = (menuOption.x + (menuOption.width/2)) - (lock.width/2) + Math.floor(4 * Math.sin(__totalTime));
		lock.y = (menuOption.y + (menuOption.height/2)) - (lock.height/2) + Math.floor(2 * Math.cos(__totalTime));
		if(!selectingWeek) lock.color = lerpColors[i * 2 + 1].color;
	}
	__firstFrame = false;

	if (subMenuOpen && subOptions.length > 0) {
		for (i=>option in subOptions) {
			option.x = ((menuOptions[curWeek].x + (menuOptions[curWeek].width/2)) - option.width/2) + Math.floor(4 * Math.sin(__totalTime + (12*i)));
			option.y = (menuOptions[curWeek].y + (menuOptions[curWeek].height/2) - (((option.height + 16) * subOptions.length)/2)) + ((option.height + 16) * i) + Math.floor(2 * Math.cos(__totalTime));
			option.alpha = option.ID == 0 ? i == curSubMenuSelected ? 1 : 0.2 : option.alpha;

			option.y += 10; // offset cause sprite epmty space (ZERO WHY!!@!@)
		}
		subMenuSelector.setPosition(subOptions[curSubMenuSelected].x - subMenuSelector.width - (10 + (2 * Math.floor(Math.sin(__totalTime*2)))), subOptions[curSubMenuSelected].y+4);
	}
			
	selector.color = menuOptions[curWeek].color;
	selector.setPosition((menuOptions[curWeek].x - selector.width - 36), menuOptions[curWeek].y + ((menuOptions[curWeek].height/2) - (selector.height/2)));

	bloomShader.dim = .8 + (.3 * Math.sin(__totalTime));
	bloomShader.size = 18 + (8 * Math.sin(__totalTime));

	selectorCam.visible = subMenuSelector.visible;
	//selectorBloom.size = 4 + (1 * Math.sin(__totalTime));

	Framerate.offset.y = selectingWeek ? FlxMath.remapToRange(FlxMath.remapToRange(textBG.alpha, 0, 0.4, 0, 1), 0, 1, 0, textBG.height) : textBG.height;
}

function changeWeek(change:Int) {
	if(selectingWeek) return;

	var oldWeek:Float = curWeek;
	curWeek = FlxMath.bound(curWeek + change, 0, menuOptions.length-1);

	if (oldWeek != curWeek) FlxG.sound.play(Paths.sound('menu/scrollMenu'));

	weekText.text = weeks[curWeek].name;

	if (FlxG.save.data.spanish) {
		flavourText.text = weekDescsSPANISH[curWeek];
	} else {
		flavourText.text = weekDescs[curWeek];
	}

	textBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textBG.updateHitbox();

	Framerate.offset.y = textBG.height;

	var score:Float = FunkinSave.getWeekHighscore(weeks[curWeek].name, "hard").score;
	scoreText.applyMarkup("WEEK SCORE - $" + Std.string(score) + "$,   " + weeks[curWeek].songs.length + " SONGS,    #" + (weeksUnlocked[curWeek] ? "UNLOCKED" : "LOCKED") + "!#", [
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "$"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(weeksUnlocked[curWeek] ? 0xFF00FF00 : 0xFFFF0000), "#"),
	]);

	textInfoBG.scale.set(FlxG.width, scoreText.height + 38);
	textInfoBG.updateHitbox();
	textInfoBG.y = FlxG.height - textInfoBG.height;

	scoreText.y = FlxG.height - scoreText.height - 22;
}

function selectWeek() {
	if(selectingWeek) return; 

	if (!weeksUnlocked[curWeek]) { // ! LOCKED
		FlxG.camera.stopFX();
		FlxG.camera.shake(0.005, .5);
		lerpColors[curWeek * 2 + 0].color = 0xFFFF0000;
		lerpColors[curWeek * 2 + 1].color = 0xFFFF0000;
		menuOptions[curWeek].color = menuLocks[curWeek].color = 0xFFFF0000;

		FlxG.sound.play(Paths.sound("menu/story/locked"));
		return;
	}
	if (!weeksFinished[curWeek]) {playWeek(); return;} // ! play week for first time

	if (subMenuOpen) return;
	FlxG.sound.play(Paths.sound("menu/confirmMenu"));
	openSubMenu(
		{name:"STORY MODE", callback: function () {
			selectingWeek = true; 
			closeSubMenu(); FlxG.sound.play(Paths.sound("menu/confirmMenu"));
			(new FlxTimer()).start(0.4, function () {playWeek();});
		}},
		{name:"FREEPLAY", callback: function () {closeSubMenu(); FlxG.sound.play(Paths.sound("menu/confirmMenu"));}}
	);
}

function openSubMenu(option1:{name:String, callback:Void->Void}, option2:{name:String, callback:Void->Void}) {
	subOptionsData = [option1, option2];
	subMenuOpen = true; curSubMenuSelected = 0;
	colorLerpSpeed = 8; if (cannedTuna != null) cannedTuna.cancel();

	for (option in subOptionsData) {
		var option:FlxText = new FunkinText(0, 0, 0, option.name, 42, true);
		option.setFormat("fonts/pixelart.ttf", 54, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		option.cameras = [FlxG.camera];
		option.borderSize = 4;
		option.alpha = option.ID = 0;
		option.cameras = [selectorCam];
		subOptions.push(add(option));
	}

	if (subMenuSelector.active) {FlxTween.cancelTweensOf(subMenuSelector); remove(subMenuSelector);}

	add(subMenuSelector);
	subMenuSelector.alpha = 0;
	subMenuSelector.visible = subMenuSelector.active = true;

	FlxTween.cancelTweensOf(bgSprite);
	FlxTween.tween(bgSprite, {alpha: 0.5}, 0.2);

	FlxTween.tween(subMenuSelector, {alpha: 1}, 0.2);
}

var cannedTuna:FlxTimer = null;
function closeSubMenu() {
	if (!subMenuOpen) return;

	subMenuOpen = false; subOptionsData = [];
	for (sub in subOptions) {
		FlxTween.cancelTweensOf(sub);
		sub.ID = -1;
		FlxTween.tween(sub, {alpha: 0}, 0.1, {onComplete: function (t) {
			subOptions.remove(sub); sub.destroy(); remove(sub);
		}});
	}

	FlxTween.cancelTweensOf(subMenuSelector);
	FlxTween.tween(subMenuSelector, {alpha: 0}, 0.1, {onComplete: function (t) {
		remove(subMenuSelector); subMenuSelector.visible = subMenuSelector.active = false;
	}});

	FlxTween.cancelTweensOf(bgSprite);
	FlxTween.tween(bgSprite, {alpha: 1}, 0.1);

	cannedTuna = (new FlxTimer()).start(0.8, function (t) {colorLerpSpeed = 1;});
}

function playWeek() { // animation
	selectingWeek = true;
	FlxG.sound.music.fadeOut(0.25);

	FlxG.sound.play(Paths.sound("menu/story/weekenter")); // Sound
	switch(curWeek){
		case 0: FlxG.sound.play(Paths.sound("menu/story/principalenter"));
		case 1: FlxG.sound.play(Paths.sound("menu/story/lasboyenter"));
		case 2: FlxG.sound.play(Paths.sound("menu/story/sansfieldenter"));
		case 3: FlxG.sound.play(Paths.sound("menu/story/ultragorefieldenter"));
		case 4: FlxG.sound.play(Paths.sound("menu/story/cryfieldenter"));
		case 5: FlxG.sound.play(Paths.sound("menu/story/godfieldenter"));
		default: FlxG.sound.play(Paths.sound("menu/story/principalenter"));
	}

	for (i=>menuOption in menuOptions) { // Fade Out rest...
		if(menuOption.ID != curWeek){
			FlxTween.tween(menuOption, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
			FlxTween.tween(menuLocks[i], {alpha: 0}, 0.8, {ease: FlxEase.circOut});
		}
	}
	FlxTween.tween(selector, {angle: 45, alpha: 0}, .8, {ease: FlxEase.circOut});
	FlxTween.tween(camText, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	FlxTween.tween(textInfoBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	FlxTween.tween(textBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});

	FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.qaudOut, startDelay: .5});
	for (cam in [FlxG.camera, camBG])
		FlxTween.tween(cam, {zoom: 2.3}, 3, {ease: FlxEase.circInOut});
	FlxTween.num(0, 7, 3, {ease: FlxEase.circInOut}, (val:Float) -> {warpShader.distortion = val;});

	new FlxTimer().start(3, (tmr:FlxTimer) -> {
		PlayState.loadWeek(__gen_week(), "hard");
		FlxG.switchState(new ModState("gorefield/LoadingScreen"));
	});
}

function __gen_week() { // for cne so i dont have to ctrl c and v alot of code
	return {
		name: weeks[curWeek].name,
		id: weeks[curWeek].name,
		sprite: null,
		chars: [null, null, null],
		songs: [for (song in weeks[curWeek].songs) {name: song, hide: false}],
		difficulties: ['hard']
	};
}

function onDestroy() {FlxG.camera.bgColor = FlxColor.fromRGB(0,0,0); curStoryMenuSelected = curWeek; Framerate.offset.y = 0;}