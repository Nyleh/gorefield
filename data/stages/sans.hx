function create() 
{
	gameOverSong = "gameOvers/sansfield/gameover_sansfield_loop";
	retrySFX = "gameOvers/sansfield/gameover_sansfield_end";

	comboGroup.x -= 80;
	comboGroup.y -= 25;

	__script__.didLoad = __script__.active = false;
}