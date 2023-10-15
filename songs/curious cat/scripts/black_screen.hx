var black:FlxSprite; // It's not completely black, but weell... -EstoyAburridow

function create()
{
    if (PlayState.SONG.meta.name.toLowerCase() == "curious cat")
    {
        black = new FlxSprite();
        black.makeSolid(FlxG.width, FlxG.height, 0xFF110521);
        black.cameras = [camHUD];
        insert(0, black);
    }
    else
        __script__.didLoad = __script__.active = false;
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 140:
            black.active = black.visible = false;
            __script__.didLoad = __script__.active = false;
    }
}
