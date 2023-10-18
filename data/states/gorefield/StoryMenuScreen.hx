//
import flixel.FlxObject;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.AssetsLibraryList.AssetSource;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

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

var weeks:Array = [];
var weeksUnlocked:Array<Bool> = [true, false, false, false, false, false];

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
	camBG.addShader(warpShader);

	bloomShader = new CustomShader("glow");
	bloomShader.size = 18.0;// trailBloom.quality = 8.0;
    bloomShader.dim = 0.8;// trailBloom.directions = 16.0;
	bgSprite.shader = bloomShader;

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

	flavourText = new FunkinText(weekText.x, weekText.y + weekText.height + 10, FlxG.width, "Current Story Menu Description", 18, true);
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
		menuOption.color = weeksUnlocked[i] ? 0xFFFFFFFF : 0xFFBDBEFF;
		menuOption.alpha = weeksUnlocked[i] ? 1 : 0.75;

		menuLocks[i].visible = !weeksUnlocked[i];
		menuLocks[i].x = (menuOption.x + (menuOption.width/2)) - (menuLocks[i].width/2) + Math.floor(4 * Math.sin(__totalTime));
		menuLocks[i].y = (menuOption.y + (menuOption.height/2)) - (menuLocks[i].height/2) + Math.floor(2 * Math.cos(__totalTime));
	}
	__firstFrame = false;

	selector.setPosition((menuOptions[curWeek].x - selector.width - 36), menuOptions[curWeek].y + ((menuOptions[curWeek].height/2) - (selector.height/2)));

	if (!canMove) return;

	if (controls.DOWN_P)
		changeWeek(1);
	else if (controls.UP_P)
		changeWeek(-1);

}

function changeWeek(change:Int) {
	curWeek = FlxMath.wrap(curWeek + change, 0, menuOptions.length-1);

	FlxG.sound.play(Paths.sound('menu/scrollMenu'));

	textBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textBG.updateHitbox();

	textInfoBG.scale.set(FlxG.width, scoreText.height + 38);
	textInfoBG.updateHitbox();
	textInfoBG.y = FlxG.height - textInfoBG.height;

	scoreText.y = FlxG.height - scoreText.height - 22;
}

function onDestroy() {FlxG.camera.bgColor = FlxColor.fromRGB(0,0,0); curStoryMenuSelected = curWeek;}


// BOILER PLATE

public function getWeeksFromSource(weeks:Array<String>, source:AssetSource) {
	var path:String = Paths.txt('freeplaySonglist');
	var weeksFound:Array<String> = [];
	if (Paths.assetsTree.existsSpecific(path, "TEXT", source)) {
		var trim = "";
		weeksFound = CoolUtil.coolTextFile(Paths.txt('weeks/weeks'));
	} else {
		weeksFound = [for(c in Paths.getFolderContent('data/weeks/weeks/', false, source)) if (Path.extension(c).toLowerCase() == "xml") Path.withoutExtension(c)];
	}
	
	if (weeksFound.length > 0) {
		for(s in weeksFound)
			weeks.push(s);
		return false;
	}
	return true;
}