//
import funkin.game.ComboRating;

function create() 
{
    comboGroup.x += 300;
    comboGroup.y += 300;

    gameOverSong = "gameOvers/cryfield/Gorefield_Gameover_Cryfield";
	retrySFX = "gameOvers/cryfield/Continue";

    if (PlayState.instance.SONG.meta.name == 'Nocturnal Meow')
    {
        stage.stageSprites["BG_C"].color = 0xFF7C7C7C;

        for (char in [boyfriend, dad]) 
        {
            var newShader = new CustomShader("wrath");
            newShader.uDirection = 45;
            newShader.uOverlayOpacity = 0.5;
            newShader.uDistance = 30.;
            newShader.uChoke = 20.;
            newShader.uPower = char == dad ? .2 : .7;
        
            newShader.uShadeColor = [219 / 255, 106 / 255, 104 / 255];
            newShader.uOverlayColor = [41 / 255, 8 / 255, 33 / 255];
        
            var uv = char.frame.uv;
            newShader.applyRect = [uv.x, uv.y, uv.width, uv.height];

            //char.danceOnBeat = !(char.forceIsOnScreen = true);
            if (FlxG.save.data.wrath) char.shader = newShader;
        }
    }

    comboRatings = [
		new ComboRating(0, "F", 0xFF941616),
		new ComboRating(0.5, "E", 0xFFCF1414),
		new ComboRating(0.7, "D", 0xFFFFAA44),
		new ComboRating(0.8, "C", 0xFFFFA02D),
		new ComboRating(0.85, "B", 0xFFFE8503),
		new ComboRating(0.9, "A", 0xFF933AB6),
		new ComboRating(0.95, "S", 0xFFB11EEA),
		new ComboRating(1, "S++", 0xFFC63BFD),
	];
}

function draw(e) {
	for (char in [boyfriend, dad]) 
    {
        if (char.shader == null) continue;

        var uv = char.frame.uv;
        char.shader.applyRect = [uv.x, uv.y, uv.width, uv.height];
    }
}

function postCreate()
{
    if (PlayState.instance.SONG.meta.name == 'Nocturnal Meow')
    {
        dad.setPosition(-400,-100);
        boyfriend.setPosition(1900,700);
        defaultCamZoom = 0.3;
        dad.cameraOffset.x = 400;
        strumLineDadZoom = 0.3;
        strumLineBfZoom = 0.6;
        snapCam();
    }
}