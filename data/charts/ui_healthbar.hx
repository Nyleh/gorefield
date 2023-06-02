import funkin.game.HealthIcon;

var iconOffsets:Array<FlxPoint> = [];

function postCreate() {
    //  Icon Offsets / Icon Custom Widths
    for (icon in [iconP1, iconP2]) {
        if (icon == null) continue;

        iconOffsets.push(switch (icon) {
            case iconP1: 
                FlxPoint.get(
                    (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("iconoffsetx")) ? Std.parseFloat(boyfriend.xml.get("iconoffsetx")) : 0,
                    (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("iconoffsety")) ? Std.parseFloat(boyfriend.xml.get("iconoffsety")) : 0
                );
            case iconP2:
                FlxPoint.get(
                    (dad != null && dad.xml != null && dad.xml.exists("iconoffsetx")) ? Std.parseFloat(dad.xml.get("iconoffsetx")) : 0,
                    (dad != null && dad.xml != null && dad.xml.exists("iconoffsety")) ? Std.parseFloat(dad.xml.get("iconoffsety")) : 0
                );
        });

        icon.loadGraphic(icon.graphic, true, icon.graphic.width/2, icon.graphic.height);
        icon.flipX = icon == iconP1;

        icon.updateHitbox();
        icon.y = healthBar.y - (icon.height / 2);
    }
}

function postUpdate(elapsed:Float) {
    for (icon in [iconP1, iconP2]) {
        icon.x += iconOffsets[icon == iconP1 ? 0 : 1].x; icon.y = healthBar.y - (icon.height / 2) + iconOffsets[icon == iconP1 ? 0 : 1].y;
    }
}

function destroy() {
    for (point in iconOffsets) point.put();
}