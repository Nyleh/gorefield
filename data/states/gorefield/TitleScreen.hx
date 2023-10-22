import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxAxes;

var house:FlxSprite;
var logoBl:FlxSprite;
var textGroup:FlxGroup;
var ngSpr:FlxSprite;
var titleText:FlxSprite;

function create() {
	FlxG.camera.bgColor = FlxColor.fromRGB(17,5,33);
	FlxG.mouse.visible = false;

	textGroup = new FlxGroup();

	house = new FlxSprite(560, 45).loadGraphic(Paths.image('menus/mainmenu/house'));
	house.updateHitbox();
	add(house);

	logoBl = new FlxSprite(16, 10);
	logoBl.frames = Paths.getSparrowAtlas('menus/logoMod');
	logoBl.animation.addByPrefix('bump', 'logo bumpin', 24,false);
	logoBl.scale.set(0.8, 0.8);
	logoBl.updateHitbox();
	logoBl.antialiasing = true;
	add(logoBl);

	ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menus/titlescreen/newgrounds_logo'));
	add(ngSpr);
	ngSpr.visible = false;
	ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
	ngSpr.updateHitbox();
	ngSpr.screenCenter(FlxAxes.X);
	ngSpr.antialiasing = true;

	titleText = new FlxSprite(100, 576);
	titleText.frames = Paths.getSparrowAtlas('menus/titlescreen/titleEnter');
	titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
	titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
	titleText.antialiasing = true;
	titleText.animation.play('idle');
	titleText.updateHitbox();
	add(titleText);

	if(skippedIntro) return;
	blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(17,5,33));
	add(blackScreen);

	add(textGroup);
	trace("Start Mod");

	FlxG.sound.playMusic(Paths.music('gorefield-menuINTRO'),0.7,false);
	Conductor.changeBPM(96);
}

public function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('titlescreen/introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

public function createCoolText(textArray:Array<String>)
	{
		for (i=>text in textArray)
		{
			if (text == "" || text == null) continue;
			var money:Alphabet = new Alphabet(0, (i * 60) + 200, text, true, false);
			money.screenCenter(FlxAxes.X);
			textGroup.add(money);
		}
	}

public function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, (textGroup.length * 60) + 200, text, true, false);
		coolText.screenCenter(FlxAxes.X);
		textGroup.add(coolText);
	}

public function deleteCoolText()
	{
		while (textGroup.members.length > 0) {
			textGroup.members[0].destroy();
			textGroup.remove(textGroup.members[0], true);
		}
	}

function beatHit(curBeat:Int)
	{
		logoBl.animation.play('bump',true);

		FlxTween.tween(FlxG.camera, {zoom: 1.02}, 0.3, {ease: FlxEase.quadOut, type: FlxTween.BACKWARD});

		if(skippedIntro) return;
		switch (curBeat)
		{
			case 2:
				createCoolText(["FNF' Gorefield Team"]);
			case 4:
				addMoreText('Present');
			case 5:
				deleteCoolText();
			case 6:
				createCoolText(['In not association', 'with'], -40);
			case 8:
				addMoreText('newgrounds', -40);
				ngSpr.visible = true;
			case 9:
				deleteCoolText();
				ngSpr.visible = false;
			case 10:
				createCoolText(["Dathree estuvo aqui"]);
			case 12:
				addMoreText("-Dathree");
			case 13:
				deleteCoolText();
			case 14:
				createCoolText(["I don't speak spanish"]);
			case 15:
				addMoreText("-Lean");
			case 16:
				deleteCoolText();
			case 17:
				createCoolText(["Gorefield para ti BB"]);
			case 18:
				addMoreText("-Nexus");
			case 19:
				deleteCoolText();
			case 20:
				createCoolText(["Jon requiero enchiladas"]);
			case 21:
				addMoreText("-Bitfox");
			case 22:
				deleteCoolText();
			case 23:
				createCoolText(["Fifa 24"]);
			case 24:
				addMoreText("-Jloor");
			case 25:
				deleteCoolText();
			case 26:
				createCoolText(["JLoorcito fiu fiu"]);
			case 27:
				addMoreText("-Zero");
			case 28:
				deleteCoolText();
			case 29:
				createCoolText(["el peor mod de fnf"]);
			case 30:
				addMoreText("-Keneth");
			case 31:
				deleteCoolText();
			case 32:
				addMoreText("FNF'");
			case 33:
				addMoreText('Vs Gorefield');
			case 34:
				addMoreText('Part II');
			case 36:
				skipIntro();
		}
	}

static var skippedIntro:Bool = false;

function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(textGroup);
			remove(blackScreen);
			FlxG.camera.flash(FlxColor.WHITE, 2);
			skippedIntro = true;
			FlxG.sound.playMusic(Paths.music('gorefield-menuLOOP'));
		}
	}

var transitioning:Bool = false;

function update(elapsed:Float) {
	var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

	if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

	if (pressedEnter && !skippedIntro){
		skipIntro();
	}
	else if (pressedEnter && !transitioning && skippedIntro){
		pressEnter();
	}
}

function pressEnter() {
	titleText.animation.play('press',true);

	FlxG.camera.flash(FlxColor.WHITE, 1);
	FlxG.sound.play(Paths.sound('menu/confirmMenu'), 1);

	transitioning = true;
	// FlxG.sound.music.stop();

	new FlxTimer().start(1.4, (_) -> 	FlxG.switchState(new MainMenuState()));
}