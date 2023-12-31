function postCreate()
{
    comboGroup.x -= 500;
    comboGroup.y += 300;

    gf.visible = false;
    dad.visible = false;

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
        spr.alpha = 0.2;
}