public var controlHealthAlpha:Bool = true;
public var curHealthAlpha:Float = 1;

function create() {
    controlHealthAlpha = boyfriend.forceIsOnScreen = true; boyfriend.zoomFactor = .8;
    FlxG.camera.bgColor = 0xFFADABAB;
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