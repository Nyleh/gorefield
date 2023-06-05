//
import StringTools;
import Xml;

var pizza:Character;

var finishedLoading:Bool = false;
var pressedEnter:Bool = false;

function create() {
    if (FlxG.sound.music != null) FlxG.sound.music.stop();
    FlxG.camera.alpha = 0;

    var path:String = "assets/songs/" + PlayState.SONG.meta.name.toLowerCase() + "/loadingscreen.json";
    var loadingData:Dynamic = {
        loadingbg: "loadingbg1",
        loadingimage: "rightloadingimage1",
        loadinganim: "BF 1",
        loadingpos: [561.46, -42.08]
    };

    if (Assets.exists(path)) loadingData = Json.parse(Assets.getText(path));
    else trace("LOADING SCREEN NOT FOUND!!!11 | PATH: " + path);
    
    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingscreens/' +loadingData.loadingbg));
    if (loadingData.loadingbg != 'loadingbg1' && loadingData.loadingbg != 'loadingbg2' && loadingData.loadingbg != 'loadingbg3')
        bg.scale.set(0.68, 0.68);
    bg.screenCenter();
    bg.antialiasing = true;
    add(bg);

    var portrait:FlxSprite = new FlxSprite();
    portrait.frames = Paths.getSparrowAtlas('loadingscreens/' + loadingData.loadingimage);
    portrait.animation.addByPrefix('idle', loadingData.loadinganim, 24, true);
    portrait.animation.play('idle');
    portrait.scale.set(0.68, 0.68);
    portrait.updateHitbox();
    portrait.setPosition(loadingData.loadingpos[0], loadingData.loadingpos[1]);
    portrait.antialiasing = true;
    add(portrait);

    pizza = new Character(0,0, "loading");
    pizza.updateHitbox();
    pizza.x = 0 - (pizza.width / 3.5) + 1;
    pizza.y = FlxG.height - (pizza.height + (pizza.height / 2)) - 2;
    add(pizza);
    pizza.playAnim('idle');

    FlxG.sound.play(Paths.sound("loadingsound"));

    new FlxTimer().start(1.5, (tmr:FlxTimer) -> {
		FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5, {onComplete: (tween:FlxTween) -> {loadAssets();}});
	});
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ESCAPE) 
        FlxG.switchState(new FreeplayState());
    if (FlxG.keys.justPressed.ENTER && finishedLoading && !pressedEnter) {goToSong(); pressedEnter = true;}
}

function gatherAssetsToLoad():Array<String> {
    var graphicsToLoad:Array<String> = [];

    // Stage Sprites / HealthBar / Notes
    var countDownInStage:Bool = false; // to preload normal countdown

    if (PlayState.SONG.stage != null && StringTools.trim(PlayState.SONG.stage) != "") {
        var stagePath = 'assets/data/stages/' + PlayState.SONG.stage + '.xml';

        if (Assets.exists(stagePath)) {
            var stageXML:Xml = Xml.parse(Assets.getText(stagePath)).firstElement();

            var spriteFolder:String = stageXML.exists("folder") ? stageXML.get("folder") : "";
            if (spriteFolder.charAt(spriteFolder.length-1) != "/") spriteFolder = spriteFolder + "/";

            if (stageXML.exists("noteSkin")) graphicsToLoad.push("game/notes/" + stageXML.get("noteSkin"));
            else graphicsToLoad.push("game/notes/default");

            if (stageXML.exists("splashSkin")) graphicsToLoad.push("game/splashes/" + stageXML.get("splashSkin"));
            else graphicsToLoad.push("game/splashes/default");

            if (stageXML.exists("healthBarColor")) graphicsToLoad.push("game/healthbar/healthbar_" + stageXML.get("healthBarColor"));
            else graphicsToLoad.push("game/healthbar/healthbar_orange");

            for (healthBarSpr in ["filler_left", "filler_right"]) graphicsToLoad.push("game/healthbar/" + healthBarSpr);
            
            for (node in stageXML.elements()) {
                switch (node.nodeName) {
                    case "sprite": if (node.exists("sprite")) graphicsToLoad.push(spriteFolder + node.get("sprite"));
                    case "countdown":
                        countDownInStage = true;
                        for (countDownNode in node.elements()) if (countDownNode.exists("sprite")) graphicsToLoad.push(countDownNode.get("sprite"));
                }
            }
        }
    }

    if (!countDownInStage) for (sprite in ['game/ready', "game/set", "game/go"]) graphicsToLoad.push(sprite);

    // Characters 
    for (strumLine in PlayState.SONG.strumLines) {
        for (char in strumLine.characters) {
            var xmlPath = 'assets/data/characters/' + char + '.xml';
            if (!Assets.exists(xmlPath)) xmlPath = 'assets/data/characters/bf.xml';

            var charXML = Xml.parse(Assets.getText(xmlPath)).firstElement();

            if (charXML.exists("sprite")) graphicsToLoad.push("characters/" + charXML.get("sprite"));
            else graphicsToLoad.push("characters/" + char);

            if (charXML.exists("icon")) graphicsToLoad.push("icons/" + charXML.get("icon"));
        }  
    }

    // Note Types
    for (noteType in PlayState.SONG.noteTypes)
        graphicsToLoad.push("game/notes/" + noteType);

    var fliteredGraphics:Array<String> = []; // Removing Duplicates

    for (graphic in graphicsToLoad)
        if (fliteredGraphics.indexOf(graphic) == -1) fliteredGraphics.push(graphic);

    return fliteredGraphics;
}

function loadAssets() { // GET BAMBOOZLED LLLLL YOU THOUGHT IT WAS ACUTTALY LOADING
    var timeToLoadalldat = 0;

    for (sprite in gatherAssetsToLoad()) {
        timeToLoadalldat += FlxG.random.float(0.1, 0.225);
    }

    new FlxTimer().start(timeToLoadalldat, (tmr:FlxTimer) -> {
        pizza.playAnim('enter');
		pizza.animation.finishCallback = (name:String) -> {if (name == 'enter') {pizza.playAnim('enterloop'); finishedLoading = true;}};
	});
}

function goToSong() {
    FlxTween.tween(FlxG.camera, {alpha: 0}, 0.75, {onComplete: (tween:FlxTween) -> {FlxG.switchState(new PlayState());}});
}