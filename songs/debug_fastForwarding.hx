var curSpeed:Float = 1;

function update() {
    if (startingSong || !canPause || paused || health <= 0) return;
    
    if (FlxG.keys.pressed.TWO) curSpeed -= 0.01;
    if (FlxG.keys.justPressed.THREE) curSpeed = 1;
    if (FlxG.keys.pressed.FOUR) curSpeed += 0.01;

    updateSpeed(curSpeed);
}

function updateSpeed(speed:Float)
    FlxG.timeScale = inst.pitch = vocals.pitch = speed;

function onGamePause() {updateSpeed(1);}
function onSongEnd() {updateSpeed(1);}
function destroy() {FlxG.timeScale = 1;FlxG.sound.muted = false;}
