import flixel.FlxObject;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

var curSelected:Int = 0;
var iconGroup:FlxTypedGroup<FlxSprite>;

var descText:FlxText;

var credits:Array<Array<String>> = [
	// Name's - Role - Random Description
	["Zero Artist", "Director, Artist, and Pixel Artist", "ElTilinaso999"],
	["Jloor", "Director, Coder", "Tu Jloor Favorito! (Matate Zero, Peruano chamaco), Porfavor Ecuador Clasifica al Mundial"],
	["BitfoxOriginal", "Co Director, Musician, Pixel Artist and Charter", "El Chamaco Indio (Lo pusieron de Co director)"],
	["Dathree_O", "Artist", "El Verdadero Charter y Viva Peru"],
	["JoaDash", "Pixel Artist", "Matate oe, no trabaja"],
	["Ani Manny", "Artist", "El de los chistes bien chistosos"],
	["Lunar Cleint", "Coder", "El Mejor Coder de Todos los Tiempos (Messi)"],
	["Lean", "Coder", "Lean..."],
	["EstoyAburridoW", "Coder", "Viciado en Celeste y viva Peru de nuevo"],
	["Ne_Eo", "Coder", "Si"],
	["Nexus Moon", "Musician", "El Undertale"],
	["AlexR", "Musician", "El que se Murio (Nunca regreso y no se que hace aqui)"],
	["Awe", "Musician", "Otra que se murio"],
	["Deadshot", "Charter", "Otra vez, viva Peru!"],
	["Tok", "Charter", "Se murio, no charteo"],
	["KingFox", "Voice Actor", "El lobo de animal crossing!!!"],
	["Lumpy Touch", "Gorefield Animation Creator", "El lobo de animal crossing!!!"],
	["Jars Drawings", "Ultra Gorefield Design", "El lobo de animal crossing!!!"],
	["Omega Black Art", "Ultra Gorefield Design", "El lobo de animal crossing!!!"],
	["Aytanner", "Original Mondaylovania Musician", "El lobo de animal crossing!!!"]
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

	var sizeArray:Array<String> = 
	["Lumpy Touch", "Jars Drawings", "Omega Black Art", "Aytanner"]; //need to size these portraits to match the others
	for (i in 0...credits.length)
	{
		var icon:FlxSprite = new FlxSprite(i % 3 * 370 + 80, Std.int(i / 3) * 420);
		icon.loadGraphic(Paths.image('menus/credits/' + credits[i][0]));
		icon.setGraphicSize(332);
		icon.ID = i;
		icon.alpha = 0.5;
		for(z in 0...sizeArray.length){
			if(credits[i][0] == sizeArray[z]){
				icon.setGraphicSize(332 + 15);
				icon.y += 7;
			}
		}
		icon.updateHitbox();
		iconGroup.add(icon);
	}

	FlxG.camera.follow(camFollowPos, null, 1);

	descText = new FlxText(32, 10, FlxG.width, "", 19, true);
	descText.setFormat("fonts/pixelart.ttf", 30, FlxColor.WHITE, "center");
	descText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 6, 100);
	descText.scrollFactor.set();
	add(descText);

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
			changeSelection(-3);
		if (controls.DOWN_P)
			changeSelection(3);

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

	var previousY = iconGroup.members[curSelected].y;
	iconGroup.members[curSelected].alpha = 1;
	camFollow.setPosition(640, Std.int(curSelected / 3) * 420 + 270);
	iconGroup.members[curSelected].y = previousY + 20;
	FlxTween.tween(iconGroup.members[curSelected],{y: previousY},0.3, {ease: FlxEase.backOut});

	descText.text = credits[curSelected][1];
}