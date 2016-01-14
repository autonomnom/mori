package welten.menu;

class NewClass
{

	override public function update() {
		
		super.update();
		
		//FULLSCREEN
		if (Input.pressed(Key.F1)) {
			
			HXP.fullscreen = !HXP.fullscreen;
		}
		
		//PAUSE 
		if (Input.pressed(Key.BACKSPACE) && Std.string(HXP.scene) != "Menu") {
			
			HXP.scene.active = !HXP.scene.active;
		}	
		
		//& ENTER MUTTERWELT 
	/*	if (Input.pressed(Key.ENTER)) {
			
			HXP.scene = new Mutterwelt();
		}	*/
		
		//QUIT
		if (Input.pressed(Key.ESCAPE)) {
			quit();
		}
		
		//GLOBAL MUTE
		if (Input.pressed(Key.F4)) {
			
			// HXP.volume = 0;		
			/* not working */
		}
	}
	
}