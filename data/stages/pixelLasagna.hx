function create() 
{
	comboGroup.x = 300;
    comboGroup.y += 300;

	importScript("data/scripts/pixel-gorefield");
	__script__.didLoad = __script__.active = false;
}