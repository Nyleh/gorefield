function postCreate()
{
    comboGroup.x -= 500;
    comboGroup.y += 300;

    gf.visible = false;
    dad.visible = false;

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
        spr.alpha = 0.2;

    if (!FlxG.save.data.vhs)
        return;

    var vhsShader:CustomShader = new CustomShader("vhs");
    vhsShader.time = 0; 
    FlxG.camera.addShader(vhsShader);
}