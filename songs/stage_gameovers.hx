function onGameOver(){
    for (camera in FlxG.cameras.list) 
        {camera.setFilters([]); camera.stopFX();}  
    curSpeed = 1; FlxG.timeScale = 1;
    FlxTween.cancelTweensOf(FlxG.camera);
    FlxG.camera.setScrollBoundsRect(Math.NEGATIVE_INFINITY,Math.NEGATIVE_INFINITY,Math.POSITIVE_INFINITY,Math.POSITIVE_INFINITY, false);
} 