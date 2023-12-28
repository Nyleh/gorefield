function create() 
{
    gf.scrollFactor.set(1, 1);
    gf.visible = false;
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 864:
            gf.visible = true;
            
            dad.x = -1200;
        case 870:
            FlxTween.tween(dad, { x: -500}, 1);
    }
}