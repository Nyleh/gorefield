var strumLineZooms:Map<Int, Float> = [];

function create() {
    if (stage == null || stage.stageXML == null) return;

    var zoomNames:Array<String> = ["opponentZoom", "playerZoom", "gfZoom"];
    for (zoom in zoomNames)
        if (stage.stageXML.exists(zoom)) strumLineZooms.set(zoomNames.indexOf(zoom), Std.parseFloat(stage.stageXML.get(zoom)));

    if (strumLineZooms.exists(curCameraTarget)) defaultCamZoom = strumLineZooms.get(curCameraTarget);
    camZooming = true;
}

function onEvent(codenameEvent) {
    var event = codenameEvent.event;
    switch(event.name) {
        case "Camera Movement": if (strumLineZooms.exists(event.params[0])) defaultCamZoom = strumLineZooms.get(event.params[0]);
    }
}