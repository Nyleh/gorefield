static var camMoveOffset:Float = 15;
static var camFollowChars:Bool = true;

function create() {camFollowChars = true; camMoveOffset = 15;}

function onCameraMove(camMoveEvent) {
    if (camFollowChars) {
        if (camMoveEvent.strumLine != null && camMoveEvent.strumLine?.characters[0] != null) {
            var poseMovement:FlxPoint = switch (camMoveEvent.strumLine.characters[0].animation.name) {
                case "singLEFT": FlxPoint.get(-camMoveOffset, 0);
                case "singDOWN": FlxPoint.get(0, camMoveOffset);
                case "singUP": FlxPoint.get(0, -camMoveOffset);
                case "singRIGHT": FlxPoint.get(camMoveOffset, 0);
                default: FlxPoint.get(0,0);
            };
            camMoveEvent.position.x += poseMovement.x; camMoveEvent.position.y += poseMovement.y;
            poseMovement.put();
        }
    } else camMoveEvent.cancel();
}