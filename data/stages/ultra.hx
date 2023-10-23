public var controlHealthAlpha:Bool = true;
public var curHealthAlpha:Float = 1;

function create() {
    controlHealthAlpha = true; boyfriend.zoomFactor = .85;
}

function update(elapsed:Float) {
    if (controlHealthAlpha) {
        curHealthAlpha = lerp(curHealthAlpha, curCameraTarget == 1 ? 0.25 : 1, 1/20);
        for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
            spr.alpha = curHealthAlpha;
    }
}