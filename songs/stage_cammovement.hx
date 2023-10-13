import flixel.math.FlxBasePoint;

static var camMoveOffset:Float = 15;
static var camFollowChars:Bool = true;

var pp = new FlxBasePoint();

function create() {camFollowChars = true; camMoveOffset = 15;}

function postCreate() {
    var cameraStart = strumLines.members[curCameraTarget].characters[0].getCameraPosition();
    cameraStart.y -= 100; FlxG.camera.focusOn(cameraStart);
}

function onCameraMove(camMoveEvent) {
    if (camFollowChars) {
        if (camMoveEvent.strumLine != null && camMoveEvent.strumLine?.characters[0] != null) {
            switch (camMoveEvent.strumLine.characters[0].animation.name) {
                case "singLEFT": pp.set(-camMoveOffset, 0);
                case "singDOWN": pp.set(0, camMoveOffset);
                case "singUP": pp.set(0, -camMoveOffset);
                case "singRIGHT": pp.set(camMoveOffset, 0);
                default: pp.set(0,0);
            };
            camMoveEvent.position.x += pp.x;
			camMoveEvent.position.y += pp.y;
        }
    } else camMoveEvent.cancel();
}

function destroy() {camFollowChars = true; camMoveOffset = 15;}