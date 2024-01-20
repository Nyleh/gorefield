var scaryTime:Bool = false;

var hudMembers:Array<FlxSprite>;

function postCreate()
{
    hudMembers = [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt];
    hudMembers = hudMembers.concat([for (note in cpuStrums.members) note]);
    for (member in hudMembers)
        member.visible = false;

    boyfriend.cameraOffset.x += 20;
    boyfriend.cameraOffset.y += 80;
}

function stepHit(step:Int) 
{
    camGame.shake(scaryTime ? 0.006 : 0,0.1);
    camHUD.shake(scaryTime ? 0.005 : 0,0.1);
    switch (step)
    {
        case 256:
            strumLineBfZoom = 1.5;
            boyfriend.cameraOffset.x -= 20;
            boyfriend.cameraOffset.y -= 80;
            showPopUp(true, PlayState.instance.misses);

            for (member in hudMembers)
            {
                member.visible = true;
                member.alpha = 0;
                FlxTween.tween(member, {alpha: 1}, 0.4);
            }
        case 1232:
            rain.visible = false;
            rain2.visible = scaryTime = true;

            FlxG.camera.flash(0x808B3537, 1);

            var lightning_bolt:FlxSprite = stage.stageSprites["lightning_bolt"];
            lightning_bolt.visible = true;
            lightning_bolt.animation.play("lightning_bolt");
            lightning_bolt.animation.finishCallback = 
                function(_)
                {
                    lightning_bolt.animation.stop();
                    lightning_bolt.visible = lightning_bolt.active = false;
                }
    }
}