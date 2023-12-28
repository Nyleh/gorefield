import openfl.Lib;
import funkin.backend.utils.WindowUtils;

var fakeCamFollow:FlxSprite;
var replaceCamera:Bool = false;
var characterDummy:Character;
var fakeCamZoom:Float;
function create(){
    var position:Array<{x:Float,y:Float}> = [{x: 0, y: 0}];
    trace(characterName);
    //x+ = left x- = right || y- = down  y+ = up

    fakeCamZoom = 1;
    switch(characterName){
        case 'bf-apoc':
            fakeCamZoom = 0.6;
            position[0].x = 160 + PlayState.instance.boyfriend.x;
            position[0].y = 600 + PlayState.instance.boyfriend.y;  
        case 'bf-ultra':
            position[0].x = 200 + PlayState.instance.boyfriend.x;
            position[0].y = 500 + PlayState.instance.boyfriend.y;  
        case 'nermal-dead-cry':
            fakeCamZoom = 0.5;
            position[0].x = 550 + PlayState.instance.boyfriend.x;
            position[0].y = 240 + PlayState.instance.boyfriend.y;  
        case 'bf-sky':
            position[0].x = 70 + PlayState.instance.boyfriend.x;
            position[0].y = 500 + PlayState.instance.boyfriend.y;  
        case 'bf-black' | 'bf-black2':
            var coolX = characterName == 'bf-black' ? 170 + PlayState.instance.boyfriend.x : 100 + PlayState.instance.boyfriend.x;
            var coolY = characterName == 'bf-black' ? 500 + PlayState.instance.boyfriend.y : 400 + PlayState.instance.boyfriend.y;
            position[0].x = coolX;
            position[0].y = coolY; 
            fakeCamZoom = 0.7;
            snapCam();
        case 'bf-dead-bw':
            position[0].x = 330 + PlayState.instance.boyfriend.x;
            position[0].y = 600 + PlayState.instance.boyfriend.y;     
        case 'jon-player':
            position[0].x = 210 + PlayState.instance.boyfriend.x;
            position[0].y = 550 + PlayState.instance.boyfriend.y;
        case 'bf-pixel-dead-lasagna':
            fakeCamZoom = 0.85;
            position[0].x = 820 + PlayState.instance.boyfriend.x;
            position[0].y = 425 + PlayState.instance.boyfriend.y;
            FlxG.camera.bgColor = 0xFF527f3a;
        default:
            characterDummy = new Character(0,0, characterName, true);
            var camPos = characterDummy.getCameraPosition();
            position[0].x = camPos.x + PlayState.instance.boyfriend.x;
            position[0].y = camPos.y + PlayState.instance.boyfriend.y;
    }

    fakeCamFollow = new FlxSprite(position[0].x, position[0].y).makeSolid(1, 1, 0xFFFFFFFF);
    fakeCamFollow.visible = false;
    add(fakeCamFollow);
    replaceCamera = true;

    WindowUtils.endfix = " - " + PlayState.instance.SONG.meta.name + " - GAME OVER";
}

function update(elapsed:Float){
    FlxG.camera.zoom = lerp(FlxG.camera.zoom, fakeCamZoom, 0.05);
    if(replaceCamera){
        FlxG.camera.target = fakeCamFollow;
        replaceCamera = false;
    }

    if (controls.BACK)
		{
            isEnding = true; //fix that one music bug that codename somehow neglected
		}
}