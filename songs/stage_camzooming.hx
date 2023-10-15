static var strumLineDadZoom:Float = 0;
static var strumLineBfZoom:Float = 0;
static var strumLineGfZoom:Float = 0;

static var lerpCam:Bool = true;

function create() {
    camZooming = false;
    if (stage == null || stage.stageXML == null) return;

    strumLineDadZoom = stage.stageXML.exists("opponentZoom") ? Std.parseFloat(stage.stageXML.get("opponentZoom")) : -1;
    strumLineBfZoom = stage.stageXML.exists("playerZoom") ? Std.parseFloat(stage.stageXML.get("playerZoom")) : -1;
    strumLineGfZoom = stage.stageXML.exists("gfZoom") ? Std.parseFloat(stage.stageXML.get("gfZoom")) : -1;
}

function update(elapsed:Bool) {
    if (lerpCam) {
        var stageZoom:Float = switch (curCameraTarget) {
            case 0: strumLineDadZoom;
            case 1: strumLineBfZoom;
            case 2: strumLineGfZoom;
            default: defaultCamZoom;
        };

        FlxG.camera.zoom = lerp(FlxG.camera.zoom, stageZoom == -1 ? defaultCamZoom : stageZoom, 0.05);
        camHUD.zoom = lerp(camHUD.zoom, defaultHudZoom, 0.05);
    }
}

function beatHit(beat:Int) {
    // if (camZoomingInterval < 1) camZoomingInterval = 1;
    if (Options.camZoomOnBeat && lerpCam && FlxG.camera.zoom < maxCamZoom && beat % camZoomingInterval == 0)
    {
        FlxG.camera.zoom += 0.015 * camZoomingStrength;
        camHUD.zoom += 0.03 * camZoomingStrength;
    }
}

function onNoteHit(_) _.enableCamZooming = false;