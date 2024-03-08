import flixel.FlxObject;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.system.framerate.Framerate;

var curSelected:Int = 0;
var iconGroup:FlxTypedGroup<FlxSprite>;

var descText:FlxText;
var descText2:FlxText;
var descTextName:FlxText;

var credits:Array<Array<Dynamic>> = [
	// Name's - Role[EN, ES] - Random Description[EN, ES] - Social link
	["Jloor",
		["Director, Coder", "Director, Coder"], 
		["Your favorite Jloor! (Zero, you should kill yourself, now! Peruvian chamaco), Please Ecuador qualify for the World Cup",
		"Tu Jloor favorito! (Matate Zero, Peruano chamaco), Porfavor Ecuador clasifica al Mundial"],
		"https://twitter.com/GamerJloor"
	],
	["Zero Artist",
		["Director, Artist and Pixel Artist", "Director, Artista y Artista Pixel"], 
		["Because of him the mod was delayed 2 years (Didn't you hear the song?)", 
		"Por su culpa el mod se retraso 2 años (No escuchaste la cancion?)"],
		"https://twitter.com/zero_artist02"
	],
	["BitfoxOriginal", 		
		["Co Director, Musician, SFX Designer, Voice Actor (Lasagna Boy and Gorefield), Pixel Artist and Charter",
		"Co Director, Musico, Diseñador de SFX, Actor de Voz (Lasagna Boy y Gorefield), Artista Pixel y Charter"], 
		["I sacrificed a lot of time of my life (Hope it was worth it)", 
		"Sacrifique mucho tiempo de mi vida (Espera que valiera la pena)"],
		"https://twitter.com/BitfoxOriginal"
	],
	["Dathree_O", 			
		["Artist and Pixel Artist", "Artista y Artista Pixel"], 
		["He entered and left several times (Like a Minecraft villager [Because he enters and leaves the house all the time])",
		"Entro y salio varias veces (Ya parece aldeano de minecraft [Porque entra y sale de la casa todo el tiempo])"],
		"https://twitter.com/Dathree_O"
	],
	["JoaDash",
		["Artist and Pixel Artist", "Artista y Artista Pixel"], 
		["Tic tac, you almost didn't catch the train", "Tic tac, casi se te va el tren"],
		"https://twitter.com/TotallyNotJoa"
	],
	["Ani Manny",
		["Artist", "Artista"], 
		["If some icons were animated, it is thanks to him", "Si algunos iconos estaban animados, es gracias a el"],
		"https://twitter.com/ani__manny"
	],
	["Uri4n",
		["Artist", "Artista"], 
		["Hello im colombian people, nice to meet you", "Los sueños se cumplen chabales, solo que el mio no se a cumplido"],
		"https://twitter.com/Ur14n1"
	],
	["ZeuzMoons",
		["Artist and Pixel Artist", "Artista y Artista Pixel"], 
		["I saved pixel art, this one goes for you Guiller", "Yo salve el pixel art, te la dedico Guilller"],
		"https://twitter.com/ZeuzMoons"
	],
	["Lunar Cleint", 		
		["Main Coder", "Coder Principal"], 
		["hi guys its me lunar de Todos los Tiempos (Messi)", "hola chicos soy yo lunar of All Times (Messi)"],
		"https://twitter.com/lunarcleint"
	],
	["Lean",
		["Coder, Musician, SFX Designer", "Coder, Musico, Diseñador de SFX"], 
		["ummmm yeah i coded a lot for the mod", "ummmm si yo codifique una banda para el mod"],
		"https://twitter.com/NewLeandapper"
	],
	["EstoyAburridow", 		
		["Coder", "Coder"], 
		["Play Celeste", "Jueguen Celeste"],
		"https://twitter.com/EstoyAburridop"
	],
	["Ne_Eo", 				
		["Coder", "Coder"], 
		["Why is the menu not centered?", "¿Por que el menu no esta centrado?"],
		"https://twitter.com/Ne_Eo_Twitch"
	],
	["Nexus Moon", 			
		["Musician", "Musico"], 
		["Expert in megalovanias, licensed", "Experto en megalovanias, licenciado"],
		"https://twitter.com/Nexus_Moon7"
	],
	["AlexR",
		["Musician", "Musico"], 
		["The one who died (He never came back and I don't know what he's doing here)", 
		"El que se murio (Nunca regreso y no se que hace aqui)"],
		"https://twitter.com/22Alexr"
	],
	["Awe",
		["Musician", "Musico"], 
		["Is a fan of Steven Universe? (Roses and Quartzs = Rose Quartz)", "Es fan de Steven Universe? (Roses and Quartzs = Rose Cuarzo)"],
		"https://www.youtube.com/@awe9037"
	],
	["Deadshot", 			
		["Charter", "Charter"], 
		["He was only going to chart one song and he charted most of the mod.", 
		"Solo iba a chartear una cancion y charteo casi todo el mod"],
		"https://twitter.com/d3adsh0ter"
	],
	["Tok",
		["Charter", "Charter"], 
		["If it wasn't for Bitfox redoing the songs 5 times, would had more work to do.", 
		"Si no fuera porque Bitfox re hizo las canciones 5 veces, hubira tnido mas trabajo"],
		"https://twitter.com/ThatOne_Kid39"
	],
	["Trevent",
		["Charter", "Charter"], 
		["Arrived to save Deadshot from his deathbed", "Llego a salvar a Deadshot de su lecho de muerte"],
		"https://twitter.com/BoohTrevent"
	],
	["KingFox",
		["Voice Actor (Godfield and Psychopathic Jon)", "Actor de Voz (Godfield y Jon Psicopata)"], 
		["The guy who did almost all the voices in Inner Mirror (Play Inner Mirror)",
		"El tipo que hizo casi todas las voces en Inner Mirror (Jueguen Inner Mirror)"],
		"https://twitter.com/VOKINGF0X"
	],
	["SpringXy",
		["Voice Actor (Arlene and Liz)", "Actor de Voz (Arlene y Liz)"], 
		["Goodbye To a World", "Adios Al Mundo"],
		"https://twitter.com/SpringXy_1YT"
	],
	["Lumpy Touch",
		["Gorefield Animation Creator", "Creador de la Animacion de Gorefield"], 
		["The Lumpiest of Touches", "The Lumpiest of Touches"],
		"https://twitter.com/LumpyTouch"
	],
	["William Burke", 		
		["Original Gorefield Designer", "Diseñador Original de Gorefield"], 
		["The origin of Gorefield (I think)", "El origen de Gorefield (Creo)"],
		"https://www.instagram.com/goblin___warlock/"
	],
	["Jars Drawings",
		["Original Ultra Gorefield Designer", "Diseñador Original de Ultra Gorefield"], 
		["Sheesh", "Sheesh"],
		"https://twitter.com/jars_drawings"
	],
	["Omega Black Art", 	
		["Original Ultra Gorefield Designer", "Diseñador Original de Ultra Gorefield"], 
		["Omega Art!!!!", "Omega Arte!!!!"],
		"https://www.instagram.com/omegablackart/?hl=es"
	],
	["Aytanner",
		["Original Mondaylovania Musician", "Musico Original de Mondaylovania"], 
		["The Undertale", "El Undertale"],
		"https://on.soundcloud.com/PSZXo"
	],
	["Cartoon Cat Team", 	
		["Cartoon Cat Team", "Cartoon Cat Team"], 
		["iTzDaniel456, Samuroarx2, KenethYT, Carlone Wenson and FRANDERMAN123", "iTzDaniel456, Samuroarx2, KenethYT, Carlone Wenson y FRANDERMAN123"],
		"https://twitter.com/CartoonCatFNF"
	],
	["Jacadamia",
		["Jon, Take Me with you Animation Creator", "Creador de la animacion Jon, Take Me with you"], 
		["guys i don't think jon took him", "chicos, no creo que jon lo haya llevado"],
		"https://twitter.com/jacadamiajack"
	]
];

var camFollow:FlxObject;
var camFollowPos:FlxObject;
var camFollowXOffset:Float;

var language:Int = FlxG.save.data.spanish ? 1 : 0;

var iconYArray:Array<Float> = []; //intro stuff

function create() 
{
	Framerate.instance.visible = false;
	DiscordUtil.changePresence('Scrolling Through Menus...', "Credits");
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
	["Lumpy Touch", "Jars Drawings", "Omega Black Art", "Aytanner", "Jacadamia"]; //need to size these portraits to match the others
	for (i in 0...credits.length)
	{
		var icon:FlxSprite = new FlxSprite(i % 3 * 370 + 100, Std.int(i / 3) * 420);
		icon.loadGraphic(Paths.image((moustacheMode ? 'menus/credits/moustache/' : 'menus/credits/') + credits[i][0]));
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
	descText.setFormat("fonts/Harbinger_Caps.otf", 30, FlxColor.WHITE, "center");
	descText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 6, 100);
	descText.scrollFactor.set();
	add(descText);

	descTextName = new FlxText(32, 620, FlxG.width, "", 19, true);
	descTextName.setFormat("fonts/Harbinger_Caps.otf", 50, FlxColor.WHITE, "center");
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

function update(elapsed:Float) {
	var lerpVal:Float = Math.max(0, Math.min(1, elapsed * 7.5));
	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x+camFollowXOffset, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

	if (!quitting) {
		if (controls.LEFT_P)
			changeSelection(-1);
		if (controls.RIGHT_P)
			changeSelection(1);
		if (controls.UP_P)
			changeSelection(-3);
		if (controls.DOWN_P)
			changeSelection(3);

		if (controls.ACCEPT)
			CoolUtil.openURL(credits[curSelected][3]);

		if (controls.BACK) {
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
	var creditRole:String = credits[curSelected][1][language];
	var creditDescription:String = credits[curSelected][2][language];

	camFollowXOffset = creditName == "Ne_Eo" ? 35 : 0;

	descText.text = creditRole;
	descText2.text = creditDescription;
	if(descText2.text.length > 55){
		descText2.setFormat("fonts/Harbinger_Caps.otf", 20, 0xF2C0AC, "center");
		descText2.y = descTextName.y + 55;
	}
	else{
		descText2.setFormat("fonts/Harbinger_Caps.otf", 30, 0xF2C0AC, "center");
		descText2.y = descTextName.y + 50;
	}
	descText2.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3.2, 50);
	descTextName.text = creditName;

	descText.screenCenter(FlxAxes.X);
	descText2.screenCenter(FlxAxes.X);
	descTextName.screenCenter(FlxAxes.X);
}

function destroy() {Framerate.instance.visible = true; moustacheMode = false;}