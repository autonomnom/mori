package welten.menu;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import openfl.display.Sprite;
import welten.Mutterwelt;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.system.System;
import com.haxepunk.utils.Joystick;
import com.haxepunk.Sfx;

class Menu extends Scene
{

	public function new() {

		super();
	}

	override public function begin() {

		super.begin();

		setupEnties();

		//für den spielloop
		G.mlvl = 5;

		Input.define("Hoch", [Key.W, Key.UP, Key.A, Key.LEFT]);
		Input.define("Runter", [Key.S, Key.DOWN, Key.D, Key.RIGHT]);
	}

	override public function update() {

		super.update();

		hintergrund.play("normal");
		staubsprite.play("flow");
		title.play("blinz");

		auswahl();

		if (trans == 0) {

			zwinker.play("auf");
		}
		else if (trans == 1) {

			zwinker.play("zu");
		}

		if (Input.pressed(Key.ESCAPE)) {

			endgame();
		}
	}

	private function auswahl() {

		if (beginButt.chosen || endButt.chosen) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) >= 0.8 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) >= 0.8 ) {

					if (hochrunterdelay < 0.5) {

						hochrunterdelay += HXP.elapsed;

						if (hochrunterschalte) {

							einsrunter = true;
							einshoch = false;
							hochrunterschalte = false;
						}
					}
					else {

						hochrunterdelay = 0;
						hochrunterschalte = true;
					}
				}
				else if (Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) <= -0.8 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) <= -0.8 ) {

					if (hochrunterdelay < 0.5) {

						hochrunterdelay += HXP.elapsed;

						if (hochrunterschalte) {

							einsrunter = false;
							einshoch = true;
							hochrunterschalte = false;
						}
					}
					else {

						hochrunterdelay = 0;
						hochrunterschalte = true;
					}
				}
				else {

					hochrunterdelay = 0;
					hochrunterschalte = true;
					einshoch = false;
					einsrunter = false;
				}
			}
		}

		if (beginButt.chosen) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.LB_BUTTON)) {

					endButt.chosen = true;
					beginButt.chosen = false;

					klindging();
				}
				else if ( Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON)) { // || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == -1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == -1)  {

					beginButt.chosen = false;
					endButt.chosen = true;

					klindging();
				}

				if (einshoch) {

					endButt.chosen = true;
					beginButt.chosen = false;
					einshoch = false;

					klindging();
				}
				else if (einsrunter) {

					beginButt.chosen = false;
					endButt.chosen = true;
					einsrunter = false;

					klindging();
				}
			}
			else if (Input.pressed("Runter")) {

				beginButt.chosen = false;
				endButt.chosen = true;

				klindging();
			}
			else if (Input.pressed("Hoch")) {

				endButt.chosen = true;
				beginButt.chosen = false;

				klindging();
			}
		}
		else if (endButt.chosen) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.LB_BUTTON)) {

					beginButt.chosen = true;
					endButt.chosen = false;

					klindging();
				}
				else if ( Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON)) { // || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == -1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == -1)  {

					endButt.chosen = false;
					beginButt.chosen = true;

					klindging();
				}

				if (einshoch) {

					beginButt.chosen = true;
					endButt.chosen = false;
					einshoch = false;

					klindging();
				}
				else if (einsrunter) {

					endButt.chosen = false;
					beginButt.chosen = true;
					einsrunter = false;

					klindging();
				}
			}
			else if (Input.pressed("Runter")) {

				endButt.chosen = false;
				beginButt.chosen = true;

				klindging();
			}
			else if (Input.pressed("Hoch")) {

				beginButt.chosen = true;
				endButt.chosen = false;

				klindging();
			}
		}
	}

	private function klindging() {

		var hoho:Float = Math.random();

		if (hoho < 0.33) 											{ but1.play(); }
		else if (hoho >= 0.33 && hoho < 0.66) { but2.play(); }
		else if (hoho >= 0.66) 								{ but3.play(); }
	}

	private function setupEnties() {

		//hintergrund
		hintern = new Entity(0, 0, hintergrund);
		hintern.layer = 100;
		hintergrund.scale = 1.666667;
		hintergrund.add("normal", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78], 5, true);
		add(hintern);

		//staubkorn vorne
		staub = new Entity(294, 244, staubsprite);
		staub.layer = -100;
		staubsprite.scale = 1.666667;
		staubsprite.add("flow", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78], 5, true);
		staubsprite.alpha = 0.3;
		add(staub);

		//titel
		titi = new Entity((HXP.screen.width * 0.5) - (title.width * 0.5 * 1.666666667 + 12), HXP.screen.height * 0.5 - 150, title);
		title.scale = 1.666667;
		title.add("blinz", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3], 7);
		add(titi);

		//buttons
		//begin
		beginButt = new Button(transition, null, HXP.screen.width * 0.5, HXP.screen.height * 0.6);
		beginButt.setSpritemap("graphics/menu/begin.png", 71, 28);
		add(beginButt);
		beginButt.chosen = true;

		//end
		endButt = new Button(endgame, null, HXP.screen.width * 0.5, HXP.screen.height * 0.7);
		endButt.setSpritemap("graphics/menu/end2.png", 60, 28);
		add(endButt);

		//transition
		auge = new Entity(0, 0, zwinker);
		zwinker.add("zu", [0,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 13, false);
		zwinker.add("auf", [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 13, false);
		zwinker.callbackFunc = startmenu;
		auge.layer = -200;
		add(auge);
	}

	/**
	 * Callback for the eye when begin was hit. Transition into the Mutterwelt.
	 */
	private function transition() {

		trans = 1;
		add(auge);
		zwinker.callbackFunc = begingame;
	}

	private function begingame() {

		HXP.scene = new Mutterwelt();
	}

	/**
	 * Callback for the eye animation, when the game started.
	 */
	private function startmenu() {

		trans = 2;
		remove(auge);
	}

	private function endgame() {

		#if (flash || html5)
		System.exit(1);
		#else
		Sys.exit(1);
		#end
	}

	//kiste & logo
	private var staub:Entity;
	private var staubsprite:Spritemap = new Spritemap("graphics/menu/staubvorne.png", 28, 27);
	private var hintern:Entity;
	private var hintergrund:Spritemap = new Spritemap("graphics/menu/hintern.png", 384, 240);
	private var titi:Entity;
	private var title:Spritemap = new Spritemap("graphics/menu/headersprite.png", 138, 69);

	//transition
	private var auge:Entity;
	private var zwinker:Spritemap = new Spritemap("graphics/menu/zwink.png", 640, 400);
	private var trans:Int = 0;

	//buttons
	private var beginButt:Button;
	private var endButt:Button;

	private var einsrunter:Bool = false;
	private var einshoch:Bool = false;
	private var hochrunterdelay:Float = 0;
	private var hochrunterschalte:Bool = true;

	//musik
	private var but1:Sfx = new Sfx("audio/stimmen/but1.ogg");
	private var but2:Sfx = new Sfx("audio/stimmen/but2.ogg");
	private var but3:Sfx = new Sfx("audio/stimmen/but3.ogg");
}
