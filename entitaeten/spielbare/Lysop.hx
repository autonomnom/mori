package entitaeten.spielbare;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import entitaeten.schatten.Schatten;
import welten.Mutterwelt;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import entitaeten.schatten.Uggel;
import openfl.display.Sprite;
import openfl.geom.Point;

class Lysop extends Morikkel
{

	public function new(x:Float, y:Float) {
		
		super(x, y);
	}
/**	
	override public function added() {
		
		super.added();
		
		graphic = gesicht;
		addGraphic(gesichtschatten);
		
		SP = SPmax;
		angreifen = 0;
		schwebt = false;
		
		name = "lysop";
		setHitbox(36, 36, 18, 18);
		
		gesicht.originX = gesicht.width * .5;
		gesicht.originY = gesicht.height * .8;
		gesichtschatten.originX = gesichtschatten.width * .5;
		gesichtschatten.originY = gesichtschatten.height * .8;
		
		spritesheet();
		
		genuggehoert = true;
	}
	
	override public function update() {
		
		super.update();
		
		animationen();
		bewegung();
		schattenpunkte();
		
		gesicht.play(gerani);
		gesichtschatten.play(gerani);
		
		if (checkStuckSchat) {
			checkForStucking();
		}
		
		//für die schatten
		G.schwebt = schwebt;
		
		//HXP.console.log(["G.sitzt:",G.sitzt," stehzaehler:",stehtzaehler," steht:", steht]);
	}
	
	override public function removed() {
		
		super.removed();
		
		schwebt = false;
		G.schwebt = false;
	}
	
	override public function moveCollideX(e:Entity):Bool {
		
		if (e.type == "schatten") {
			
			return true;
		}
		else if (e.type == "solid") {
			
			return true;
		}
		else if (e.type == "interesting" && (!schwebt || angreifen != 0)) {
			
			return true;
		}
		else if (e.type == "pure" && (schwebt || angreifen != 0)) {
			
			return true;
		}
		else return false;
	}
	
	override public function moveCollideY(e:Entity):Bool {
		
		if (e.type == "schatten") {
			
			return true;
		}
		else if (e.type == "solid") {
			
			return true;
		}
		else if (e.type == "interesting" && (!schwebt || angreifen != 0)) {
			
			return true;
		}
		else if (e.type == "pure" && (schwebt || angreifen != 0)) {
			
			return true;
		}
		else return false;
	}
	
	override public function bewegung() {
		
		//super.bewegung();
		
		// speX & speY Geschwindigkeit der einzelnen Achsen
		// bes Beschleunigung
		// fri Reibung
		
		moveBy(geschwindX, geschwindY, ["solid", "schatten", "lyly", "interesting", "pure"], true);
		
		speX = speXlinks + speXrechts + speXknock;
		speY = speYhoch + speYrunter + speYknock;
		
		geschwindX = speX * bes * fri * HXP.elapsed * ren;
		geschwindY = speY * bes * fri * HXP.elapsed * ren;
		
		
		// INPUT
		
		if (knock == 0) {
			
			if (Input.joystick(0).connected) {		// Pad
				
				//Gehen
				if (Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) <= 0) {		
					speXlinks = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) * speFakJ;
				} else if (Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_X) <= 0) {
					speXlinks = Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_X) * speFakJ;
				}
				
				if (Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) >= 0) {		
					speXrechts = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) * speFakJ;
				} else if (Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_X) >= 0) {
					speXrechts = Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_X) * speFakJ;
				}
				
				if (Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) <= 0) {		
					speYhoch = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) * speFakJ;
				} else if (Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_Y) <= 0) {
					speYhoch = Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_Y) * speFakJ;
				}
				
				if (Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) >= 0) {		
					speYrunter = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) * speFakJ;
				} else if (Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_Y) >= 0) {
					speYrunter = Input.joystick(0).getAxis(OUYA_GAMEPAD.LEFT_ANALOGUE_Y) * speFakJ;
				}
				
				//Switch
				if (angreifen == 0) {
					
					if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON) || Input.joystick(0).pressed(OUYA_GAMEPAD.O_BUTTON)) {
						
						gesicht.callbackFunc = schwebeswitch;
						angreifen = 1;
						
						if (schwebt) {
							
							if (richtung == 1) { gerani = "nord_sinken"; }
							if (richtung == 2) { gerani = "ost_sinken"; }
							if (richtung == 3) { gerani = "sud_sinken"; }
							if (richtung == 4) { gerani = "west_sinken"; }
						}
						else {
							
							if (richtung == 1) { gerani = "nord_steigen"; }
							if (richtung == 2) { gerani = "ost_steigen"; }
							if (richtung == 3) { gerani = "sud_steigen"; }
							if (richtung == 4) { gerani = "west_steigen"; }							
						}
					}	
				}
			} 
			else {	// Keyboard
				
				// Gehen
				if (Input.pressed("links")) { speXlinks = -2; }
				if (Input.check("links")) { 
					friXlinks = false;
					if (speXlinks >= -speMAX) { speXlinks = speXlinks * speFak; }
				} else if (Input.released("links")) { friXlinks = true; }
				
				if (Input.pressed("rechts")) { speXrechts = 2; }		
				if (Input.check("rechts")) { 
					friXrechts = false;
					if (speXrechts <= speMAX) { speXrechts = speXrechts * speFak; }
				} else if (Input.released("rechts")) { friXrechts = true; }
				
				if (Input.pressed("hoch")) { speYhoch = -2; }
				if (Input.check("hoch")) { 
					friYhoch = false;
					if (speYhoch >= -speMAX) { speYhoch = speYhoch * speFak; }
				} else if (Input.released("hoch")) { friYhoch = true; }
				
				if (Input.pressed("runter")) { speYrunter = 2; }
				if (Input.check("runter")) { 
					friYrunter = false;
					if (speYrunter <= speMAX) { speYrunter = speYrunter * speFak; }
				} else if (Input.released("runter")) { friYrunter = true; }
				
				if (friXlinks) { if (speXlinks < -1) { speXlinks = speXlinks * 0.5; } else if ( speXlinks < 0 && speXlinks >= -1) { speXlinks = 0; friXlinks = false; } }
				if (friXrechts) { if (speXrechts > 1) { speXrechts = speXrechts * 0.5; } else if (speXrechts > 0 && speXrechts <= 1) { speXrechts = 0; friXrechts = false; } }
				if (friYhoch) { if (speYhoch < -1) { speYhoch = speYhoch * 0.5; } else if (speYhoch < 0 && speYhoch >= -1) { speYhoch = 0; friYhoch = false; } }
				if (friYrunter) { if (speYrunter > 1) { speYrunter = speYrunter * 0.5; } else if (speYrunter > 0 && speYrunter <= 1) { speYrunter = 0; friYrunter = false; } }					
				
				//Switch
				if (angreifen == 0) {
					
					if (Input.pressed("springen") && collideTypes(["pure","interesting"],x,y) == null) {
						
						gesicht.callbackFunc = schwebeswitch;
						angreifen = 1;
						
						if (schwebt) {
							
							if (richtung == 1) { gerani = "nord_sinken"; }
							if (richtung == 2) { gerani = "ost_sinken"; }
							if (richtung == 3) { gerani = "sud_sinken"; }
							if (richtung == 4) { gerani = "west_sinken"; }
						}
						else {
							
							if (richtung == 1) { gerani = "nord_steigen"; }
							if (richtung == 2) { gerani = "ost_steigen"; }
							if (richtung == 3) { gerani = "sud_steigen"; }
							if (richtung == 4) { gerani = "west_steigen"; }							
						}
					}
				}
			}
			
			// Idle
			if (geschwindX == 0 && geschwindY == 0 && !G.sitzt) { 
				
				steht = true; 
				stehtzaehler += HXP.elapsed;
			}
			else { steht = false; stehtzaehler = 0; }
			
			if (stehtzaehler > 4) { // sonst 4
				
				G.sitzt = true;
				G.MoriSitzt = new Point(this.x, this.y);
				
				if (schwebt) {
					
					gesicht.callbackFunc = schwebeswitch;
					angreifen = 1;
					
					if (richtung == 1) { gerani = "nord_sinken"; }
					if (richtung == 2) { gerani = "ost_sinken"; }
					if (richtung == 3) { gerani = "sud_sinken"; }
					if (richtung == 4) { gerani = "west_sinken"; }					
				}
			}
			
			if (geschwindX != 0 || geschwindY != 0 || schwebt) { G.sitzt = false; } 
		}
	}
	
	private function animationen() {
		
		if (geschwindX > 0 && geschwindX > geschwindY && geschwindX > -geschwindY) { richtung = 2; }		// OST
		if (geschwindX < 0 && geschwindX < geschwindY && geschwindX < -geschwindY) { richtung = 4; }		// WEST
		if (geschwindY > 0 && geschwindY > geschwindX && geschwindY > -geschwindX) { richtung = 3; }		// SUD
		if (geschwindY < 0 && geschwindY < geschwindX && geschwindY < -geschwindX) { richtung = 1; }		// NORD
		
		if (angreifen == 0) {
			
			if (richtung == 1) {
				
				if ((G.sitzt || steht) && !schwebt) { gerani = "nord_kriechen_s"; }	
				else if (!steht && !schwebt) { gerani = "nord_kriechen"; }
				else if ((G.sitzt || steht) && schwebt) { gerani = "nord_schweben_s"; }
				else if (!steht && schwebt) { gerani = "nord_schweben"; }
			}
			if (richtung == 2) {
				
				if ((G.sitzt || steht) && !schwebt) { gerani = "ost_kriechen_s"; }	
				else if (!(G.sitzt || steht) && !schwebt) { gerani = "ost_kriechen"; }
				else if ((G.sitzt || steht) && schwebt) { gerani = "ost_schweben_s"; }
				else if (!(G.sitzt || steht) && schwebt) { gerani = "ost_schweben"; }
			}
			if (richtung == 3) {
				
				if ((G.sitzt || steht) && !schwebt) { gerani = "sud_kriechen_s"; }	
				else if (!(G.sitzt || steht) && !schwebt) { gerani = "sud_kriechen"; }
				else if ((G.sitzt || steht) && schwebt) { gerani = "sud_schweben_s"; }
				else if (!(G.sitzt || steht) && schwebt) { gerani = "sud_schweben"; }
			}
			if (richtung == 4) {
				
				if ((G.sitzt || steht) && !schwebt) { gerani = "west_kriechen_s"; }	
				else if (!(G.sitzt || steht) && !schwebt) { gerani = "west_kriechen"; }
				else if ((G.sitzt || steht) && schwebt) { gerani = "west_schweben_s"; }
				else if (!(G.sitzt || steht) && schwebt) { gerani = "west_schweben"; }
			}
		}	
	}

	private function schwebeswitch() {
		
		gesicht.callbackFunc = null;
		schwebt = !schwebt;
		angreifen = 0;
	}
	
	private function schattenpunkte() {
		
		if (SP > 0 && SP < SPmax) {
			SP -= 0.01;
			gesichtschatten.alpha = SP * 0.1;		// * 0.1
		}
		else if (SP <= 0) {
			SP = 0;
			gesichtschatten.alpha = 0;
		}
		else if (SP >= SPmax) {
			SP = SPmax;
			gesichtschatten.alpha = 1;
			
			if (SPmaxzaehler <= 300) {
				++SPmaxzaehler;
			}
			else {
				SPmaxzaehler = 0;
				SP -= 0.01;
			}
		}
	}	
	
	private function checkForStucking() {
		
		if (collide("lyly", this.x, this.y) != null) {
			
			var Bernd:Entity = collide("lyly", this.x, this.y);
			Bernd.stuckSolve("mori", 1, 6);
		}
		else checkStuckSchat = false;
	} 
	
	private function spritesheet() {
		
		gesicht.add("west_schweben", [0, 1], 4, true);
		gesicht.add("nord_schweben", [2, 3], 4, true);
		gesicht.add("ost_schweben",  [4, 5], 4, true);
		gesicht.add("sud_schweben",  [6, 7], 4, true);
		
		gesicht.add("west_kriechen", [8, 9], 4, true);
		gesicht.add("nord_kriechen", [10, 11], 4, true);
		gesicht.add("ost_kriechen",  [12, 13], 4, true);
		gesicht.add("sud_kriechen",  [14, 15], 4, true);	
		
		gesicht.add("west_schweben_s", [0, 1], 1, true);
		gesicht.add("nord_schweben_s", [2, 3], 1, true);
		gesicht.add("ost_schweben_s",  [4, 5], 1, true);
		gesicht.add("sud_schweben_s",  [6, 7], 1, true);
		
		gesicht.add("west_kriechen_s", [8, 9], 1, true);
		gesicht.add("nord_kriechen_s", [10, 11], 1, true);
		gesicht.add("ost_kriechen_s",  [12, 13], 1, true);
		gesicht.add("sud_kriechen_s",  [14, 15], 1, true);	
		
		gesicht.add("west_sinken", [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], 10, false);
		gesicht.add("west_steigen", [27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16], 10, false);
		gesicht.add("nord_sinken", [28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 10, false);
		gesicht.add("nord_steigen", [39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28], 10, false);
		gesicht.add("ost_sinken", [40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 10, false);
		gesicht.add("ost_steigen", [51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40], 10, false);
		gesicht.add("sud_sinken", [52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63], 10, false);
		gesicht.add("sud_steigen", [63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52], 10, false);
		
		
		gesichtschatten.add("west_schweben", [0, 1], 4, true);
		gesichtschatten.add("nord_schweben", [2, 3], 4, true);
		gesichtschatten.add("ost_schweben",  [4, 5], 4, true);
		gesichtschatten.add("sud_schweben",  [6, 7], 4, true);
		
		gesichtschatten.add("west_kriechen", [8, 9], 4, true);
		gesichtschatten.add("nord_kriechen", [10, 11], 4, true);
		gesichtschatten.add("ost_kriechen",  [12, 13], 4, true);
		gesichtschatten.add("sud_kriechen",  [14, 15], 4, true);	
		
		gesichtschatten.add("west_schweben_s", [0, 1], 1, true);
		gesichtschatten.add("nord_schweben_s", [2, 3], 1, true);
		gesichtschatten.add("ost_schweben_s",  [4, 5], 1, true);
		gesichtschatten.add("sud_schweben_s",  [6, 7], 1, true);
		
		gesichtschatten.add("west_kriechen_s", [8, 9], 1, true);
		gesichtschatten.add("nord_kriechen_s", [10, 11], 1, true);
		gesichtschatten.add("ost_kriechen_s",  [12, 13], 1, true);
		gesichtschatten.add("sud_kriechen_s",  [14, 15], 1, true);	
		
		gesichtschatten.add("west_sinken", [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], 10, false);
		gesichtschatten.add("west_steigen", [27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16], 10, false);
		gesichtschatten.add("nord_sinken", [28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 10, false);
		gesichtschatten.add("nord_steigen", [39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28], 10, false);
		gesichtschatten.add("ost_sinken", [40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 10, false);
		gesichtschatten.add("ost_steigen", [51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40], 10, false);
		gesichtschatten.add("sud_sinken", [52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63], 10, false);
		gesichtschatten.add("sud_steigen", [63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52], 10, false);
	}

	public var schwebt:Bool = false;
	
	public var gesicht:Spritemap = new Spritemap("graphics/enties/lysopsprite.png", 66, 125);
	//public var gesichtschatten:Spritemap = new Spritemap("graphics/enties/lysopspriteb.png", 66, 125);
	public var gesichtschatten:Spritemap = new Spritemap("graphics/enties/lysopspriteb2.png", 66, 125);
*/
}