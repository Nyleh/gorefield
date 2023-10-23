static function tweenHUD(a:Float, time:Float) {
    for (strumLine in strumLines) tweenStrum(strumLine, a, time);

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
        FlxTween.tween(spr,{alpha: a},time);
}

static function tweenStrum(strumLine:StrumLine, a:Float, time:Float) {
    var _a = a; var _t = time; // weird bug idk
    for (strum in strumLine.members)
        FlxTween.tween(strum, {alpha: a}, time);
    strumLine.notes.forEach(function (n) {
        FlxTween.tween(n, {alpha: _a}, _t);
    });
}