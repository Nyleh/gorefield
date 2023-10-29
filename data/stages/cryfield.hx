function create() {
    comboGroup.x += 300;
    comboGroup.y += 300;

    gameOverSong = "gameOvers/cryfield/Gorefield_Gameover_Cryfield";
	retrySFX = "gameOvers/cryfield/Continue";
}

function postCreate(){
    if(PlayState.instance.SONG.meta.name == 'Nocturnal Meow'){
        dad.setPosition(-400,-100);
        boyfriend.setPosition(1900,700);
        defaultCamZoom = 0.3;
        dad.cameraOffset.x = 400;
        strumLineDadZoom = 0.3;
        strumLineBfZoom = 0.6;
        snapCam();
    }
}