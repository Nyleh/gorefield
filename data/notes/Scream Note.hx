var screamer:FlxSprite = null;
var screamerCam:FlxCamera = null;

var distortionShader:CustomShader = null;
var glitchShader:CustomShader = null;

function postCreate() {
    FlxG.sound.play(Paths.sound('mechanics/scream'), 0); // Preload sound

    screamerCam = new FlxCamera();
    screamerCam.bgColor = FlxColor.TRANSPERENT;
    FlxG.cameras.add(screamerCam, false);
    screamerCam.zoom += .17;

    screamer = new FlxSprite(0, 0).loadGraphic(Paths.image("mechanics/screamer-jumpscare")); //screamer-jumpscare
    screamer.cameras = [screamerCam];
    screamer.scrollFactor.set(0, 0);

    screamer.scale.set(FlxG.width/screamer.width, FlxG.height/screamer.height);
    screamer.updateHitbox();
    
    screamer.visible = screamer.active = false; screamer.alpha = 0;
    screamer.drawComplex(screamerCam); // Push to GPU
    
    add(screamer);

    distortionShader = new CustomShader("chromaticWarp");
    distortionShader.distortion = 1;
    screamerCam.addShader(distortionShader);

    glitchShader = new CustomShader("glitch");
    glitchShader.glitchAmount = glitchAmount = 1;
    screamer.shader = glitchShader;

    //scream();
}

var glitchAmount = 1;
var shakeAmount = 1;

var fadeTimer:Float = 0;
var fullTimer:Float = 0;
function update(elapsed) {
    glitchShader.time = fullTimer -= elapsed;
    distortionShader.distortion = FlxG.random.float(0.5, 6);
    
    glitchShader.glitchAmount = glitchAmount = lerp(glitchAmount, 2, 1/5);

    fadeTimer -= elapsed;
    if (fadeTimer <= 0)
        screamer.alpha = lerp(screamer.alpha, 0, 1/10);
    shakeAmount = lerp(shakeAmount, 1, 1/20);

    screamer.x = FlxG.random.float(0.5, 20) * shakeAmount; 
    screamer.y = FlxG.random.float(0.5, 20) * shakeAmount;

    screamerCam.visible = (screamer.alpha > 0.01);
    screamer.visible = screamer.active = screamerCam.visible;
}

function scream() {
    screamer.visible = screamer.active = true; screamer.alpha = 1;
    glitchAmount = 20; fadeTimer = 1.1; shakeAmount = 3;

    FlxG.sound.play(Paths.sound('mechanics/scream'), 1);
}

function onPlayerMiss(event)
    if (event.noteType == "Scream Note") event.cancel(true);

function onPlayerHit(event)
    if (event.noteType == "Scream Note") {
        event.countAsCombo = event.showRating = event.showSplash = false;
        event.strumGlowCancelled = true;

        scream();
    }