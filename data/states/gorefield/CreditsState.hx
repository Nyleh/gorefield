import flixel.FlxObject;

var curSelected:Int = 0;
var iconGroup:FlxTypedGroup<FlxSprite>;

var credits:Array<Array<String>> = [
	// Don't judge me, Zero told me to put these texts
	["ZERO", "Dirzector, artista, animador, escritor, artista de fondos, artista de menu, artista de creditos, pixel artist, ayudante musical, resurector del mod, explicador de canciones"],
	["JLOOR", "Co director, coder, el jloor favorito, voy a matar a Zero"],
	["LUNAR CLEINT", "Coder"],
	["NEXUS MOON", "Musico"],
	["ALEXR", "Musico"],
	["LEAN", "Coder"],
	["AWE", "Musico"],
	["DATHREE_O", "Artista"],
	["JOA DASH", "Extra pixel artist"],
	["DEADSHOT", "Charter"],
	["TOK", "Charter"],
	["ESTOYABURRIDOW", "Ayudante musical, coder"],
	["BITFOXORIGINAL", "Musico principal y diseñador de sonido y co director"]
];

var camFollow:FlxObject;
var camFollowPos:FlxObject;

function create() 
{
	var background:FlxSprite = new FlxSprite();
	background.loadGraphic(Paths.image("credits/BG_0"));
	background.setGraphicSize(FlxG.width, FlxG.height);
	background.updateHitbox();
	background.scrollFactor.set();
	add(background);

	camFollow = new FlxObject(640, 342, 1, 1);
	camFollowPos = new FlxObject(640, 342, 1, 1);
	add(camFollow);
	add(camFollowPos);

	iconGroup = new FlxTypedGroup();
	add(iconGroup);

	for (i in 0...credits.length) 
	{
		var icon:FlxSprite = new FlxSprite(i % 2 * 370 + 20, Std.int(i / 2) * 420);
		icon.loadGraphic(Paths.image('credits/' + credits[i][0]));
		icon.setGraphicSize(332);
		icon.ID = i;
		icon.alpha = 0.5;
		icon.updateHitbox();
		iconGroup.add(icon);
	}

	FlxG.camera.follow(camFollowPos, null, 1);

	changeSelection(0);
}

var quitting:Bool = false;

function update(elapsed:Float) 
{
	var lerpVal:Float = Math.max(0, Math.min(1, elapsed * 7.5));
	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

	if (!quitting) 
	{
		if (controls.LEFT_P)
			changeSelection(-1);
		if (controls.RIGHT_P)
			changeSelection(1);
		if (controls.UP_P)
			changeSelection(-2);
		if (controls.DOWN_P)
			changeSelection(2);

		if (controls.BACK) 
		{
			FlxG.sound.play(Paths.sound("menu/cancelMenu"));
			FlxG.switchState(new MainMenuState());
		}
	}
}

function changeSelection(change:Int) 
{
	FlxG.sound.play(Paths.sound("menu/scrollMenu"));

	iconGroup.members[curSelected].alpha = 0.5;

	curSelected += change;

    if (curSelected >= credits.length)
        curSelected = 0;
    if (curSelected < 0)
        curSelected = credits.length - 1;

	iconGroup.members[curSelected].alpha = 1;
	camFollow.setPosition(640, iconGroup.members[curSelected].getGraphicMidpoint().y + 130);

	// descText.text = credits[curSelected][1];
}
