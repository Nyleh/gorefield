//
import flixel.FlxObject;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.AssetsLibraryList.AssetSource;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import funkin.backend.system.framerate.Framerate;

var canMove:Bool = true;

var menuOptions:Array<FlxSprite> = [];
var menuLocks:Array<FlxSprite> = [];
var selector:FlxSprite;

var weeks:Array<Dynamic> = [];
var curWeek:Int = curStoryMenuSelected;

var camBG:FlxCamera = null;
var camText:FlxCamera = null;

var bloomShader:CustomShader = null;
var warpShader:CustomShader = null;

var weekText:FlxText;
var flavourText:FlxText;
var textBG:FlxSprite;

var scoreText:FlxText;
var textInfoBG:FlxSprite;

var weeks:Array = [
	{name: "Principal Week...", songs: ["The Great Punishment", "Curious Cat", "Metamorphosis", "Hi Jon", "Terror in the Heights", "BIGotes"]},
	{name: "Lasagna Boy Week...", songs: ["Fast Delivery", "Health Inspection"]},
	{name: "Sansfield Week...", songs: ["Cat Patella", "Mondaylovania", "ULTRA FIELD"]},
	{name: "ULTRA Week...", songs: ["The Complement", "R0ses and Quartzs"]},
	{name: "Cryfield Week...", songs: ["Cryfield", "Nocturnal Meow"]},
	{name: "FINALE Week...", songs: ["CATaclysm"]},
];

var weeksUnlocked:Array<Bool> = [true, false, false, false, false, false];
var weeksFinished:Array<Bool> = [true, false, false, false, false, false];
var weekDescs:Array<String> = [
	"Lasagna smells delicious...",
	"Midnight meal???\n(yum)",
	"Purring Determination...",
	"A Big Little Problem.",
	"He Just Wants To Go Home...",
	"Layers on layers,\nHe will always be there..."
];

function create() {
	FlxG.cameras.remove(FlxG.camera, false);

	camBG = new FlxCamera(0, 0);
	camText = new FlxCamera(0, 0);

	for (cam in [camBG, FlxG.camera, camText])
		{FlxG.cameras.add(cam, cam == FlxG.camera); cam.bgColor = 0x00000000; cam.antialiasing = true;}

	CoolUtil.playMenuSong();
	camBG.bgColor = FlxColor.fromRGB(17,5,33);

	var bgSprite:FlxBackdrop = new FlxBackdrop(Paths.image("menus/storymenu/WEA_ATRAS"), 0x11, 0, 0);
	bgSprite.cameras = [camBG];
	bgSprite.velocity.set(100, 100);
	add(bgSprite);

	FlxTween.color(bgSprite, 5.4, 0xFFFFFFFF, 0xFFF07A31, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/});

	warpShader = new CustomShader("warp");
	warpShader.distortion = 2;
	if (FlxG.save.data.warp) camBG.addShader(warpShader);

	bloomShader = new CustomShader("glow");
	bloomShader.size = 18.0;// trailBloom.quality = 8.0;
    bloomShader.dim = 0.8;// trailBloom.directions = 16.0;
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

		var lock:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/candado"));
		lock.scale.set(.7,.7);
		lock.color = 0xFF92A2FF;
		lock.updateHitbox();
		menuLocks.push(add(lock));
	}

	selector = new FlxSprite();
	selector.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
	selector.animation.addByPrefix("_", "SELECT");
	selector.animation.play("_");

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

	var vigentte:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/black_vignette"));
	vigentte.cameras = [camText];
	vigentte.alpha = 0.5;
	add(vigentte);

	FlxTween.tween(selector, {angle: -90, alpha: 1}, 0.2, {ease: FlxEase.circInOut});

	changeWeek(0);
}

var __firstFrame = true;
var __totalTime:Float = 0;

function update(elapsed:Float) {
	__totalTime += elapsed;
	
	if (controls.BACK) {
		canMove = false;
		FlxG.sound.play(Paths.sound("menu/cancelMenu"));
		FlxG.switchState(new MainMenuState());
	}

	bloomShader.dim = .8 + (.3 * Math.sin(__totalTime));
	bloomShader.size = 18 + (8 * Math.sin(__totalTime));

	for (i=>menuOption in menuOptions) {
		var y:Float = ((FlxG.height - menuOption.height) / 2) + ((menuOption.ID - curWeek) * menuOption.height);
		var x:Float = 50 - ((Math.abs(Math.cos((menuOption.y + (menuOption.height / 2) - (FlxG.camera.scroll.y + (FlxG.height / 2))) / (FlxG.height * 1.25) * Math.PI)) * 150)) + Math.floor(15 * Math.sin(__totalTime + (0.8*i)));

		menuOption.y = __firstFrame ? y : CoolUtil.fpsLerp(menuOption.y, y, 0.25);
		menuOption.x = __firstFrame ? x : CoolUtil.fpsLerp(menuOption.x, FlxG.width - menuOption.width + 50 + x, 0.25);
		if (__firstFrame) menuOption.x += 600 + (i *200);
		menuOption.color = FlxColor.interpolate(menuOption.color, weeksUnlocked[i] ? 0xFFFFFFFF : 0xFFBDBEFF, elapsed*(120*(1/100)));
		menuOption.alpha = weeksUnlocked[i] ? 1 : 0.75;

		menuLocks[i].visible = !weeksUnlocked[i];
		menuLocks[i].x = (menuOption.x + (menuOption.width/2)) - (menuLocks[i].width/2) + Math.floor(4 * Math.sin(__totalTime));
		menuLocks[i].y = (menuOption.y + (menuOption.height/2)) - (menuLocks[i].height/2) + Math.floor(2 * Math.cos(__totalTime));
		menuLocks[i].color = FlxColor.interpolate(menuLocks[i].color,  0xFF92A2FF , elapsed*(120*(1/150)));
	}
	__firstFrame = false;

	selector.setPosition((menuOptions[curWeek].x - selector.width - 36), menuOptions[curWeek].y + ((menuOptions[curWeek].height/2) - (selector.height/2)));

	if (!canMove) return;

	if (controls.DOWN_P)
		changeWeek(1);
	else if (controls.UP_P)
		changeWeek(-1);
	else if (controls.ACCEPT)
		selectWeek();
}

function changeWeek(change:Int) {
	var oldWeek:Float = curWeek;
	curWeek = FlxMath.bound(curWeek + change, 0, menuOptions.length-1);

	if (oldWeek != curWeek) FlxG.sound.play(Paths.sound('menu/scrollMenu'));

	weekText.text = weeks[curWeek].name;
	flavourText.text = weekDescs[curWeek];

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
	if (!weeksUnlocked[curWeek]) {
		FlxG.camera.stopFX();
		FlxG.camera.shake(0.005, .5);
		menuOptions[curWeek].color = menuLocks[curWeek].color = 0xFFFF0000;

		FlxG.sound.play(Paths.sound("menu/story/locked"));
		return;
	}
	if (!weeksFinished[curWeek]) return; // OPEN MENU TO PLAY WEEK OR GO TO FREEPLAY

	// SELECT WEEK
	// PLAY ANIM HERE NORMALLY RN ITS JUST A PLACE HOLDER
	playWeek();
}

function playWeek() {
	PlayState.loadWeek(__gen_week(), "hard");
	FlxG.switchState(new ModState("gorefield/LoadingScreen"));
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