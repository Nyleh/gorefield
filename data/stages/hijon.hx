//
import flixel.addons.display.FlxBackdrop;

var clouds:FlxBackdrop;
var oldClouds:FlxSprite;

function create() {
    comboGroup.x += 300;
    comboGroup.y += 300;

    oldClouds = stage.stageSprites["cloudsFinal"];
    oldClouds.alpha = 0;

    clouds = new FlxBackdrop(Paths.image("stages/stage/clouds"), 0x01, 0, 0);
    clouds.velocity.set(-150);

    insert(members.indexOf(oldClouds), clouds);
}

function update(elapsed:Float) clouds.visible = oldClouds.visible;