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


class Mori extends Morikkel
{

	public function new(x:Float, y:Float) {
		
		super(x,y);
	}
	
	override public function added() {
		
		super.added();
		
		graphic = mori;
		addGraphic(morisschatten);
		
		name = "mori";
		setHitbox(26, 26, 13, 13);
		
		mori.originX = mori.width * .5;
		mori.originY = mori.height * .9;
		morisschatten.originX = mori.originX;
		morisschatten.originY = mori.originY;
		
		spritesheet();
		
		if (G.erstesmal) {
			
			morisschatten.alpha = 0;
			G.erstesmal = false;
			G.sitzt = true;
		}
		else {
			
			checkStucking = true;
			checkStuckSchat = true;
			SP = SPmax;
			genuggehoert = true;           
		}
	}
	
	override public function update() {
		
		super.update();
		
		if (!GG) {
			animationen();	
			knockback();
			if (G.kiste2pool && G.lifeclock < G.maxlife) { bewegung(); }
		}
		
		schattenpunkte();
		ende();
		
		//lufeclock ende
		if (G.lifeclock > G.maxlife) {
			
			if (!amboden) {
				
				gerani = "wurms";
				mori.callbackFunc =	hingelegt;			
			}
			else {
				
				gerani = "karotte";
				mori.callbackFunc = karotted;
				
				if (Input.joystick(0).connected) {
					
					if (Input.joystick(0).pressed()) {
						
						G.humus = true;
					}
				}
				else if (Input.pressed(Key.ANY)) {
					
					G.humus = true;	
				}
			}
		}
		
		mori.play(gerani);
		morisschatten.play(gerani);
		
		if (checkStuckSchat) {
			checkForStucking();
		}
	}
	
	override public function removed() {
		
		super.removed();
		
		if (GG) {
			
			GG = false;	
			scene.add(new Uggel(Std.int(this.x), Std.int(this.y)));
		}
	}
	
	override public function bewegung() {
		
		super.bewegung();
		
		// INPUT
		
		if (SPRUNGzal > 0) {
			--SPRUNGzal;
			imSPRUNG = true;
			fri = 0.1;	
		} else if (SPRUNGzal <= 0) {
			SPRUNGzal = 0;
			imSPRUNG = false;
			landen = false;
			fri = .05;
		}
		
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
				
				
				// Rennen
				/*
				 * 
				 * */
				if (Input.joystick(0).check(XBOX_GAMEPAD.LB_BUTTON) || Input.joystick(0).check(XBOX_GAMEPAD.RB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.LB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.RB_BUTTON)) { 
					ren = 1.9;
				} else if (Input.joystick(0).released(XBOX_GAMEPAD.LB_BUTTON) || Input.joystick(0).released(XBOX_GAMEPAD.RB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.LB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.RB_BUTTON)) {
					ren = 1;
				} else { ren = 1; }
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
				
				
				// Rennen
				/*
				 * */
				if (Input.check("rennen")) {
					ren = 1.9;
				} else if (Input.released("rennen")) { 
					ren = 1; 
				}
			}	
			
			// Idle
			if (geschwindX == 0 && geschwindY == 0 && !imSPRUNG && !G.sitzt && angreifen == 0) { 
				
				steht = true; 
				
				//damit nur, wenn nicht das bild angeschaut wird, G.sitzt getriggered wird
				if(!cast(scene, Mutterwelt).triggered) { stehtzaehler += HXP.elapsed; }
			}
			else { steht = false; stehtzaehler = 0; }
			
			if (stehtzaehler > 4) { // sonst 4
				mori.callbackFunc = hinsetzen;
				G.MoriSitzt = new Point(this.x, this.y);
				
				if (richtung == 1) { 
					
					if (G.epoche == 0) { gerani = "nord_setzen"; }
					else if (G.epoche == 1) { gerani = "nord_setzen_2"; }
					else if (G.epoche == 2) { gerani = "nord_setzen_3"; }
					else if (G.epoche == 3) { gerani = "nord_setzen_4"; }
					else if (G.epoche == 4) { gerani = "nord_setzen_5"; }				
				}
				if (richtung == 2) {
					
					if (G.epoche == 0) { gerani = "ost_setzen"; }
					else if (G.epoche == 1) { gerani = "ost_setzen_2"; }
					else if (G.epoche == 2) { gerani = "ost_setzen_3"; }
					else if (G.epoche == 3) { gerani = "ost_setzen_4"; }
					else if (G.epoche == 4) { gerani = "ost_setzen_5"; }
				}
				if (richtung == 3) { 
					
					if (G.epoche == 0) { gerani = "sud_setzen"; }
					else if (G.epoche == 1) { gerani = "sud_setzen_2"; }
					else if (G.epoche == 2) { gerani = "sud_setzen_3"; }
					else if (G.epoche == 3) { gerani = "sud_setzen_4"; }
					else if (G.epoche == 4) { gerani = "sud_setzen_5"; }					
				}
				if (richtung == 4) { 
					
					if (G.epoche == 0) { gerani = "west_setzen"; }
					else if (G.epoche == 1) { gerani = "west_setzen_2"; }
					else if (G.epoche == 2) { gerani = "west_setzen_3"; }
					else if (G.epoche == 3) { gerani = "west_setzen_4"; }
					else if (G.epoche == 4) { gerani = "west_setzen_5"; }
				}
			}
			
			if (geschwindX != 0 || geschwindY != 0 || imSPRUNG || angreifen != 0) { G.sitzt = false; }
		}
	}
	
	private function schattenpunkte() {
		
		if (SP > 0 && SP < SPmax) {
			SP -= 0.01;
			morisschatten.alpha = SP * 0.1;		// * 0.1
		}
		else if (SP <= 0) {
			SP = 0;
			morisschatten.alpha = 0;
		}
		else if (SP >= SPmax) {
			SP = SPmax;
			morisschatten.alpha = 1;
			
			if (SPmaxzaehler <= 300) {
				++SPmaxzaehler;
			}
			else {
				SPmaxzaehler = 0;
				SP -= 0.01;
			}
		}
	}
	
	private function animationen() {
		
		if (geschwindX > 0 && geschwindX > geschwindY && geschwindX > -geschwindY) { richtung = 2; }		// OST
		if (geschwindX < 0 && geschwindX < geschwindY && geschwindX < -geschwindY) { richtung = 4; }		// WEST
		if (geschwindY > 0 && geschwindY > geschwindX && geschwindY > -geschwindX) { richtung = 3; }		// SUD
		if (geschwindY < 0 && geschwindY < geschwindX && geschwindY < -geschwindX) { richtung = 1; }		// NORD
		
		if (angreifen == 0) {
			
			if (richtung == 1) {
				
				if (G.epoche == 0) {
					
					if (imSPRUNG && !landen) { gerani = "nord_springen"; }
					else if (landen) { gerani = "nord_landen"; }
					else if (G.sitzt) { gerani = "nord_sitzen"; }
					else if (steht) { gerani = "nord_stehen"; }	
					else if (ren == 1.9) { gerani = "nord_rennen"; }
					else if (ren == 1) { gerani = "nord_gehen"; }
				}
				else if (G.epoche == 1) {
					
					if (imSPRUNG && !landen) { gerani = "nord_springen_2"; }
					else if (landen) { gerani = "nord_landen_2"; }
					else if (G.sitzt) { gerani = "nord_sitzen_2"; }
					else if (steht) { gerani = "nord_stehen_2"; }	
					else if (ren == 1.9) { gerani = "nord_rennen_2"; }
					else if (ren == 1) { gerani = "nord_gehen_2"; }					
				}
				else if (G.epoche == 2) {
					
					if (imSPRUNG && !landen) { gerani = "nord_springen_3"; }
					else if (landen) { gerani = "nord_landen_3"; }
					else if (G.sitzt) { gerani = "nord_sitzen_3"; }
					else if (steht) { gerani = "nord_stehen_3"; }	
					else if (ren == 1.9) { gerani = "nord_rennen_3"; }
					else if (ren == 1) { gerani = "nord_gehen_3"; }					
				}
				else if (G.epoche == 3) {
					
					if (imSPRUNG && !landen) { gerani = "nord_springen_4"; }
					else if (landen) { gerani = "nord_landen_4"; }
					else if (G.sitzt) { gerani = "nord_sitzen_4"; }
					else if (steht) { gerani = "nord_stehen_4"; }	
					else if (ren == 1.9) { gerani = "nord_rennen_4"; }
					else if (ren == 1) { gerani = "nord_gehen_4"; }					
				}
				else if (G.epoche == 4) {
					
					if (imSPRUNG && !landen) { gerani = "nord_springen_5"; }
					else if (landen) { gerani = "nord_landen_5"; }
					else if (G.sitzt) { gerani = "nord_sitzen_5"; }
					else if (steht) { gerani = "nord_stehen_5"; }	
					else if (ren == 1.9) { gerani = "nord_rennen_5"; }
					else if (ren == 1) { gerani = "nord_gehen_5"; }					
				}
			}
			if (richtung == 2) {
				
				if (G.epoche == 0) {
					
					if (imSPRUNG && !landen) { gerani = "ost_springen"; }
					else if (landen) { gerani = "ost_landen"; }
					else if (G.sitzt) { gerani = "ost_sitzen"; }
					else if (steht) { gerani = "ost_stehen"; }
					else if (ren == 1.9) { gerani = "ost_rennen"; }
					else if (ren == 1) { gerani = "ost_gehen"; }					
				}
				else if (G.epoche == 1) {
					
					if (imSPRUNG && !landen) { gerani = "ost_springen_2"; }
					else if (landen) { gerani = "ost_landen_2"; }
					else if (G.sitzt) { gerani = "ost_sitzen_2"; }
					else if (steht) { gerani = "ost_stehen_2"; }
					else if (ren == 1.9) { gerani = "ost_rennen_2"; }
					else if (ren == 1) { gerani = "ost_gehen_2"; }					
				}
				else if (G.epoche == 2) {
					
					if (imSPRUNG && !landen) { gerani = "ost_springen_3"; }
					else if (landen) { gerani = "ost_landen_3"; }
					else if (G.sitzt) { gerani = "ost_sitzen_3"; }
					else if (steht) { gerani = "ost_stehen_3"; }
					else if (ren == 1.9) { gerani = "ost_rennen_3"; }
					else if (ren == 1) { gerani = "ost_gehen_3"; }					
				}
				else if (G.epoche == 3) {
					
					if (imSPRUNG && !landen) { gerani = "ost_springen_4"; }
					else if (landen) { gerani = "ost_landen_4"; }
					else if (G.sitzt) { gerani = "ost_sitzen_4"; }
					else if (steht) { gerani = "ost_stehen_4"; }
					else if (ren == 1.9) { gerani = "ost_rennen_4"; }
					else if (ren == 1) { gerani = "ost_gehen_4"; }					
				}
				else if (G.epoche == 4) {
					
					if (imSPRUNG && !landen) { gerani = "ost_springen_5"; }
					else if (landen) { gerani = "ost_landen_5"; }
					else if (G.sitzt) { gerani = "ost_sitzen_5"; }
					else if (steht) { gerani = "ost_stehen_5"; }
					else if (ren == 1.9) { gerani = "ost_rennen_5"; }
					else if (ren == 1) { gerani = "ost_gehen_5"; }					
				}
			}
			if (richtung == 3) {
				
				if (G.epoche == 0) {
					
					if (imSPRUNG && !landen) { gerani = "sud_springen"; }
					else if (landen) { gerani = "sud_landen"; }
					else if (G.sitzt) { gerani = "sud_sitzen"; }
					else if (steht) { gerani = "sud_stehen"; }
					else if (ren == 1.9) { gerani = "sud_rennen"; }
					else if (ren == 1) { gerani = "sud_gehen"; }	
				}
				else if (G.epoche == 1) {
					
					if (imSPRUNG && !landen) { gerani = "sud_springen_2"; }
					else if (landen) { gerani = "sud_landen_2"; }
					else if (G.sitzt) { gerani = "sud_sitzen_2"; }
					else if (steht) { gerani = "sud_stehen_2"; }
					else if (ren == 1.9) { gerani = "sud_rennen_2"; }
					else if (ren == 1) { gerani = "sud_gehen_2"; }	
				}
				else if (G.epoche == 2) {
					
					if (imSPRUNG && !landen) { gerani = "sud_springen_3"; }
					else if (landen) { gerani = "sud_landen_3"; }
					else if (G.sitzt) { gerani = "sud_sitzen_3"; }
					else if (steht) { gerani = "sud_stehen_3"; }
					else if (ren == 1.9) { gerani = "sud_rennen_3"; }
					else if (ren == 1) { gerani = "sud_gehen_3"; }	
				}
				else if (G.epoche == 3) {
					
					if (imSPRUNG && !landen) { gerani = "sud_springen_4"; }
					else if (landen) { gerani = "sud_landen_4"; }
					else if (G.sitzt) { gerani = "sud_sitzen_4"; }
					else if (steht) { gerani = "sud_stehen_4"; }
					else if (ren == 1.9) { gerani = "sud_rennen_4"; }
					else if (ren == 1) { gerani = "sud_gehen_4"; }	
				}
				else if (G.epoche == 4) {
					
					if (imSPRUNG && !landen) { gerani = "sud_springen_5"; }
					else if (landen) { gerani = "sud_landen_5"; }
					else if (G.sitzt) { gerani = "sud_sitzen_5"; }
					else if (steht) { gerani = "sud_stehen_5"; }
					else if (ren == 1.9) { gerani = "sud_rennen_5"; }
					else if (ren == 1) { gerani = "sud_gehen_5"; }	
				}
			}
			if (richtung == 4) {
				
				if (G.epoche == 0) {
					
					if (imSPRUNG && !landen) { gerani = "west_springen"; }
					else if (landen) { gerani = "west_landen"; }
					else if (G.sitzt) { gerani = "west_sitzen"; }
					else if (steht) { gerani = "west_stehen"; }
					else if (ren == 1.9) { gerani = "west_rennen"; }
					else if (ren == 1) { gerani = "west_gehen"; }					
				}
				else if (G.epoche == 1) {
					
					if (imSPRUNG && !landen) { gerani = "west_springen_2"; }
					else if (landen) { gerani = "west_landen_2"; }
					else if (G.sitzt) { gerani = "west_sitzen_2"; }
					else if (steht) { gerani = "west_stehen_2"; }
					else if (ren == 1.9) { gerani = "west_rennen_2"; }
					else if (ren == 1) { gerani = "west_gehen_2"; }					
				}
				else if (G.epoche == 2) {
					
					if (imSPRUNG && !landen) { gerani = "west_springen_3"; }
					else if (landen) { gerani = "west_landen_3"; }
					else if (G.sitzt) { gerani = "west_sitzen_3"; }
					else if (steht) { gerani = "west_stehen_3"; }
					else if (ren == 1.9) { gerani = "west_rennen_3"; }
					else if (ren == 1) { gerani = "west_gehen_3"; }					
				}
				else if (G.epoche == 3) {
					
					if (imSPRUNG && !landen) { gerani = "west_springen_4"; }
					else if (landen) { gerani = "west_landen_4"; }
					else if (G.sitzt) { gerani = "west_sitzen_4"; }
					else if (steht) { gerani = "west_stehen_4"; }
					else if (ren == 1.9) { gerani = "west_rennen_4"; }
					else if (ren == 1) { gerani = "west_gehen_4"; }					
				}
				else if (G.epoche == 4) {
					
					if (imSPRUNG && !landen) { gerani = "west_springen_5"; }
					else if (landen) { gerani = "west_landen_5"; }
					else if (G.sitzt) { gerani = "west_sitzen_5"; }
					else if (steht) { gerani = "west_stehen_5"; }
					else if (ren == 1.9) { gerani = "west_rennen_5"; }
					else if (ren == 1) { gerani = "west_gehen_5"; }					
				}
			}
		}
		
		if (knock != 0) {
			
			if (G.epoche == 0) {
				
				if (anne <= Math.PI * 0.25 || anne > Math.PI * 1.75) { gerani = "knockO"; }
				else if (anne > Math.PI * 0.25 && anne <= Math.PI * 0.75) { gerani = "knockN"; }
				else if (anne > Math.PI * 0.75 && anne <= Math.PI * 1.25) { gerani = "knockW"; }
				else if (anne > Math.PI * 1.25 && anne <= Math.PI * 1.75) { gerani = "knockS"; }				
			}
			else if (G.epoche == 1) {
				
				if (anne <= Math.PI * 0.25 || anne > Math.PI * 1.75) { gerani = "knockO_2"; }
				else if (anne > Math.PI * 0.25 && anne <= Math.PI * 0.75) { gerani = "knockN_2"; }
				else if (anne > Math.PI * 0.75 && anne <= Math.PI * 1.25) { gerani = "knockW_2"; }
				else if (anne > Math.PI * 1.25 && anne <= Math.PI * 1.75) { gerani = "knockS_2"; }				
			}
			else if (G.epoche == 2) {
				
				if (anne <= Math.PI * 0.25 || anne > Math.PI * 1.75) { gerani = "knockO_3"; }
				else if (anne > Math.PI * 0.25 && anne <= Math.PI * 0.75) { gerani = "knockN_3"; }
				else if (anne > Math.PI * 0.75 && anne <= Math.PI * 1.25) { gerani = "knockW_3"; }
				else if (anne > Math.PI * 1.25 && anne <= Math.PI * 1.75) { gerani = "knockS_3"; }				
			}
			else if (G.epoche == 3) {
				
				if (anne <= Math.PI * 0.25 || anne > Math.PI * 1.75) { gerani = "knockO_4"; }
				else if (anne > Math.PI * 0.25 && anne <= Math.PI * 0.75) { gerani = "knockN_4"; }
				else if (anne > Math.PI * 0.75 && anne <= Math.PI * 1.25) { gerani = "knockW_4"; }
				else if (anne > Math.PI * 1.25 && anne <= Math.PI * 1.75) { gerani = "knockS_4"; }				
			}
			else if (G.epoche == 4) {
				
				if (anne <= Math.PI * 0.25 || anne > Math.PI * 1.75) { gerani = "knockO_5"; }
				else if (anne > Math.PI * 0.25 && anne <= Math.PI * 0.75) { gerani = "knockN_5"; }
				else if (anne > Math.PI * 0.75 && anne <= Math.PI * 1.25) { gerani = "knockW_5"; }
				else if (anne > Math.PI * 1.25 && anne <= Math.PI * 1.75) { gerani = "knockS_5"; }				
			}
		}
	}
	
	private function ende() {
		
		if (GG) {
			
			gerani = "bye";
			angreifen = 0;
			mori.callbackFunc = gg;		
		}
	}
	
	private function gg() {
		
		scene.remove(this);
		cast(scene, Mutterwelt).kamerastart = true;
		mori.callbackFunc = null;
	}
	
	private function hingelegt() {
		
		amboden = true;
		mori.callbackFunc = null;
	}
	
	private function karotted() {
		
		G.humus = true;
	}
	
	private function hinsetzen() {
		
		G.sitzt = true;
		mori.callbackFunc = null;
	}
	
	private function angriffende() {
		
		angriffzurueck = true;
		mori.callbackFunc = null;
	}
	
	private function checkForStucking() {
		
		if (collide("schatten", this.x, this.y) != null) {
			
			var Bernd:Entity = collide("schatten", this.x, this.y);
			Bernd.stuckSolve("mori", 2, 6);
		}
		else checkStuckSchat = false;
	} 
	
	private function spritesheet() {
		
		// 1 & 2
		mori.add("nord_gehen", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		mori.add("nord_stehen", [16], 0, false);		
		mori.add("nord_gehen_2", [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 20, true);
		mori.add("nord_stehen_2", [34], 0, false);		
		
		mori.add("sud_gehen", [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 20, true);
		mori.add("sud_stehen", [52, 53], 1.5, true);
		mori.add("sud_gehen_2", [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		mori.add("sud_stehen_2", [70, 71], 1.5, true);
		
		mori.add("west_gehen", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87], 20, true);
		mori.add("west_stehen", [88, 89], 1.5 , true);
		mori.add("west_gehen_2", [90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105], 20, true);
		mori.add("west_stehen_2", [106, 107], 1.5 , true);
		
		mori.add("ost_gehen", [108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123], 20, true);
		mori.add("ost_stehen", [124, 125], 1.5, true);
		mori.add("ost_gehen_2", [126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141], 20, true);
		mori.add("ost_stehen_2", [142, 143], 1.5, true);	
		
		mori.add("nord_rennen", [144, 145, 146, 147, 148, 149, 150, 151], 13, true);
		mori.add("sud_rennen", [152, 153, 154, 155, 156, 157, 158, 159], 13, true);
		mori.add("west_sitzen", [160, 161], 1, true);
		mori.add("nord_rennen_2", [162, 163, 164, 165, 166, 167, 168, 169], 13, true);
		mori.add("sud_rennen_2", [170, 171, 172, 173, 174, 175, 176, 177], 13, true);
		mori.add("west_sitzen_2", [178, 179], 1, true);
		
		mori.add("west_rennen", [180, 181, 182, 183, 184, 185, 186, 187], 13, true);
		mori.add("ost_rennen", [188, 189, 190, 191, 192, 193, 194, 195], 13, true);		
		mori.add("ost_sitzen", [196, 197], 1, true);
		mori.add("west_rennen_2", [198, 199, 200, 201, 202, 203, 204, 205], 13, true);
		mori.add("ost_rennen_2", [206, 207, 208, 209, 210, 211, 212, 213], 13, true);		
		mori.add("ost_sitzen_2", [214, 215], 1, true);
		
		mori.add("knockN", [216, 217, 218, 219, 220, 221, 222, 223], 12, false);
		mori.add("west_setzen", [224, 225, 226, 227, 228, 229, 230, 231, 232, 233], 9, false);
		mori.add("knockN_2", [234, 235, 236, 237, 238, 239, 240, 241], 12, false);
		mori.add("west_setzen_2", [242, 243, 244, 245, 246, 247, 248, 249, 250, 251], 9, false);
		
		mori.add("knockS", [252, 253, 254, 255, 256, 257, 258, 259], 12, false);
		mori.add("ost_setzen", [260, 261, 262, 263, 264, 265, 266, 267, 268, 269], 9, false);
		mori.add("knockS_2", [270, 271, 272, 273, 274, 275, 276, 277], 12, false);
		mori.add("ost_setzen_2", [278, 279, 280, 281, 282, 283, 284, 285, 286, 287], 9, false);		
		
		mori.add("knockW", [288, 289, 290, 291, 292, 293, 294, 295], 12, false);
		mori.add("nord_setzen", [296, 297, 298, 299, 300, 301, 302, 303, 304, 305], 8, false);
		mori.add("knockW_2", [306, 307, 308, 309, 310, 311, 312, 313], 12, false);
		mori.add("nord_setzen_2", [314, 315, 316, 317, 318, 319, 320, 321, 322, 323], 8, false);		
		
		mori.add("knockO", [324, 325, 326, 327, 328, 329, 330, 331], 12, false);
		mori.add("sud_setzen", [332, 333, 334, 335, 336, 337, 338], 6, false);
		mori.add("sud_sitzen", [339, 340], 1, true);
		mori.add("nord_sitzen", [341], 0, false);
		mori.add("knockO_2", [342, 343, 344, 345, 346, 347, 348, 349], 12, false);
		mori.add("sud_setzen_2", [350, 351, 352, 353, 354, 355, 356], 6, false);
		mori.add("sud_sitzen_2", [357, 358], 1, true);
		mori.add("nord_sitzen_2", [359], 0, false);	
		
		// 3 & 4
		mori.add("nord_gehen_3", [360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375], 20, true);
		mori.add("nord_stehen_3", [376], 0, false);		
		mori.add("nord_gehen_4", [378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393], 20, true);
		mori.add("nord_stehen_4", [394], 0, false);		
		
		mori.add("sud_gehen_3", [396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411], 20, true);
		mori.add("sud_stehen_3", [412, 413], 1.5, true);
		mori.add("sud_gehen_4", [414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429], 20, true);
		mori.add("sud_stehen_4", [430, 431], 1.5, true);
		
		mori.add("west_gehen_3", [432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447], 20, true);
		mori.add("west_stehen_3", [448, 449], 1.5 , true);
		mori.add("west_gehen_4", [450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465], 20, true);
		mori.add("west_stehen_4", [466, 467], 1.5 , true);
		
		mori.add("ost_gehen_3", [468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483], 20, true);
		mori.add("ost_stehen_3", [484, 485], 1.5, true);
		mori.add("ost_gehen_4", [486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501], 20, true);
		mori.add("ost_stehen_4", [502, 503], 1.5, true);	
		
		mori.add("nord_rennen_3", [504, 505, 506, 507, 508, 509, 510, 511], 13, true);
		mori.add("sud_rennen_3", [512, 513, 514, 515, 516, 517, 518, 519], 13, true);
		mori.add("west_sitzen_3", [520, 521], 1, true);
		mori.add("nord_rennen_4", [522, 523, 524, 525, 526, 527, 528, 529], 13, true);
		mori.add("sud_rennen_4", [530, 531, 532, 533, 534, 535, 536, 537], 13, true);
		mori.add("west_sitzen_4", [538, 539], 1, true);
		
		mori.add("west_rennen_3", [540, 541, 542, 543, 544, 545, 546, 547], 13, true);
		mori.add("ost_rennen_3", [548, 549, 550, 551, 552, 553, 554, 555], 13, true);		
		mori.add("ost_sitzen_3", [556, 557], 1, true);
		mori.add("west_rennen_4", [558, 559, 560, 561, 562, 563, 564, 565], 13, true);
		mori.add("ost_rennen_4", [566, 567, 568, 569, 570, 571, 572, 573], 13, true);		
		mori.add("ost_sitzen_4", [574, 575], 1, true);
		
		mori.add("knockN_3", [576, 577, 578, 579, 580, 581, 582, 583], 12, false);
		mori.add("west_setzen_3", [584, 585, 586, 587, 588, 589, 590, 591, 592, 593], 9, false);
		mori.add("knockN_4", [594, 595, 596, 597, 598, 599, 600, 601], 12, false);
		mori.add("west_setzen_4", [602, 603, 604, 605, 606, 607, 608, 609, 610, 611], 9, false);
		
		mori.add("knockS_3", [612, 613, 614, 615, 616, 617, 618, 619], 12, false);
		mori.add("ost_setzen_3", [620, 621, 622, 623, 624, 625, 626, 627, 628, 629], 9, false);
		mori.add("knockS_4", [630, 631, 632, 633, 634, 635, 636, 637], 12, false);
		mori.add("ost_setzen_4", [638, 639, 640, 641, 642, 643, 644, 645, 646, 647], 9, false);		
		
		mori.add("knockW_3", [648, 649, 650, 651, 652, 653, 654, 655], 12, false);
		mori.add("nord_setzen_3", [656, 657, 658, 659, 660, 661, 662, 663, 664, 665], 8, false);
		mori.add("knockW_4", [666, 667, 668, 669, 670, 671, 672, 673], 12, false);
		mori.add("nord_setzen_4", [674, 675, 676, 677, 678, 679, 680, 681, 682, 683], 8, false);		
		
		mori.add("knockO_3", [684, 685, 686, 687, 688, 689, 690, 691], 12, false);
		mori.add("sud_setzen_3", [692, 693, 694, 695, 696, 697, 698], 6, false);
		mori.add("sud_sitzen_3", [699, 700], 1, true);
		mori.add("nord_sitzen_3", [701], 0, false);
		mori.add("knockO_4", [702, 703, 704, 705, 706, 707, 708, 709], 12, false);
		mori.add("sud_setzen_4", [710, 711, 712, 713, 714, 715, 716], 6, false);
		mori.add("sud_sitzen_4", [717, 718], 1, true);
		mori.add("nord_sitzen_4", [719], 0, false);			
		
		// 5
		mori.add("nord_gehen_5", [720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735], 20, true);
		mori.add("nord_stehen_5", [736], 0, false);	
		mori.add("west_rennen_5", [738, 739, 740, 741, 742, 743, 744, 745], 13, true);
		mori.add("ost_rennen_5", [746, 747, 748, 749, 750, 751, 752, 753], 13, true);		
		mori.add("ost_sitzen_5", [754, 755], 1, true);	
		
		mori.add("sud_gehen_5", [756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771], 20, true);
		mori.add("sud_stehen_5", [772, 773], 1.5, true);
		mori.add("knockN_5", [774, 775, 776, 777, 778, 779, 780, 781], 12, false);
		mori.add("west_setzen_5", [782, 783, 784, 785, 786, 787, 788, 789, 790, 791], 9, false);
		
		mori.add("west_gehen_5", [792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807], 20, true);
		mori.add("west_stehen_5", [808, 809], 1.5 , true);
		mori.add("knockS_5", [810, 811, 812, 813, 814, 815, 816, 817], 12, false);
		mori.add("ost_setzen_5", [818, 819, 820, 821, 822, 823, 824, 825, 826, 827], 9, false);	
		
		mori.add("ost_gehen_5", [828, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839, 840, 841, 842, 843], 20, true);
		mori.add("ost_stehen_5", [844, 845], 1.5, true);
		mori.add("knockW_5", [846, 847, 848, 849, 850, 851, 852, 853], 12, false);
		mori.add("nord_setzen_5", [854, 855, 856, 857, 858, 859, 860, 861, 862, 863], 8, false);	
		
		mori.add("nord_rennen_5", [864, 865, 866, 867, 868, 869, 870, 871], 13, true);
		mori.add("sud_rennen_5", [872, 873, 874, 875, 876, 877, 878, 879], 13, true);
		mori.add("west_sitzen_5", [880, 881], 1, true);
		mori.add("knockO_5", [882, 883, 884, 885, 886, 887, 888, 889], 12, false);
		mori.add("sud_setzen_5", [890, 891, 892, 893, 894, 895, 896], 6, false);
		mori.add("sud_sitzen_5", [897, 898], 1, true);
		mori.add("nord_sitzen_5", [899], 0, false);		
		
		// bye																																		  915												     915												    915												       915
		mori.add("bye", [900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923, 924, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935], 12, false);
		
		//ende			  /----------------- ost setzten ------------------/------------------ ost sitzen --------------------------------------------------------------------------/----------------------------- halsknick -------------------------------------------------------------/---------------------- neue ----- - - - -
		mori.add("wurms", [818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 754, 754, 754, 754, 754, 754, 754, 754, 754, 755, 755, 755, 755, 755, 755, 755, 755, 754, 754, 754, 754, 1006, 1006, 1006, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 986, 987, 988, 989, 990, 991, 992, 993, 994, 995, 995, 995, 995, 995, 995, 995, 995, 995, 995, 995, 995, 995, 996, 997, 998, 999, 1000], 7, false);
		mori.add("karotte", [1001, 1001, 1002, 1002, 1003, 1003, 1004, 1004, 1005, 1005], 1, false);
		
		
		morisschatten.add("nord_gehen", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		morisschatten.add("nord_stehen", [16], 0, false);
		morisschatten.add("sud_gehen", [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 20, true);
		morisschatten.add("sud_stehen", [34, 35], 1.5, true);
		morisschatten.add("west_gehen", [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 20, true);
		morisschatten.add("west_stehen", [52, 53], 1.5 , true);
		morisschatten.add("ost_gehen", [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		morisschatten.add("ost_stehen", [70, 71], 1.5, true);
		morisschatten.add("nord_rennen", [126, 127, 128, 129, 130, 131, 132, 133], 13, true);
		morisschatten.add("sud_rennen", [134, 135, 136, 137, 138, 139, 140, 141], 13, true);
		morisschatten.add("west_rennen", [144, 145, 146, 147, 148, 149, 150, 151], 13, true);
		morisschatten.add("ost_rennen", [152, 153, 154, 155, 156, 157, 158, 159], 13, true);
		morisschatten.add("knockN", [162, 163, 164, 165, 166, 167, 168, 169], 12, false);
		morisschatten.add("knockS", [180, 181, 182, 183, 184, 185, 186, 187], 12, false);
		morisschatten.add("knockW", [198, 199, 200, 201, 202, 203, 204, 205], 12, false);
		morisschatten.add("knockO", [216, 217, 218 , 219, 220, 221, 222, 223], 12, false);
		morisschatten.add("nord_setzen", [206, 207, 208, 209, 210, 211, 212, 213, 214, 215], 8, false);
		morisschatten.add("nord_sitzen", [233], 0, false);
		morisschatten.add("sud_setzen", [224, 225, 226, 227, 228, 229, 230], 6, false);
		morisschatten.add("sud_sitzen", [231, 232], 1, true);
		morisschatten.add("west_setzen", [170, 171, 172, 173, 174, 175, 176, 177, 178, 179], 9, false);
		morisschatten.add("west_sitzen", [142, 143], 1, true);
		morisschatten.add("ost_setzen", [188, 189, 190, 191, 192, 193, 194, 195, 196, 197], 9, false);
		morisschatten.add("ost_sitzen", [160, 161], 1, true);

		morisschatten.add("nord_gehen_2", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		morisschatten.add("nord_stehen_2", [16], 0, false);
		morisschatten.add("sud_gehen_2", [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 20, true);
		morisschatten.add("sud_stehen_2", [34, 35], 1.5, true);
		morisschatten.add("west_gehen_2", [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 20, true);
		morisschatten.add("west_stehen_2", [52, 53], 1.5 , true);
		morisschatten.add("ost_gehen_2", [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		morisschatten.add("ost_stehen_2", [70, 71], 1.5, true);
		morisschatten.add("nord_rennen_2", [126, 127, 128, 129, 130, 131, 132, 133], 13, true);
		morisschatten.add("sud_rennen_2", [134, 135, 136, 137, 138, 139, 140, 141], 13, true);
		morisschatten.add("west_rennen_2", [144, 145, 146, 147, 148, 149, 150, 151], 13, true);
		morisschatten.add("ost_rennen_2", [152, 153, 154, 155, 156, 157, 158, 159], 13, true);
		morisschatten.add("knockN_2", [162, 163, 164, 165, 166, 167, 168, 169], 12, false);
		morisschatten.add("knockS_2", [180, 181, 182, 183, 184, 185, 186, 187], 12, false);
		morisschatten.add("knockW_2", [198, 199, 200, 201, 202, 203, 204, 205], 12, false);
		morisschatten.add("knockO_2", [216, 217, 218 , 219, 220, 221, 222, 223], 12, false);
		morisschatten.add("nord_setzen_2", [206, 207, 208, 209, 210, 211, 212, 213, 214, 215], 8, false);
		morisschatten.add("nord_sitzen_2", [233], 0, false);
		morisschatten.add("sud_setzen_2", [224, 225, 226, 227, 228, 229, 230], 6, false);
		morisschatten.add("sud_sitzen_2", [231, 232], 1, true);
		morisschatten.add("west_setzen_2", [170, 171, 172, 173, 174, 175, 176, 177, 178, 179], 9, false);
		morisschatten.add("west_sitzen_2", [142, 143], 1, true);
		morisschatten.add("ost_setzen_2", [188, 189, 190, 191, 192, 193, 194, 195, 196, 197], 9, false);
		morisschatten.add("ost_sitzen_2", [160, 161], 1, true);
		
		morisschatten.add("nord_gehen_3", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		morisschatten.add("nord_stehen_3", [16], 0, false);
		morisschatten.add("sud_gehen_3", [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 20, true);
		morisschatten.add("sud_stehen_3", [34, 35], 1.5, true);
		morisschatten.add("west_gehen_3", [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 20, true);
		morisschatten.add("west_stehen_3", [52, 53], 1.5 , true);
		morisschatten.add("ost_gehen_3", [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		morisschatten.add("ost_stehen_3", [70, 71], 1.5, true);
		morisschatten.add("nord_rennen_3", [126, 127, 128, 129, 130, 131, 132, 133], 13, true);
		morisschatten.add("sud_rennen_3", [134, 135, 136, 137, 138, 139, 140, 141], 13, true);
		morisschatten.add("west_rennen_3", [144, 145, 146, 147, 148, 149, 150, 151], 13, true);
		morisschatten.add("ost_rennen_3", [152, 153, 154, 155, 156, 157, 158, 159], 13, true);
		morisschatten.add("knockN_3", [162, 163, 164, 165, 166, 167, 168, 169], 12, false);
		morisschatten.add("knockS_3", [180, 181, 182, 183, 184, 185, 186, 187], 12, false);
		morisschatten.add("knockW_3", [198, 199, 200, 201, 202, 203, 204, 205], 12, false);
		morisschatten.add("knockO_3", [216, 217, 218 , 219, 220, 221, 222, 223], 12, false);
		morisschatten.add("nord_setzen_3", [206, 207, 208, 209, 210, 211, 212, 213, 214, 215], 8, false);
		morisschatten.add("nord_sitzen_3", [233], 0, false);
		morisschatten.add("sud_setzen_3", [224, 225, 226, 227, 228, 229, 230], 6, false);
		morisschatten.add("sud_sitzen_3", [231, 232], 1, true);
		morisschatten.add("west_setzen_3", [170, 171, 172, 173, 174, 175, 176, 177, 178, 179], 9, false);
		morisschatten.add("west_sitzen_3", [142, 143], 1, true);
		morisschatten.add("ost_setzen_3", [188, 189, 190, 191, 192, 193, 194, 195, 196, 197], 9, false);
		morisschatten.add("ost_sitzen_3", [160, 161], 1, true);
		
		morisschatten.add("nord_gehen_4", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		morisschatten.add("nord_stehen_4", [16], 0, false);
		morisschatten.add("sud_gehen_4", [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 20, true);
		morisschatten.add("sud_stehen_4", [34, 35], 1.5, true);
		morisschatten.add("west_gehen_4", [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 20, true);
		morisschatten.add("west_stehen_4", [52, 53], 1.5 , true);
		morisschatten.add("ost_gehen_4", [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		morisschatten.add("ost_stehen_4", [70, 71], 1.5, true);
		morisschatten.add("nord_rennen_4", [126, 127, 128, 129, 130, 131, 132, 133], 13, true);
		morisschatten.add("sud_rennen_4", [134, 135, 136, 137, 138, 139, 140, 141], 13, true);
		morisschatten.add("west_rennen_4", [144, 145, 146, 147, 148, 149, 150, 151], 13, true);
		morisschatten.add("ost_rennen_4", [152, 153, 154, 155, 156, 157, 158, 159], 13, true);
		morisschatten.add("knockN_4", [162, 163, 164, 165, 166, 167, 168, 169], 12, false);
		morisschatten.add("knockS_4", [180, 181, 182, 183, 184, 185, 186, 187], 12, false);
		morisschatten.add("knockW_4", [198, 199, 200, 201, 202, 203, 204, 205], 12, false);
		morisschatten.add("knockO_4", [216, 217, 218 , 219, 220, 221, 222, 223], 12, false);
		morisschatten.add("nord_setzen_4", [206, 207, 208, 209, 210, 211, 212, 213, 214, 215], 8, false);
		morisschatten.add("nord_sitzen_4", [233], 0, false);
		morisschatten.add("sud_setzen_4", [224, 225, 226, 227, 228, 229, 230], 6, false);
		morisschatten.add("sud_sitzen_4", [231, 232], 1, true);
		morisschatten.add("west_setzen_4", [170, 171, 172, 173, 174, 175, 176, 177, 178, 179], 9, false);
		morisschatten.add("west_sitzen_4", [142, 143], 1, true);
		morisschatten.add("ost_setzen_4", [188, 189, 190, 191, 192, 193, 194, 195, 196, 197], 9, false);
		morisschatten.add("ost_sitzen_4", [160, 161], 1, true);
		
		morisschatten.add("nord_gehen_5", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		morisschatten.add("nord_stehen_5", [16], 0, false);
		morisschatten.add("sud_gehen_5", [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 20, true);
		morisschatten.add("sud_stehen_5", [34, 35], 1.5, true);
		morisschatten.add("west_gehen_5", [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 20, true);
		morisschatten.add("west_stehen_5", [52, 53], 1.5 , true);
		morisschatten.add("ost_gehen_5", [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		morisschatten.add("ost_stehen_5", [70, 71], 1.5, true);
		morisschatten.add("nord_rennen_5", [126, 127, 128, 129, 130, 131, 132, 133], 13, true);
		morisschatten.add("sud_rennen_5", [134, 135, 136, 137, 138, 139, 140, 141], 13, true);
		morisschatten.add("west_rennen_5", [144, 145, 146, 147, 148, 149, 150, 151], 13, true);
		morisschatten.add("ost_rennen_5", [152, 153, 154, 155, 156, 157, 158, 159], 13, true);
		morisschatten.add("knockN_5", [162, 163, 164, 165, 166, 167, 168, 169], 12, false);
		morisschatten.add("knockS_5", [180, 181, 182, 183, 184, 185, 186, 187], 12, false);
		morisschatten.add("knockW_5", [198, 199, 200, 201, 202, 203, 204, 205], 12, false);
		morisschatten.add("knockO_5", [216, 217, 218 , 219, 220, 221, 222, 223], 12, false);
		morisschatten.add("nord_setzen_5", [206, 207, 208, 209, 210, 211, 212, 213, 214, 215], 8, false);
		morisschatten.add("nord_sitzen_5", [233], 0, false);
		morisschatten.add("sud_setzen_5", [224, 225, 226, 227, 228, 229, 230], 6, false);
		morisschatten.add("sud_sitzen_5", [231, 232], 1, true);
		morisschatten.add("west_setzen_5", [170, 171, 172, 173, 174, 175, 176, 177, 178, 179], 9, false);
		morisschatten.add("west_sitzen_5", [142, 143], 1, true);
		morisschatten.add("ost_setzen_5", [188, 189, 190, 191, 192, 193, 194, 195, 196, 197], 9, false);
		morisschatten.add("ost_sitzen_5", [160, 161], 1, true);
		
		morisschatten.add("bye", [109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251], 12, false);
	}
	
	
	// Bewegung
	
	public var imSPRUNG:Bool 				= false;
	public var SPRUNGzal:Float 				= 0; 
	private static var SPRUNGzalMAX:Float 	= 33;
	public var landen:Bool					= false;

	// Grafik
	
	public var mori:Spritemap				= new Spritemap("graphics/enties/morisprite.png", 34, 57);
	public var morisschatten:Spritemap		= new Spritemap("graphics/enties/morischatten.png", 34, 57);

}