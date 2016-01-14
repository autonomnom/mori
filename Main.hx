import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import openfl.system.System;
import welten.menu.Menu;
import openfl.ui.Mouse;
import welten.Mutterwelt;
import openfl.Assets;

class Main extends Engine
{
	override public function init()	{

		super.init();

		HXP.console.enable();
		HXP.console.visible = true;
		HXP.console.toggleKey = Key.BACKSPACE;
		HXP.scene = new Menu();

	//	Mouse.hide();

		HXP.fullscreen = false;
	}

	public static function main() {

		new Main();
	}

	override public function update() {

		super.update();

		//FULLSCREEN
		if (Input.pressed(Key.F1)) {

			HXP.fullscreen = !HXP.fullscreen;
		}

		//GLOBAL MUTE
		if (Input.pressed(Key.F4)) {

			// HXP.volume = 0;
			/* not working */
		}
	}

	public function quit():Void {

		#if (flash || html5)
		System.exit(1);
		#else
		Sys.exit(1);
		#end
	}
}
