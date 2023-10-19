import flixel.FlxObject;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

var curSelected:Int = 0;
var iconGroup:FlxTypedGroup<FlxSprite>;

var descText:FlxText;

var credits:Array<Array<String>> = [
	// Name's - Rol - Random Description
	["Zero Artist", "Director, Artist, Animator", "ElTilinaso999"],
	["Jloor", "Director, Coder", "Tu Jloor Favorito! (Matate Zero, Peruano chamaco), Porfavor Ecuador Clasifica al Mundial"],
	["BitfoxOriginal", "Main Musician, Sound Effects and Co-director", "El Chamaco Indio (Lo pusieron de Co-director)"],
	["Lunar Cleint", "Main Coder", "El Mejor Coder de Todos los Tiempos (Messi)"],
	["Nenus Moon", "Musician", "El Undertale"],
	["AlexR", "Musician", "El que se Murio (Nunca regreso y no se que hace aqui)"],
	["LeanDapper", "Coder", "Lean..."],
	["Awe", "Musician", "Otra que se murio"],
	["Dathree_O", "Artist", "El Verdadero Charter y Viva Peru"],
	["JoaDash", "Extra Pixel Artist", "Matate oe, no trabaja"],
	["Deadshot", "Charter", "Otra vez, viva Peru!"],
	["Tok", "Charter", "Se murio, no charteo"],
	["EstoyAburridoW", "Coder", "Viciado en Celeste y viva Peru de nuevo"],
	/*["Ani-Manny", "Artist", "El de los chistes bien chistosos"],
	["Ne_Eo", "Coder", "Si"],
	["KingFox", "Voice Actor", "El lobo de animal crossing!!!"]*/
];

var camFollow:FlxObject;
var camFollowPos:FlxObject;

function create() 
{
	var background:FlxSprite = new FlxSprite();
	background.loadGraphic(Paths.image("menus/credits/BG_0"));
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
		icon.loadGraphic(Paths.image('menus/credits/' + credits[i][0]));
		icon.setGraphicSize(332);
		icon.ID = i;
		icon.alpha = 0.5;
		icon.updateHitbox();
		iconGroup.add(icon);
	}

	FlxG.camera.follow(camFollowPos, null, 1);

	descText = new FlxText(32, 0, FlxG.width, "", 19, true);
	descText.setFormat("fonts/pixelart.ttf", 18, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	descText.scrollFactor.set();
	//add(descText);

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

	curSelected = FlxMath.wrap(curSelected + change, 0, credits.length-1);

	iconGroup.members[curSelected].alpha = 1;
	camFollow.setPosition(640, iconGroup.members[curSelected].getGraphicMidpoint().y + 130);

	//descText.text = credits[curSelected][1];
}