public var controlHealthAlpha:Bool = true;
public var curHealthAlpha:Float = 1;

function create() {
	comboGroup.x = 800;
    comboGroup.y = 620;

    controlHealthAlpha = boyfriend.forceIsOnScreen = true;
    FlxG.camera.bgColor = 0xFFF6F6F6;
}

function onMeasureHit() {
    camMoveOffset = curCameraTarget == 1 ? 30 : 150;
}

function update(elapsed:Float) {
    if (controlHealthAlpha) {
        curHealthAlpha = lerp(curHealthAlpha, curCameraTarget == 1 ? 0.25 : 1, 1/20);
        for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
            spr.alpha = curHealthAlpha;
    }
}