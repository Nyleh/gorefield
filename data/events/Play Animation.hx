function onEvent(eventEvent) {
    switch (eventEvent.event.name) {
        case "Play Animation":
            for (char in strumLines.members[eventEvent.event.params[0]].characters) {
                char.playAnim(eventEvent.event.params[1], eventEvent.event.params[2], null);
            }
    }
}