var black:FlxSprite; // It's not completely black, but weell... -EstoyAburridow

function create()
{
    black = new FlxSprite();
    black.makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    black.cameras = [camHUD];
    insert(0, black);
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 1:
            FlxTween.tween(black, {alpha: 0},4);

    }
}
