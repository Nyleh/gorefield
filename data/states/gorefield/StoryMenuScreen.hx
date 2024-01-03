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
import Xml;
import StringTools;
import openfl.ui.Mouse;
import openfl.geom.Rectangle;
import openfl.desktop.Clipboard;

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
	{name: "???????? Week...", songs: ["Cataclysm"]},
	{name: "Binky Circus...", songs: ["Laughter and Cries"]},
	{name: "Cartoon World...", songs: ["Balls of Yarn"]},
	{name: "Code Songs...", songs: ["Take me Jon"]}
];

var weekColors:Array<Int> = [
	0xFFFF9500,
	0xFF1EA725,
	0xFF008DA9,
	0xFF727272,
	0xFFEB4108,
	0xFFFFFFFF
];

var CATclysmUnlocked:Bool = false;
var weeksUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true, true];
var weeksFinished:Array<Bool> = [true, true, true, true, true, true];
var weekDescs:Array<String> = [
	"Lasagna smells delicious...",
	"Midnight meal???\n(yum)",
	"Purring Determination...",
	"A Big Little Problem.",
	"He Just Wants To Go Home...",
	"????????????????????????????????????????????",
	"Honk Honk...",
	"A Feline Meeting...",
	"Extra stuff"
];

// SPANISH - Jloor 
// hi jloor -lunar
var weekDescsSPANISH:Array<String> = [
	"La Lasaña huele deliciosa...",
	"Comida de medianoche???\n(yum)",
	"Un ronroneo de determinacion...",
	"Un pequeno gran problema...",
	"El solo quiere volver a casa...",
	"????????????????????????????????????????????",
	"Honk Honk!",
	"Una reunion Felina...",
	"Contenido extra"
];

var lerpColors = [];
var colowTwn:FlxTween;

// SUB MENU
var subMenuOpen:Bool = false;
var curSubMenuSelected:Int = 0;
var subOptions:Array<FlxText> = [];
var subOptionsData:Array<Dynamic> = [];
var subMenuSelector:FlxSprite;
var selectorBloom:CustomShader;
var selectorCam:FlxCamera = null;

// FREE PLAY
var __firstFreePlayFrame:Bool = true;
var inFreeplayMenu:Bool = false;
var freePlayMenuID:Int = -1;
var freeplayMenuText:FunkinText;
var freeplaySelected:Array<Int> = [0,0,0,0,0,0];
var freeplaySongLists = [
	{
		songs: ["The Great Punishment", "Curious Cat", "Metamorphosis", "Hi Jon", "Terror in the Heights", "BIGotes"],
		icons: ["gorefield-phase-0", "garfield", "gorefield-phase-2", "gorefield-phase-3", "gorefield-phase-4", "bigotes"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Fast Delivery", "Health Inspection"],
		icons: ["lasagnaboy-pixel", "lasagnaboy-pixel"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Cat Patella", "Mondaylovania", "ULTRA FIELD"],
		icons: ["sansfield", "sansfield", "ultrafield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["The Complement", "R0ses and Quartzs"],
		icons: ["ultra-gayfield", "ultra-gayfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Cryfield", "Nocturnal Meow"],
		icons: ["cryfield", "cryfield-monster"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Cataclysm"],
		icons: ["garfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Laughter and Cries"],
		icons: ["garfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Balls of Yarn"],
		icons: ["garfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Take me Jon"],
		icons: ["minecraft"],
		songMenuObjs: [],
		iconMenuObjs: []
	}
];

// CODES MENU
var codesPanel:FlxSprite;
var codesOpenHitbox:FlxObject;
var codesTween:FlxTween;
var codesOpened:Bool = false;
var lastFrameRateMode:Int = 1;
var codesTextHitbox:FlxObject;
var codesButton:FlxSprite;
// TEXT
var codesPosition:Int = 0;
var codesText:FunkinText;
var caretSpr:FlxSprite;
var codesFocused:Bool = false;
var codesSound:FlxSound;

var alphabet:String = "abcdefghijklmnopqrstuvwxyz";
var numbers:String = "1234567890";
var symbols:String = "*[]^_.,'!?";

function create() {
	FlxG.mouse.visible = FlxG.mouse.useSystemCursor = true;
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
	bgSprite.cameras = [camBG]; bgSprite.colorTransform.color = 0xFFFFFFFF;
	bgSprite.velocity.set(100, 100);
	add(bgSprite);

	colowTwn = FlxTween.color(null, 5.4, 0xFF90D141, 0xFFF09431, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});

	bgShader = new CustomShader("warp");
	bgShader.distortion = 2;
	if (FlxG.save.data.warp) camBG.addShader(bgShader);

	bloomShader = new CustomShader("glow");
	bloomShader.size = 18.0;// trailBloom.quality = 8.0;
    bloomShader.dim = 1;// trailBloom.directions = 16.0;
	if (FlxG.save.data.bloom) bgSprite.shader = bloomShader;

	for (i in 0...9) {
		var sprite:FlxSprite = new FlxSprite();
		sprite.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
		sprite.animation.addByPrefix("_", "STORY MENU 0" + Std.string(i + 1));
		sprite.animation.play("_");

		sprite.updateHitbox();
		sprite.offset.set();

		//sprite.screenCenter("X");
		sprite.y = (sprite.height + 35) * i;

		sprite.ID = i;
		menuOptions.push(add(sprite));

		lerpColors[i * 2 + 0] = new FlxInterpolateColor(i == 5 ? 0 : -1);

		var lock:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/candado"));
		lock.scale.set(.7,.7);
		lock.color = 0xFF92A2FF;
		lock.updateHitbox();
		menuLocks.push(add(lock));

		lerpColors[i * 2 + 1] = new FlxInterpolateColor(i == 5 ? 0 : -1);
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

	codesPanel = new FlxSprite(-415).loadGraphic(Paths.image("menus/storymenu/MENU_CODE_STATIC"));
	codesPanel.scale.set(551/codesPanel.height, 551/codesPanel.height);
	add(codesPanel);

	codesText = new FunkinText(0, 0, 295 - (24), "COOL CODE!!!", 24, true);
	codesText.setFormat("fonts/pixelart.ttf", 24, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	codesText.borderSize = 3;
	codesText.cameras = [camText];
	add(codesText);

	caretSpr = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/carcet"));
	caretSpr.cameras = [camText];
	add(caretSpr);

	codesButton = new FlxSprite();
	codesButton.frames = Paths.getSparrowAtlas("menus/storymenu/enter");
	codesButton.animation.addByPrefix("idle", "enter0000", 24, false);
	codesButton.animation.addByPrefix("press", "enter press", 24, false);
	codesButton.animation.play("idle");
	codesButton.cameras = [camText];
	add(codesButton);

	codesOpenHitbox = new FlxObject(0, 0, 70, 124);
	add(codesOpenHitbox);

	codesTextHitbox = new FlxObject(0, 0, 295, 45);
	add(codesTextHitbox);

	FlxG.stage.window.onKeyDown.add(onKeyDown);
	FlxG.stage.window.onTextInput.add(onTextInput);

	codesSound = FlxG.sound.load(Paths.sound('menu/story/Code_Write_Song'));

	preloadFreeplayMenus();

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

	freeplayMenuText = new FunkinText(weekText.x, 0, 0, "FREEPLAY MENU", 18, true);
	freeplayMenuText.setFormat("fonts/pixelart.ttf", 22, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	freeplayMenuText.borderSize = 2; freeplayMenuText.x = FlxG.width - 32 - freeplayMenuText.width;
	freeplayMenuText.scrollFactor.set(); freeplayMenuText.alpha = 0;
	freeplayMenuText.cameras = [camText];

	textInfoBG = new FlxSprite().makeSolid(1, 1, 0xFF000000);
	textInfoBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textInfoBG.updateHitbox();
	textInfoBG.alpha = 0.4;
	textInfoBG.scrollFactor.set();
	add(textInfoBG);
	add(freeplayMenuText);
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
var bloomSine:Bool = true;
var dim:Float = 0; var size:Float = 0;
var lerpMenuSpeed:Float = 1;
var updateFreePlay:Bool = false;
var cursor:String = null;
var cacheRect:Rectangle = new Rectangle();
var cachePoint:FlxPoint = FlxPoint.get(0,0);
var cachePoint2:FlxPoint = FlxPoint.get(0,0);
var carcetTime:Float = 0;
function update(elapsed:Float) {
	__totalTime += elapsed;

	if (canMove)
		handleMenu();

	for (i=>menuOption in menuOptions) {
		var y:Float = ((FlxG.height - menuOption.height) / 2) + ((menuOption.ID - curWeek) * menuOption.height);
		var x:Float = 50 - ((Math.abs(FlxMath.fastCos((menuOption.y + (menuOption.height / 2) - (FlxG.camera.scroll.y + (FlxG.height / 2))) / (FlxG.height * 1.25) * Math.PI)) * 150)) + Math.floor(15 * FlxMath.fastSin(__totalTime + (0.8*i)));
		x += codesOpened ? 200 : 0;

		if (i == curWeek && selectingWeek) {
			menuOption.y = CoolUtil.fpsLerp(menuOption.y, (FlxG.height/2) - (menuOption.height/2), 0.075);
			menuOption.x = CoolUtil.fpsLerp(menuOption.x, (FlxG.width/2) - (menuOption.width/2), 0.075);
		} else {
			menuOption.y = __firstFrame ? y : CoolUtil.fpsLerp(menuOption.y, y, inFreeplayMenu ? 0.016 : 0.25 * lerpMenuSpeed);
			menuOption.x = __firstFrame ? x : CoolUtil.fpsLerp(menuOption.x, FlxG.width - menuOption.width + 50 + x + (inFreeplayMenu ? 2500+(200*(i+1)) : 0), inFreeplayMenu ? 0.016 : 0.25 * lerpMenuSpeed);
			if (__firstFrame) menuOption.x += 2000 + (i *800);
		}

		lerpColors[i * 2 + 0].fpsLerpTo(subMenuOpen ? 0xFF343434 : weeksUnlocked[i] ? (i == 5 && !CATclysmUnlocked ? 0xFF000000 : (codesOpened ? 0xFF626262 : 0xFFFFFFFF)) : (i == 5 && !CATclysmUnlocked ? 0xFF000000 : 0xFFBDBEFF), ((1/75) * colorLerpSpeed) * (codesOpened ? 3 : 1));
		menuOption.color = lerpColors[i * 2 + 0].color;
		if(!selectingWeek) menuOption.alpha = weeksUnlocked[i] ? 1 : 0.75;

		lerpColors[i * 2 + 1].fpsLerpTo(subMenuOpen ? 0xFF343434 : 0xFF92A2FF, (1/75) * colorLerpSpeed);

		var lock = menuLocks[i];
		lock.visible = !weeksUnlocked[i];
		lock.x = (menuOption.x + (menuOption.width/2)) - (lock.width/2) + Math.floor(4 * FlxMath.fastSin(__totalTime));
		lock.y = (menuOption.y + (menuOption.height/2)) - (lock.height/2) + Math.floor(2 * FlxMath.fastCos(__totalTime));
		if(!selectingWeek) lock.color = lerpColors[i * 2 + 1].color;
	}
	__firstFrame = false;

	if (subMenuOpen && subOptions.length > 0) {
		for (i=>option in subOptions) {
			option.x = ((menuOptions[curWeek].x + (menuOptions[curWeek].width/2)) - option.width/2) + Math.floor(4 * FlxMath.fastSin(__totalTime + (12*i)));
			option.y = (menuOptions[curWeek].y + (menuOptions[curWeek].height/2) - (((option.height + 16) * subOptions.length)/2)) + ((option.height + 16) * i) + Math.floor(2 * FlxMath.fastCos(__totalTime));
			option.alpha = option.ID == 0 ? i == curSubMenuSelected ? 1 : 0.2 : option.alpha;

			option.y += 10; // offset cause sprite epmty space (ZERO WHY!!@!@)
		}
		subMenuSelector.setPosition(subOptions[curSubMenuSelected].x - subMenuSelector.width - (10 + (2 * Math.floor(FlxMath.fastSin(__totalTime*2)))), subOptions[curSubMenuSelected].y+4);
	}
			
	selector.color = menuOptions[curWeek].color;
	selector.setPosition((menuOptions[curWeek].x - selector.width - 36), menuOptions[curWeek].y + ((menuOptions[curWeek].height/2) - (selector.height/2)));

	if (bloomSine) {
		bloomShader.dim = dim = .8 + (.3 * FlxMath.fastSin(__totalTime));
		bloomShader.size = size = 18 + (8 * FlxMath.fastSin(__totalTime));
	}

	selectorCam.visible = subMenuSelector.visible;
	//selectorBloom.size = 4 + (1 * FlxMath.fastSin(__totalTime));

	codesPanel.updateHitbox();
	codesPanel.screenCenter(0x10);
	codesPanel.y += 65 + (8*FlxMath.fastSin(__totalTime));
	
	codesOpenHitbox.x = codesPanel.x + 415;
	codesOpenHitbox.screenCenter(0x10);
	codesOpenHitbox.y += 50;

	codesTextHitbox.x = codesPanel.x + 24;
	codesTextHitbox.y = codesPanel.y + 258;

	codesText.x = codesPanel.x + 24 + 12;
	codesText.y = codesTextHitbox.y + (codesTextHitbox.height/2) - (codesText.height/2);

	codesButton.x = codesPanel.x + 103;
	codesButton.y = codesPanel.y + 330;

	cursor = null;
	var lastOpened:Bool = codesOpened;
	if (FlxG.mouse.overlaps(codesOpenHitbox)) {
		cursor = "button";
		if (FlxG.mouse.justReleased) {
			codesMenu(!codesOpened, 0);
			FlxG.sound.play(Paths.sound('menu/story/Open_and_Close_Secret_Menu'));
		}
	} else if (FlxG.mouse.overlaps(codesTextHitbox)) {
		cursor = "ibeam";
		if (FlxG.mouse.justReleased) {
			codesFocused = true; carcetTime = 0;
			codesPosition = codesText.text.length;

			// Position from mouse
			cachePoint2.set(FlxG.mouse.screenX-codesText.x, FlxG.mouse.screenY-codesText.y);
			if (cachePoint2.x < 0)
				codesPosition = 0;
			else {
				var index = codesText.textField.getCharIndexAtPoint(cachePoint2.x, cachePoint2.y);
				if (index > -1) codesPosition = index;
			}
		}
			
	} else if (FlxG.mouse.overlaps(codesButton)) {
		cursor = "button";
		if (FlxG.mouse.justReleased) {
			codesButton.animation.play("press", true);
		}
	} else if (FlxG.mouse.justReleased)
		codesFocused = false;

	if (codesButton.animation.name == "press" && codesButton.animation.finished)
		codesButton.animation.play("idle", true);
	if (codesButton.animation.name == "press") codesButton.x -= 5;

	switch(codesPosition) {
		default:
			if (codesPosition >= codesText.text.length) {
				codesText.textField.__getCharBoundaries(codesText.text.length-1, cacheRect);
				cachePoint.set(cacheRect.x + cacheRect.width, cacheRect.y);
			} else {
				codesText.textField.__getCharBoundaries(codesPosition, cacheRect);
				cachePoint.set(cacheRect.x, cacheRect.y);
			}
	};
	carcetTime += elapsed;
	caretSpr.alpha = Math.floor(((carcetTime+1.6)*2)%2);
	caretSpr.visible = codesFocused;

	caretSpr.x = codesText.x + (codesText.text.length == 0 ? 0 : cachePoint.x + 0);
	caretSpr.y = codesText.y + cachePoint.y;

	Framerate.offset.y = selectingWeek ? FlxMath.remapToRange(FlxMath.remapToRange(textBG.alpha, 0, 0.4, 0, 1), 0, 1, 0, textBG.height) : textBG.height;
	if (FlxG.game.soundTray != null) FlxG.sound.muteKeys = codesFocused ? [] : [40 /*ZERO*/, 96 /*NUMPADZERO*/];
	
	if (!lastOpened && codesOpened) lastFrameRateMode = Framerate.debugMode;
	if (lastOpened && !codesOpened) Framerate.debugMode = lastFrameRateMode;
	if (codesOpened) Framerate.debugMode = 0;

	textInfoBG.y = CoolUtil.fpsLerp(textInfoBG.y, codesOpened ? FlxG.height : FlxG.height - textInfoBG.height, 0.25);
	scoreText.y = CoolUtil.fpsLerp(scoreText.y, codesOpened ? FlxG.height : FlxG.height - scoreText.height - 22, 0.25);

	Mouse.cursor = cursor ?? "arrow";

	if (!updateFreePlay) return;
	freeplayMenuText.alpha = lerp(freeplayMenuText.alpha, inFreeplayMenu ? .6 + (.4*FlxMath.fastSin(__totalTime*1.5)) : 0, 0.15);
	for (menuID => data in freeplaySongLists) {
		if (menuID != freePlayMenuID && freePlayMenuID != -1) continue;
		for (i => song in data.songMenuObjs) {
			var scaledY = FlxMath.remapToRange((i-freeplaySelected[freePlayMenuID]), 0, 1, 0, 1.3);
			var y:Float = (scaledY * 120) + (FlxG.height * 0.48);
			var x:Float = ((i-freeplaySelected[freePlayMenuID]) * 30) + 90;
	
			song.y = __firstFreePlayFrame ? y + 0 : CoolUtil.fpsLerp(song.y, y, inFreeplayMenu ? 0.16 : 0.04);
			song.x = __firstFreePlayFrame ? x : CoolUtil.fpsLerp(song.x, menuID == freePlayMenuID ? x : -1500, inFreeplayMenu ? 0.16 : 0.08);
			if (menuID == freePlayMenuID && __firstFreePlayFrame) {song.x -= 500+(1500*i);}
	
			data.iconMenuObjs[i].alpha = song.alpha = lerp(song.alpha, menuID == freePlayMenuID ? (i == freeplaySelected[freePlayMenuID] ? 1 : 0.4) : 0, inFreeplayMenu ? 0.25 : 0.2);
	
			data.iconMenuObjs[i].updateHitbox();
			data.iconMenuObjs[i].x = song.x + song.width + 16;
			data.iconMenuObjs[i].y = song.y + (song.height/2) - (data.iconMenuObjs[i].height/2);
		}
	}
	__firstFreePlayFrame = false;
}

function handleMenu() {
	if (codesOpened) {
		if (controls.BACK && !codesFocused) codesMenu(false, 0);
		return;
	}

	if (inFreeplayMenu) {
		if (controls.DOWN_P) changeSong(1);
		if (controls.UP_P) changeSong(-1);
		if (controls.ACCEPT) goToSong();
		if (controls.BACK) closeFreePlayMenu();
		return;
	}

	if (subMenuOpen) {
		if (controls.BACK) {closeSubMenu(); return;}
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
		else if (controls.BACK) {
			canMove = false; 
			var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/cancelMenu")); sound.volume = 1; sound.play();
			FlxG.switchState(new MainMenuState());
		}
	}
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

	freeplayMenuText.y = scoreText.y = FlxG.height - scoreText.height - 22;
}

function selectWeek() {
	if(selectingWeek) return; 

	if (!weeksUnlocked[curWeek]) { // ! LOCKED
		FlxG.camera.stopFX();
		FlxG.camera.shake(0.005, .5);
		lerpColors[curWeek * 2 + 0].color = curWeek == 5 && !CATclysmUnlocked ? 0xFF000000 : 0xFFFF0000;
		lerpColors[curWeek * 2 + 1].color = curWeek == 5 && !CATclysmUnlocked ? 0xFF000000 : 0xFFFF0000;
		menuOptions[curWeek].color = menuLocks[curWeek].color = curWeek == 5 && !CATclysmUnlocked ? 0xFF000000 : 0xFFFF0000;

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
		{name:"FREEPLAY", callback: function () {closeSubMenu(); openFreePlayMenu(); FlxG.sound.play(Paths.sound("menu/confirmMenu"));}}
	);
}

function openSubMenu(option1:{name:String, callback:Void->Void}, option2:{name:String, callback:Void->Void}) {
	subOptionsData = [option1, option2]; curSubMenuSelected = 0;
	subMenuOpen = true; colorLerpSpeed = 8; if (cannedTuna != null) cannedTuna.cancel();

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
	canMove = !(selectingWeek = true);
	FlxG.sound.music.fadeOut(0.25);

	FlxG.sound.play(Paths.sound("menu/story/weekenter")); // Sound
	codesMenu(false, -100);
	switch(curWeek){
		case 0: FlxG.sound.play(Paths.sound("menu/story/principalenter"));
		case 1: FlxG.sound.play(Paths.sound("menu/story/lasboyenter"));
		case 2: FlxG.sound.play(Paths.sound("menu/story/sansfieldenter"));
		case 3: FlxG.sound.play(Paths.sound("menu/story/ultragorefieldenter"));
		case 4: FlxG.sound.play(Paths.sound("menu/story/cryfieldenter"));
		case 5: FlxG.sound.play(Paths.sound("menu/story/godfieldenter"));
		case 6: FlxG.sound.play(Paths.sound("menu/story/Binky_Week_Enter"));
		case 7: FlxG.sound.play(Paths.sound("menu/story/Cartoon_Week_Enter"));
		case 8: FlxG.sound.play(Paths.sound("menu/story/Codes_Week_Enter"));
		default: FlxG.sound.play(Paths.sound("menu/story/principalenter"));
	}

	for (i=>menuOption in menuOptions) { // Fade Out rest...
		if(menuOption.ID != curWeek){
			FlxTween.tween(menuOption, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
			FlxTween.tween(menuLocks[menuOption.ID], {alpha: 0}, 0.8, {ease: FlxEase.circOut});
		}
	}
	FlxTween.tween(selector, {angle: 45, alpha: 0}, .8, {ease: FlxEase.circOut});
	FlxTween.tween(camText, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	FlxTween.tween(textInfoBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	FlxTween.tween(textBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	
	colowTwn.cancel();
	colowTwn = FlxTween.color(null, 3, bgSprite.colorTransform.color, weekColors[curWeek], {ease: FlxEase.circOut, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});

	bloomSine = false;
	FlxTween.num(dim, .5, 3, {ease: FlxEase.circOut}, (val:Float) -> {bloomShader.dim = val;});
	FlxTween.num(size, 26, 3, {ease: FlxEase.circOut}, (val:Float) -> {bloomShader.size = val;});

	FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.qaudOut, startDelay: .5});
	for (cam in [FlxG.camera, camBG])
		FlxTween.tween(cam, {zoom: 2.1}, 3, {ease: FlxEase.circInOut});
	FlxTween.num(0, 6, 3, {ease: FlxEase.circInOut}, (val:Float) -> {warpShader.distortion = val;});

	new FlxTimer().start(3, (tmr:FlxTimer) -> {
		PlayState.loadWeek(__gen_week(), "hard");
		FlxG.switchState(new ModState("gorefield/LoadingScreen"));
	});
}

function __gen_week() {
	return {
		name: weeks[curWeek].name,
		id: weeks[curWeek].name,
		sprite: null,
		chars: [null, null, null],
		songs: [for (song in weeks[curWeek].songs) {name: song, hide: false}],
		difficulties: ['hard']
	};
}

function preloadFreeplayMenus() {
	for (data in freeplaySongLists) {
		for (i => song in data.songs) {
			var newText:FunkinText = new FunkinText(0, 0, 0, song, 54, true);
			newText.setFormat("fonts/pixelart.ttf", 64, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			newText.borderSize = 4; newText.alpha = 0;
			data.songMenuObjs.push(add(newText));
		}

		for (i => icon in data.icons) {
			var charXML = null;
			var xmlPath = Paths.xml('characters/' + icon);
			if (Assets.exists(xmlPath))
				charXML = Xml.parse(Assets.getText(xmlPath)).firstElement();
		
			var path = 'icons/' + (charXML != null && charXML.exists("icon") ? charXML.get("icon") : icon);
			if (!Assets.exists(Paths.image(path))) path = 'icons/face';
			var icon = new FlxSprite(); icon.alpha = 0;
			if ((charXML != null && charXML.exists("animatedIcon")) ? (charXML.get("animatedIcon") == "true") : false) {
				icon.frames = Paths.getSparrowAtlas(path);
				icon.animation.addByPrefix("losing", "losing", 24, true);
				icon.animation.addByPrefix("idle", "idle", 24, true);
				icon.animation.play("idle");
			} else {
				icon.loadGraphic(Paths.image(path)); // load once to get the width and stuff
				icon.loadGraphic(icon.graphic, true, icon.graphic.width/2, icon.graphic.height);
				icon.animation.add("non-animated", [0,1], 0, false);
				icon.animation.play("non-animated");
			}
			data.iconMenuObjs.push(add(icon));
		}
	}
}

function openFreePlayMenu() {
	codesMenu(false, -100);

	__firstFreePlayFrame = inFreeplayMenu = updateFreePlay = true;
	freePlayMenuID = curWeek; changeSong(0);

	colowTwn.cancel();
	colowTwn = FlxTween.color(null, 5, bgSprite.colorTransform.color, weekColors[curWeek], {ease: FlxEase.circOut, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});
}

var lerpTimer:FlxTimer = null;
var updateTimer:FlxTimer = null;
function closeFreePlayMenu() {
	codesMenu(false, 0);

	__firstFreePlayFrame = inFreeplayMenu = false;
	freePlayMenuID = -1; changeWeek(0);

	lerpMenuSpeed = 0.5; if (lerpTimer != null) lerpTimer.cancel();
	lerpTimer = (new FlxTimer()).start(0.5, function () {lerpMenuSpeed = 1;});

	if (updateTimer != null) updateTimer.cancel();
	updateTimer = (new FlxTimer()).start(0.6, function () {updateFreePlay = false;});

	colowTwn.cancel();
	colowTwn = FlxTween.color(null, 5.4, 0xFF90D141, 0xFFF09431, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});
}

function changeSong(change:Int) {
    freeplaySelected[freePlayMenuID] = FlxMath.wrap(
		freeplaySelected[freePlayMenuID] + change, 0, 
		freeplaySongLists[freePlayMenuID].songMenuObjs.length-1
	);
	FlxG.sound.play(Paths.sound("menu/scrollMenu"));

	var data = FunkinSave.getSongHighscore(freeplaySongLists[freePlayMenuID].songs[freeplaySelected[freePlayMenuID]], "hard", null);
	var dateStr = Std.string(data.date).split(" ")[0];
	if (dateStr == null || dateStr == "null") dateStr = "????,??,??";
	scoreText.applyMarkup("SCORE - $" + Std.string(data.score) + "$,  MISSES - #" + Std.string(data.misses) + "#,  ACCURACY - @" + Std.string(FlxMath.roundDecimal(data.accuracy * 100, 2)) + "@,  DATE - /" + StringTools.replace(dateStr, "-", ",") + "/", [
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFF3F315), "$"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFE13333), "#"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF1CDA1C), "@"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF10CCED), "/"),
	]);

	textInfoBG.scale.set(FlxG.width, scoreText.height + 38);
	textInfoBG.updateHitbox();
	textInfoBG.y = FlxG.height - textInfoBG.height;

	freeplayMenuText.y = scoreText.y = FlxG.height - scoreText.height - 22;
}

function goToSong() {
	var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/confirmMenu")); sound.volume = 1; sound.play();
    PlayState.loadSong(freeplaySongLists[freePlayMenuID].songs[freeplaySelected[freePlayMenuID]], "hard", false, false);
	PlayState.isStoryMode = PlayState.chartingMode = false; // Just incase cause people see cutscenes for some reason

    FlxG.switchState(new ModState("gorefield/LoadingScreen"));
}

function codesMenu(open:Bool, offset:Float) {
	if (open == false) codesFocused = false;
	codesOpened = open;
	if (codesTween != null) codesTween.cancel();
	codesTween = FlxTween.tween(codesPanel, {x: (codesOpened ? 0 : -415) + offset}, .25, {ease: FlxEase.circInOut});
}

var RIGHT = 0x4000004F;
var LEFT = 0x40000050;
var BACKSPACE = 0x08;
var HOME = 0x4000004A;
var END = 0x4000004D;
var V = 0x76;
var LEFT_CTRL = 0x0040;
var RIGHT_CTRL = 0x0080;
function onKeyDown(keyCode:Int, modifier:Int) {
	switch(keyCode) {
		case LEFT:
			codesPosition = FlxMath.bound(codesPosition-1, 0, codesText.text.length); carcetTime = 0;
		case RIGHT:
			codesPosition = FlxMath.bound(codesPosition+1, 0, codesText.text.length); carcetTime = 0;
		case BACKSPACE:
			if (codesPosition > 0) {
				codesText.text = codesText.text.substr(0, codesPosition-1) + codesText.text.substr(codesPosition);
				codesPosition = FlxMath.bound(codesPosition-1, 0, codesText.text.length); carcetTime = 0;
			}
		case HOME:
			codesPosition = 0;
		case END:
			codesPosition = codesText.text.length;
		case V:
			// paste
			if (modifier == LEFT_CTRL || modifier == RIGHT_CTRL) {
				var data:String = Clipboard.generalClipboard.getData(2/**TEXTFORMAT**/);
				if (data != null) onTextInput(data);
			}
		default: // nothing
	}
}

function onTextInput(text:String):Void {
	if (!codesFocused) return;

	for (char in 0...text.length) {
		if (StringTools.contains(alphabet, text.charAt(char))) continue;
		if (StringTools.contains(numbers, text.charAt(char))) continue;
		if (StringTools.contains(symbols, text.charAt(char))) continue;
		return; // char not found in font - lunar
	}

	codesText.text = codesText.text.substr(0, codesPosition) + text + codesText.text.substr(codesPosition);
	codesPosition += text.length; carcetTime = 0;
	codesSound.play(true);
}

function onDestroy() {
	FlxG.camera.bgColor = FlxColor.fromRGB(0,0,0); 
	curStoryMenuSelected = curWeek; 
	Framerate.offset.y = 0; Framerate.debugMode = lastFrameRateMode;

	FlxG.stage.window.onKeyDown.remove(onKeyDown);
	FlxG.stage.window.onTextInput.remove(onTextInput);
}