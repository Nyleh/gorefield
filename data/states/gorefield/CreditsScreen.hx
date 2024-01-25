import flixel.FlxObject;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import funkin.backend.system.framerate.Framerate;

var curSelected:Int = 0;
var iconGroup:FlxTypedGroup<FlxSprite>;

var descText:FlxText;
var descText2:FlxText;
var descTextName:FlxText;

var credits:Array<Array<String>> = [
	// Name's - Role - Random Description
	["Jloor", "Director, Coder", "Tu Jloor Favorito! (Matate Zero, Peruano chamaco), Porfavor Ecuador Clasifica al Mundial"],
	["Zero Artist", "Director, Artist, and Pixel Artist", "Por su culpa el mod se retrasó 2 años (No escuchaste la canción?)"],
	["BitfoxOriginal", "Co Director, Musician, SFX Designer, Voice Actor [Lasagna Boy y Gorefield], Pixel Artist and Charter", "Sacrifiqué mucho tiempo de mi vida (Espera que valiera la pena)"],
	["Dathree_O", "Artist", "Entró y salió varias veces (Ya parece aldeano de minecraft [Porque entra y sale de la casa todo el tiempo])"],
	["JoaDash", "Pixel Artist", "Tic tac, casi se te va el tren"],
	["Ani Manny", "Artist", "Si algunos íconos estaban animados, es gracias a él"],
	["Uri4n", "Artist", "Jon, llevame contigo"],
	["ZeuzMoons", "Pixel Artist", "Yo salvé el pixel art"],
	["Lunar Cleint", "Main Coder", "hi guys its me lunar de Todos los Tiempos (Messi)"],
	["Lean", "Coder, Musician", "ummmm yeah i coded a lot for the mod"],
	["EstoyAburridow", "Coder", "Jueguen Celeste"],
	["Ne_Eo", "Coder", "Why is the menu not centered?"],
	["Nexus Moon", "Musician", "Experto en megalovanias, licenciado"],
	["AlexR", "Musician", "El que se murió (Nunca regreso y no sé que hace aquí)"],
	["Awe", "Musician", "Es fan de Steven Universe? (Roses and Quartzs = Rose Quartz)"],
	["Deadshot", "Charter", "Solo iba a chartear una canción y charteó casi todo el mod"],
	["Tok", "Charter", "Si no fuera porque Bitfox re hizo las canciones 5 veces, hubira tnido más trabajo"],
	["Trevent", "Charter", "Llego a salvar a Deadshot de su lecho de muerte"],
	["KingFox", "Voice Actor [Godfield y Jon psicópata]", "El tipo que hizo casi todas las voces en Inner Mirror (Jueguen Inner Mirror)"],
	["SpringXy", "Voice Actor [Arlene y Liz]", "Adios al mundo"],
	["Lumpy Touch", "Gorefield Animation Creator", "The Lumpiest of Touches"],
	["William Burke", "Original Gorefield Designer", "The origin of Gorefield (I think)"],
	["Jars Drawings", "Original Ultra Gorefield Designer", "Sheesh"],
	["Omega Black Art", "Original Ultra Gorefield Designer", "Omega Art!!!!"],
	["Aytanner", "Original Mondaylovania Musician", "El Undertale"],
	["Cartoon Cat Team", "Cartoon Cat Team", "Hey hey hey skidibi, no digas toilet"]
];

var camFollow:FlxObject;
var camFollowPos:FlxObject;
var camFollowXOffset:Float;

var iconYArray:Array<Float> = []; //intro stuff

function create() 
{
	Framerate.instance.visible = false;
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
		var icon:FlxSprite = new FlxSprite(i % 3 * 370 + 100, Std.int(i / 3) * 420);
		icon.loadGraphic(Paths.image('menus/credits/' + credits[i][0]));
		icon.setGraphicSize(332);
		icon.ID = i; icon.antialiasing = true;
		icon.alpha = 0.5;
		for(z in 0...sizeArray.length){
			if(credits[i][0] == sizeArray[z]){
				icon.setGraphicSize(332 + 15);
				icon.y += 7;
			}
		}
		icon.updateHitbox();
		iconGroup.add(icon);
		iconYArray.push(icon.y);

		icon.y += 300;
	}

	FlxG.camera.follow(camFollowPos, null, 1);

	descText = new FlxText(32, 10, FlxG.width, "", 19, true);
	descText.setFormat("fonts/pixelart.ttf", 30, FlxColor.WHITE, "center");
	descText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 6, 100);
	descText.scrollFactor.set();
	add(descText);

	descTextName = new FlxText(32, 620, FlxG.width, "", 19, true);
	descTextName.setFormat("fonts/pixelart.ttf", 50, FlxColor.WHITE, "center");
	descTextName.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 50);
	descTextName.scrollFactor.set();
	add(descTextName);

	descText2 = new FlxText(32, descTextName.y + 50, FlxG.width, "", 19, true);
	descText2.scrollFactor.set();
	add(descText2);

	var vigentte:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/black_vignette"));
	vigentte.alpha = 0.4; vigentte.scrollFactor.set(0,0);
	add(vigentte);

	for (i in 0...iconGroup.length){
		FlxTween.tween(iconGroup.members[i], {y: iconYArray[i]}, 0.7,{ease: FlxEase.cubeOut, startDelay: 0.04 * i, onComplete: (tmr:FlxTween) -> {
			intro = false;
		}});
	}
	changeSelection(0);
}

var quitting:Bool = false;
var intro:Bool = true;

function update(elapsed:Float)
{
	var lerpVal:Float = Math.max(0, Math.min(1, elapsed * 7.5));
	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x+camFollowXOffset, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

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
			var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/cancelMenu")); sound.volume = 1; sound.play();
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
	camFollow.setPosition(640, Std.int(curSelected / 3) * 420 + 230);
	if(!intro)
	{
		iconGroup.members[curSelected].y = iconYArray[curSelected] + 20;
		FlxTween.tween(iconGroup.members[curSelected],{y: iconYArray[curSelected]},0.3, {ease: FlxEase.backOut});
	}

	var creditName:String = credits[curSelected][0];
	var creditRole:String = credits[curSelected][1];
	var creditDescription:String = credits[curSelected][2];

	camFollowXOffset = creditName == "Ne_Eo" ? 35 : 0;

	descText.text = creditRole;
	descText2.text = creditDescription;
	if(descText2.text.length > 55){
		descText2.setFormat("fonts/pixelart.ttf", 20, 0xF2C0AC, "center");
		descText2.y = descTextName.y + 55;
	}
	else{
		descText2.setFormat("fonts/pixelart.ttf", 30, 0xF2C0AC, "center");
		descText2.y = descTextName.y + 50;
	}
	descText2.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3.2, 50);
	descTextName.text = creditName;

	descText.screenCenter(FlxAxes.X);
	descText2.screenCenter(FlxAxes.X);
	descTextName.screenCenter(FlxAxes.X);
}

function onDestroy() Framerate.instance.visible = true;