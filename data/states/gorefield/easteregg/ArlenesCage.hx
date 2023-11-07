//
import flixel.util.FlxAxes;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import flixel.sound.FlxSound;
import funkin.backend.system.framerate.Framerate;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.effects.FlxTrail;

var box:FlxSprite;
var prompt:FlxSprite;
var bars:FlxSprite;
var eyes:FlxSprite;
var black:FlxSprite;

var cloudBubble1:FlxSprite;
var cloudBubble2:FlxSprite;
var cloudTrail:FlxTrail;
var cloud:FlxSprite;
var cloudPortrait:FlxSprite;

var dialoguetext:FlxText;
var __curTxTIndx:Int = -1;
var __finishedMessage:String = "";
var __skippedText:Bool = false;
var __canAccept:Bool = false;

var __randSounds:Array<String> = ["easteregg/snd_text", "easteregg/snd_text_2"];
var dialogueList:Array<{message:String, expression:String, typingSpeed:Float, startDelay:Float, event:Int->Void}> = [];
var endingCallback:Void->Void = function () {
	dialoguetext.alpha = 1;
	dialoguetext.text = "END DIALOGUE\n(ESC to go back to title)";
};
var curDialogue:Int = -1;

var menuMusic:FlxSound;
var clownTheme:FlxSound;
var wind:FlxSound;
var introSound:FlxSound;

var grpClouds = null;
var grpClouds1 = null;
var grpClouds2 = null;
var cacheInfo = [null, null, null, null];
var cacheInfo1 = [null, null, null, null];
var cacheInfo2 = [null, null, null, null];

function create()
{
	Framerate.instance.visible = false;

	FlxG.sound.music.volume = 0;
	/**
	 * Idea for this:
	 * -1 cant visit (not there)
	 * 0 first visit
	 * 1 first dialogue after visit
	 * 2 first note first found
	 * 3 first note after found
	 * 4 second note
	 * 5 second note after found
	 * 6 third note
	 * 7 third note after found
	 */
	FlxG.save.data.arlenePhase = 0;
	FlxG.save.data.canVisitArlene = true;

	switch (FlxG.save.data.arlenePhase) {
		case 0: dialogueList = firstVisitDialogue; endingCallback = firstVisitEndCallback;
	}

	bars = new FlxSprite(0, FlxG.height/6).loadGraphic(Paths.image("easteregg/Arlene_Box"));
	bars.scale.set(6, 6); bars.updateHitbox(); bars.screenCenter(FlxAxes.X);
	
	if (FlxG.save.data.arlenePhase != -1)
		menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
	if (FlxG.save.data.arlenePhase != -1)
		clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);
		
	wind = FlxG.sound.play(Paths.sound('easteregg/Wind_Sound'), 0, true);
	FlxTween.tween(wind, {volume: 1}, 6);
		
	eyes = new FlxSprite().loadGraphic(Paths.image("easteregg/Arlene_Eyes"), true, 80, 34);
	eyes.animation.add("normal", [0], 0); eyes.animation.add("left", [1], 0);
	eyes.animation.add("smug", [2], 0); eyes.animation.add("confused", [3], 0);
	eyes.animation.play("normal");
	eyes.alpha = 0.000001; eyes.scale.set(3.5, 3.5); 
	eyes.updateHitbox(); eyes.screenCenter(FlxAxes.X);
	if (FlxG.save.data.arlenePhase != -1) add(eyes);
	add(bars);

	grpClouds = new FlxTypedGroup();

	for(i in 0...4) {
		var cloudd = new FlxSprite().loadGraphic(Paths.image("easteregg/cloudMain"));
		cloudd.scale.set(3.5, 3.5); cloudd.updateHitbox();
		cloudd.setPosition(986, 65);
		cloudd.visible = false;
		grpClouds.add(cloudd);
	}

	grpClouds.ID = 0;
	add(grpClouds);

	cloud = new FlxSprite().loadGraphic(Paths.image("easteregg/cloudMain"));
	cloud.scale.set(3.5, 3.5); cloud.updateHitbox();
	cloud.setPosition(986, 65);

	/* cloudTrail = new FlxTrail(cloud, null, 4, 0, 1, 0.069);
	add(cloudTrail); */

	add(cloud);

	grpClouds1 = new FlxTypedGroup();

	for(i in 0...4) {
		var cloudBubble1d = new FlxSprite().loadGraphic(Paths.image("easteregg/cloud1"));
		cloudBubble1d.scale.set(3.5, 3.5); cloudBubble1d.updateHitbox();
		cloudBubble1d.setPosition(956, 256);
		grpClouds1.add(cloudBubble1d);
	}

	grpClouds1.ID = 1;
	add(grpClouds1);

	cloudBubble1 = new FlxSprite().loadGraphic(Paths.image("easteregg/cloud1"));
	cloudBubble1.scale.set(3.5, 3.5); cloudBubble1.updateHitbox();
	cloudBubble1.setPosition(956, 256);
	add(cloudBubble1);

	grpClouds2 = new FlxTypedGroup();

	for(i in 0...4) {
		var cloudBubble2d = new FlxSprite().loadGraphic(Paths.image("easteregg/cloud2"));
		cloudBubble2d.scale.set(3.5, 3.5); cloudBubble2d.updateHitbox();
		cloudBubble2d.setPosition(900, 246);
		grpClouds2.add(cloudBubble2d);
	}

	grpClouds2.ID = 2;
	add(grpClouds2);

	cloudBubble2 = new FlxSprite().loadGraphic(Paths.image("easteregg/cloud2"));
	cloudBubble2.scale.set(3.5, 3.5); cloudBubble2.updateHitbox();
	cloudBubble2.setPosition(900, 246);
	add(cloudBubble2);

	cloudPortrait = new FlxSprite().loadGraphic(Paths.image("easteregg/Clown"));
	cloudPortrait.scale.set(2.5, 2.5); cloudPortrait.updateHitbox();
	add(cloudPortrait); cloudPortrait.setPosition(cloud.x + 76, cloud.y + 38);

	//FlxG.camera.scroll.x = 200;

	box = new FlxSprite(0, (FlxG.height/6)*3).loadGraphic(Paths.image("easteregg/Arlene_Text"));
	box.scale.set(3.7,3.7); box.alpha = 0; box.scrollFactor.set();
	box.updateHitbox(); box.screenCenter(FlxAxes.X);
	add(box);
	

	/*
	// pixel perfect
var scl = 44/48;

	dialoguetext = new FlxText(box.x + 80, box.y + 70, (box.width - 160), "", 24);
	dialoguetext.setFormat("fonts/pixelart.ttf", 48, 0xff8f93b7, "left", FlxTextBorderStyle.SHADOW, 0xFF19203F);
	dialoguetext.borderSize = 2; dialoguetext.shadowOffset.x += 1; dialoguetext.shadowOffset.y += 1; dialoguetext.wordWrap = true;
	dialoguetext.scale.set(scl, scl);
	add(dialoguetext); dialoguetext.scrollFactor.set();

	*/

	dialoguetext = new FlxText(box.x + 80, box.y + 70, box.width - 160, "", 24);
	dialoguetext.setFormat("fonts/pixelart.ttf", 44, 0xff8f93b7, "left", FlxTextBorderStyle.SHADOW, 0xFF19203F);
	dialoguetext.borderSize = 2; dialoguetext.shadowOffset.x += 1; dialoguetext.shadowOffset.y += 1; dialoguetext.wordWrap = true;
	add(dialoguetext); dialoguetext.scrollFactor.set();

	prompt = new FlxSprite().loadGraphic(Paths.image("easteregg/arrow"));
	prompt.scale.set(3.7,3.7); prompt.updateHitbox(); prompt.alpha = 0;
	prompt.setPosition(box.x + box.width - 160 + prompt.width, box.y + box.height - 64);
	add(prompt); prompt.scrollFactor.set();

	black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
	black.scrollFactor.set();
	add(black);

	for (member in members) {
		if(member == grpClouds || member == grpClouds1 || member == grpClouds2) continue;
		member.antialiasing = false;
		member.visible = member == bars || member == black ? true : FlxG.save.data.canVisitArlene;
	}
	grpClouds.visible = cloud.visible = cloudBubble1.visible = cloudBubble2.visible = cloudPortrait.visible = grpClouds.visible = grpClouds1.visible = grpClouds2.visible = false;

	fastFirstFade = FlxG.save.data.arlenePhase >= 1;
	introSound = FlxG.sound.load(Paths.sound('easteregg/snd_test'), 0.4);
	(new FlxTimer()).start((FlxG.save.data.arlenePhase >= 1 ? 2 : 4)/8, function () introSound.play(), 8);
	if (FlxG.save.data.arlenePhase == -1 && FlxG.save.data.canVisitArlene) return;
	(new FlxTimer()).start(FlxG.save.data.arlenePhase >= 1 ? 4.2 : 6.2, function () FlxG.sound.play(Paths.sound('easteregg/mus_sfx_cinematiccut'), 0.1));
	(new FlxTimer()).start(FlxG.save.data.arlenePhase >= 1 ? 6 : 8, progressDialogue);
}

var fastFirstFade:Bool = false;
var fadeOut:Bool = false;
var blackTime:Float = 0;
var tottalTime:Float = 0;
var gayTimer = 0;
var firstFrame = true;
function update(elapsed) {
	tottalTime += elapsed; blackTime += elapsed; gayTimer += elapsed;

	eyes.y = bars.y + ((bars.height/2)-(eyes.height/2)) + Math.floor(5 * FlxMath.fastSin(tottalTime + (Math.PI/2)));
	var blackA:Float = Math.floor(((blackTime * (fastFirstFade ? 2 : 1))/4) * 8) / 8;
	black.alpha = FlxMath.bound(fadeOut ? blackA : 1-blackA, 0, 1);

	prompt.y = box.y + box.height - 64 + Math.floor(4 * FlxMath.fastSin(tottalTime* 1.5));
	prompt.color = tottalTime % 1 > .5 ? 0xFFADADAD : 0xFFFFFFFF;

	prompt.alpha = __canAccept && __curTxTIndx == __finishedMessage.length-1 ? 1 : 0;

	cloud.setPosition(986 + (6 * (Math.floor(FlxMath.fastSin(tottalTime/1.5)*4)/4)), 65 + (6 * (Math.floor(FlxMath.fastCos(tottalTime/1.5)*4)/4)));
	cloudBubble1.setPosition(956 + (6 * (Math.floor(FlxMath.fastSin((tottalTime+.2)/1.5)*4)/4)) + (tottalTime*6%6), 256+ (4 * (Math.floor(FlxMath.fastCos((tottalTime+.2)/1.5)*4)/4)));
	cloudBubble2.setPosition(900 + (6 * (Math.floor(FlxMath.fastSin((tottalTime+.3)/1.5)*4)/4)), 246 + (4 * (Math.floor(FlxMath.fastCos((tottalTime+.3)/1.5)*4)/4)));
	/*for (i=>tt in cloudTrail.members) {
		var scale = Math.max(1.3 + .11 * FlxMath.fastSin(tottalTime + (i * FlxG.random.float(0, .3))), 0.9);
		tt.scale.set(3 + scale, 3 + scale);
	}*/

	var cis = [cacheInfo, cacheInfo1, cacheInfo2];

	for(ci in cis) {
		for(c in ci) {
			if(c != null) c.alpha -= 0.25 * elapsed;
		}
	}

	for(grp in [grpClouds, grpClouds1, grpClouds2])
	for(i => c in grp.members) {
		var inf = cis[grp.ID][i];
		if(inf != null) {
			c.visible = true;
			c.x = inf.x;
			c.y = inf.y;
			c.alpha = inf.alpha;
			c.scale.x = c.scale.y = 2.7 + Math.max(1 + .11 * FlxMath.fastSin(tottalTime + (i * FlxG.random.float(0, .3))), 0.9);
		}
	}

	var delya = 1;//1/1;
	while(gayTimer > delya) {
		cacheInfo[0] = {
			x: cloud.x,
			y: cloud.y,
			alpha: 0.7,
		}
		cacheInfo.push(cacheInfo.shift());

		cacheInfo1[0] = {
			x: cloudBubble1.x,
			y: cloudBubble1.y,
			alpha: 0.7,
		}
		cacheInfo1.push(cacheInfo1.shift());

		cacheInfo2[0] = {
			x: cloudBubble2.x,
			y: cloudBubble2.y,
			alpha: 0.7,
		}
		cacheInfo2.push(cacheInfo2.shift());
		gayTimer -= delya;
	}

	cloudPortrait.setPosition(cloud.x + 76 + FlxG.random.int(-1, 1), cloud.y + 38 + FlxG.random.int(-1, 1));

	if (tottalTime >= (fastFirstFade ? 2 : 4)) eyes.alpha = FlxMath.bound((Math.floor(((tottalTime-(fastFirstFade ? 4 : 6))/2) * 8) / 8), 0, 1);

	if (controls.ACCEPT && __canAccept) progressDialogue();
	if (controls.BACK) FlxG.switchState(new TitleState());

	firstFrame = false;
}

function progressDialogue() {
	if (__curTxTIndx != __finishedMessage.length-1) {__skippedText = true; return;}

	if (curDialogue++ >= dialogueList.length-1) {box.alpha = dialoguetext.alpha = prompt.alpha = 0; endingCallback(); __canAccept = false; endDialogue(); return;}
	var dialogueData = dialogueList[curDialogue]; endDialogue();

	__curTxTIndx = 0; __canAccept = true;
	dialoguetext.text = __finishedMessage = "";

	(new FlxTimer()).start(dialogueData.startDelay == null ? 0 : dialogueData.startDelay, function () {
		__finishedMessage = dialogueData.message + "&&&"; // add empty space just cause it feels better
		__typeDialogue(dialogueData.typingSpeed);
	});
}

function endDialogue() {
	if (curDialogue-1 >= 0 && dialogueList[curDialogue-1].onEnd != null) dialogueList[curDialogue-1].onEnd();
}

function __typeDialogue(time:Float = 0) {
	box.alpha = dialoguetext.alpha = 1;
	(new FlxTimer()).start(Math.max(0, time + FlxG.random.float(-0.005, 0.015)), function () {
		if (__skippedText) {
			__skippedText = false; dialoguetext.text = __finishedMessage;
			while (__curTxTIndx < __finishedMessage.length) {
				__curTxTIndx++; if (dialogueList[curDialogue].event != null) dialogueList[curDialogue].event(__curTxTIndx);
			}
			__curTxTIndx--; return;
		}

		if (__finishedMessage.charAt(__curTxTIndx) != "&") {
			FlxG.sound.play(Paths.sound(__randSounds[FlxG.random.int(0, __randSounds.length-1)]), 0.4 + FlxG.random.float(-0.1, 0.1));
		}
		dialoguetext.text += __finishedMessage.charAt(__curTxTIndx);
		if (dialogueList[curDialogue].event != null) dialogueList[curDialogue].event(__curTxTIndx);
		__curTxTIndx++; if (__curTxTIndx < __finishedMessage.length) {
			if (__finishedMessage.charAt(__curTxTIndx) != "&") __typeDialogue(time);
			else {(new FlxTimer()).start(0.15, function() __typeDialogue(time));}
		} else __curTxTIndx--;
	});
}

function isCharPhrase(char:Int, string:String)
	return char == string.length-1;

function showCloud(visible:Bool) {
	FlxTween.num(visible ? 0 : 220, visible ? 220 : 0, visible ? 1.2 : 1.6, {startDelay: visible ? .5 : 0.1}, (val:Float) -> {FlxG.camera.scroll.x = Math.floor(val/20)*20;});
	(new FlxTimer()).start(visible ? .5 : .3, function (t) {
		FlxG.sound.play(Paths.sound("easteregg/Cloud_Arlene_Sound"));
		switch (visible ? t.elapsedLoops : t.loopsLeft + 1) {
			case 2: cloudBubble1.visible = grpClouds1.visible = visible;
			case 1: 
				cloudBubble2.visible = grpClouds2.visible = visible; 
				if (!visible) {menuMusic.play(); clownTheme.pause();}
			case 3 | 0: 
				if (visible) {(new FlxTimer()).start(.7, function() {menuMusic.pause(); clownTheme.play();});}
				cloud.visible = grpClouds.visible = visible; cloudPortrait.visible = true; cloudPortrait.alpha = visible ? 1 : 0;
				if (visible)
					FlxTween.num(visible ? 0 : 1, visible ? 1 : 0, visible ? 1.3 : .4, {}, (val:Float) -> {cloudPortrait.visible = true; cloudPortrait.alpha = (Math.floor((val*100)/8)*8)/100;});
				else {cloudPortrait.visible = false; cloudPortrait.alpha = 0;}
		}
	}, 3);
}

function onDestroy() Framerate.instance.visible = true;

var testingDialogue:Array<{message:String, expression:String, typingSpeed:Float, startDelay:Float, event:Int->Void}> = [
	{
		message: "LINE\nLINE\nLINE\nLINE\nLINE", 
		typingSpeed: 0.04, startDelay: 2,
		event: function (char:Int) {
			if (char == 0) {wind.stop(); menuMusic.play();}
			if (char == ("Hi guys welcome to the test dialogue...&&&&&&&&&&&&&").length-1)
				eyes.animation.play("smug", true);
		}
	},
	{
		message: "This is tottaly not too insipired off deltarune...&&&&&&&&&&&&&&&&&&&&&&&&&&&&&Thanks for asking.....",
		typingSpeed: 0.04, startDelay: 0.0,
		event: function (char:Int) {
			if (char == 0) eyes.animation.play("normal", true);
			if (char == ("This is tottaly not too insipired off deltarune...&&&&&&&&&&&&&&&&&&&&&&&&&&&&&").length-1)
				eyes.animation.play("left", true);
		}
	},
	{
		message: "Ok ill send you to a cool song now,&&&&&&&&&&&&&&& \nsee you later?\n&&&&&&&&&&&&&&&&&I guess.",
		typingSpeed: 0.04, startDelay: 0.0,
		event: function (char:Int) {
			if (char == 0) eyes.animation.play("normal", true);
			if (char == ("Ok ill send you to a cool song now,&&&&&&&&&&&&&&& ").length-1) eyes.animation.play("confused", true);
			if (char == ("Ok ill send you to a cool song now,&&&&&&&&&&&&&&& \nsee you later?\n&&&&&&&&&&&&&&&&&").length-1) eyes.animation.play("smug", true);
		}
	}
];

var firstVisitDialogue:Array<{message:String, expression:String, typingSpeed:Float, startDelay:Float, onEnd:Void->Void, event:Int->Void}> = [
	{
		message: "Hello??? && Who are you??? &&&\nHow did you get trapped down here???", 
		typingSpeed: 0.065, startDelay: 2,
		onEnd: function () {},
		event: function (char:Int)
			if (char == 0) {wind.volume = 0.5; eyes.animation.play("confused", true);}
		
	},
	{
		message: "I mean you don't look trapped... &&&You look funny... &&&&&\nAre you from that stupid clown???", 
		typingSpeed: 0.055, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (isCharPhrase(char, "I mean you don't look trapped... &&&")) eyes.animation.play("left", true);
			if (isCharPhrase(char, "I mean you don't look trapped... &&&You look funny... &&&&&\n")) eyes.animation.play("smug", true);
		}
	},
	{
		message: "I'm sorry...,&&&  I'm Sorry. &&&\nI didn't mean it that way.", 
		typingSpeed: 0.055, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int)
			if (char == 0) {eyes.animation.play("normal", true); wind.stop(); menuMusic.play();}
	},
	{
		message: "Guess being alone down here so long has made me a bit,&&&\nitterable...", 
		typingSpeed: 0.054, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "Guess being alone down here so long has made me a bit,&&&\n")) eyes.animation.play("smug", true);
		}
	},
	{
		message: "I might as well introduce myself,&&& since I'm alreadly spewing my life story...", 
		typingSpeed: 0.058, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "I might as well introduce myself,&&&")) eyes.animation.play("smug", true);

		}
	},
	{
		message: "My name is Areline,&&&\nand I'm garfields girlfriend.", 
		typingSpeed: 0.052, startDelay: 0,
		onEnd: function () {
			(new FlxTimer()).start(.9, function () eyes.animation.play("confused", true)); __canAccept = false;
			box.alpha = dialoguetext.alpha = prompt.alpha = 0;
		},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
		}
	},
	{
		message: "Huh? &&&&&&You want to know how I got down here?", 
		typingSpeed: 0.05, startDelay: 1.6,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("confused", true);}
		}
	},
	{
		message: "To be honest I've got no clue...&&&&&&\nI just went to bed one night and woke up here...", 
		typingSpeed: 0.05, startDelay: 0,
		onEnd: function () {
			box.alpha = dialoguetext.alpha = prompt.alpha = 0; eyes.animation.play("normal", true); __canAccept = false;
			(new FlxTimer()).start(.6, function () eyes.animation.play("left", true));
		},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("confused", true);}
			if (isCharPhrase(char, "To be honest I've got no clue...&&&&&&\n")) eyes.animation.play("normal", true);
		}
	},
	{
		message: "Hey,&&& since your down here already...&&&&\nCan you get a hold of nermal or garfield for me?", 
		typingSpeed: 0.05, startDelay: 0.9,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("left", true);}
			if (isCharPhrase(char, "Hey,&&& since your down here alreadly...&&&&\n")) eyes.animation.play("confused", true);
		}
	},
	{
		message: "I've been trying to reach them for the longest time...&&&&\nBut they never seem to notice for some reason.&", 
		typingSpeed: 0.05, startDelay: 0,
		onEnd: function () {
			eyes.animation.play("normal", true); __canAccept = false;
			box.alpha = dialoguetext.alpha = prompt.alpha = 0;
		},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "I've been trying to reaach them for the longest time...&&&&\n")) eyes.animation.play("left", true);
		}
	}
	{
		message: "I'm still so thankful you came down here,&&&&& I finally have someone to talk too...", 
		typingSpeed: 0.054, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "I'm still so thankful you came down here,&&&&&")) eyes.animation.play("left", true);
		}
	},
	{
		message: "Being locked up for awhile has made me a bit,...&&&& \nuh,& observant...", 
		typingSpeed: 0.055, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("left", true);}
			if (isCharPhrase(char, "Being locked up for awhile has made me a bit,...&&&& \n")) eyes.animation.play("normal", true);
		}
	},
	{
		message: "Like why are you carrying a microphone with you???&&&\nWhat do you want to sing together or something???", 
		typingSpeed: 0.048, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int)
			if (char == 0) {eyes.animation.play("confused", true);}
	},
	{
		message: "Reminds me of the other day...&&&&\nI think I heard the clown's voice somewhere...", 
		typingSpeed: 0.05, startDelay: 0,
		onEnd: function () {
			showCloud(true); __canAccept = false;
			box.alpha = dialoguetext.alpha = prompt.alpha = 0;
		},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("left", true);}
			if (isCharPhrase(char, "Reminds me of the other day...&&&&\n")) eyes.animation.play("normal", true);
		}
	},
	{
		message: "The clown was saying that a blue haired dwarf,&& and a delivery man,&& are going to stop a monsterous cat.", 
		typingSpeed: 0.055, startDelay: 2.1,
		onEnd: function () {},
		event: function (char:Int)
			if (char == 0) {eyes.animation.play("confused", true);}
	},
	{
		message: "Yeah I know right!&&&\nBiggest lies I've ever heard...", 
		typingSpeed: 0.045, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "Yeah I know right!&&&\n")) eyes.animation.play("smug", true);
		}
	},
	{
		message: "That clown is crazy...&&\nSo crazy that he hides his jokes???", 
		typingSpeed: 0.055, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "That clown is crazy...&&\n")) eyes.animation.play("confused", true);
		}
	},
	{
		message: "Why would a clown do that???&&&\nDoesn't that defeat the purpose of being funny???", 
		typingSpeed: 0.055, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("smug", true);}
			if (isCharPhrase(char, "Why would a clown do that???&&&\n")) eyes.animation.play("left", true);
		}
	},
	{
		message: "He said he hid it behind a very particular painting...&&&&\nI'm still don't know where he hid it,&& he wasn't very specific.", 
		typingSpeed: 0.045, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "He said he hid it behind a very particular painting...&&&&\n")) eyes.animation.play("confused", true);
		}
	},
	{
		message: "Find the joke for me,&&\nand I will reward you with a adventure&&.&.&.&&&&& Of finding more jokes...", 
		typingSpeed: 0.045, startDelay: 0,
		onEnd: function () {showCloud(false); box.alpha = dialoguetext.alpha = prompt.alpha = 0; __canAccept = false;},
		event: function (char:Int)
			if (char == 0) {eyes.animation.play("normal", true);}
	},
	{
		message: "Anyway, thanks for visiting me.&&& \nOne more day down here I would have went insane like that clown.", 
		typingSpeed: 0.045, startDelay: 1.5,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "Anyway, thanks for visiting me.&&& \n")) eyes.animation.play("left", true);
		}
	},
	{
		message: "Just please come back okay???&&&\nI really like jokes.", 
		typingSpeed: 0.05, startDelay: 0,
		onEnd: function () {},
		event: function (char:Int) {
			if (char == 0) {eyes.animation.play("normal", true);}
			if (isCharPhrase(char, "Just please come back okay???&&&\n")) eyes.animation.play("left", true);
		}
	},
];

var firstVisitEndCallback:Void->Void = function () {
	fadeOut = fastFirstFade = true; blackTime = 0;
	menuMusic.stop(); introSound.volume = 0.3;
	eyes.animation.play("normal", true);
	(new FlxTimer()).start(2/8, function () introSound.play(), 8);
	(new FlxTimer()).start(2.2, function () {FlxG.switchState(new TitleState());});
};