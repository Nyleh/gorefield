import funkin.game.ComboRating;

function create() {
    __script__.didLoad = __script__.active = false;

    comboRatings = [
		new ComboRating(0, "F", 0xFF941616),
		new ComboRating(0.5, "E", 0xFFCF1414),
		new ComboRating(0.7, "D", 0xFFFFAA44),
		new ComboRating(0.8, "C", 0xFFFFA02D),
		new ComboRating(0.85, "B", 0xFFFE8503),
		new ComboRating(0.9, "A", 0xFF933AB6),
		new ComboRating(0.95, "S", 0xFFB11EEA),
		new ComboRating(1, "S++", 0xFFC63BFD),
	];
}
// to be used some day when we have to add a time bar cause everyone got mad and we finally add it 4 months later but no one cares cause the mod would be dead by then yeah
// Wow hi lunar! -lunar
// but i wrote the orginal message???
// the orginal                   STAR WALKER