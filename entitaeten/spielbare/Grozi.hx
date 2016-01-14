package entitaeten.spielbare;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.HXP;
import entitaeten.schatten.Groz;
import entitaeten.schatten.Uggel;
import entitaeten.schatten.Schatten;
import openfl.display.Sprite;
import openfl.geom.Point;
import welten.Mutterwelt;

class Grozi extends Morikkel
{

	public function new(x:Float, y:Float ) {
		
		super(x, y);
	}
	
	override public function added() {
		
		super.added();	
	
		graphic = grozi;
		addGraphic(groziSCH);
		
		SP = SPmax;
		
		name = "grozi";
		setHitbox(30, 30, 15, 15);
		
		grozi.originX = grozi.width * .5;
		grozi.originY = grozi.height * .87;
		groziSCH.originX = grozi.originX;
		groziSCH.originY = grozi.originY;
		
		spritesheet();
		
		genuggehoert = true;
	}
	
	override public function update() {
		
		super.update();
		
		if (!GG) {
			animationen();
			knockback();
			if (G.lifeclock < G.maxlife) { bewegung(); }
		}
		schattenpunkte();
		ende();
		
		if (G.lifeclock > G.maxlife) {
			
			if (!amboden) {
				
				if (!sitzt) {
					
					gerani = "setzenS_5";
					grozi.callbackFunc = hingesetzt;
				}
				else {
					
					gerani = "humi";
					grozi.callbackFunc = vergammelt;							
				}
			}
			else {
				
				gerani = "karotte";
				grozi.callbackFunc = karotted;
				
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
		
		grozi.play(gerani);
		groziSCH.play(gerani);
		
		if (checkStuckSchat) {
			checkForStucking();
		}
		
	//	var bubu:Schatten = cast(HXP.scene.nearestToEntity("schatten", this), Schatten);
	//	HXP.console.log([bubu.vg, bubu.scherzaehlt, bubu.HPP]);
	}
	
	override public function removed() {
		
		super.removed();
		
		if (GG) {
			
			GG = false;	
			scene.add(new Groz(Std.int(this.x), Std.int(this.y)));			
		}
	}
	
	override public function bewegung() {
		
		super.bewegung();
		
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
				
				if (Input.joystick(0).check(XBOX_GAMEPAD.LB_BUTTON) || Input.joystick(0).check(XBOX_GAMEPAD.RB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.LB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.RB_BUTTON)) { 
					ren = 1.7;
				} else if (Input.joystick(0).released(XBOX_GAMEPAD.LB_BUTTON) || Input.joystick(0).released(XBOX_GAMEPAD.RB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.LB_BUTTON) || Input.joystick(0).check(OUYA_GAMEPAD.RB_BUTTON)) {
					ren = 1;
				} else { ren = 1; }
				
				
				// Schieben
				
				// Angreifen
				/*
				 * 	Rennen zu angreifen + delay timer gegen instant spam
				 * */
				if (angreifen == 0) {
					
					if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON) || Input.joystick(0).pressed(OUYA_GAMEPAD.U_BUTTON)) {
						
						grozi.callbackFunc = angriffende;
						
						gerani = "schlagen";
						angreifen = 1;
					}
				} else if (Input.joystick(0).released(XBOX_GAMEPAD.X_BUTTON) || Input.joystick(0).released(OUYA_GAMEPAD.U_BUTTON)) {
					
					angreifen = 0;
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
				
				// Rennen
				
				if (Input.check("rennen")) {
					ren = 1.7;
				} else if (Input.released("rennen")) { 
					ren = 1; 
				}
				
				
				// Schieben
				
				// Angreifen
				if (angreifen == 0) {
					
					if (Input.pressed("schlagen")) {
						
						grozi.callbackFunc = angriffende;
						
						if (G.epoche == 0) { gerani = "schlagen"; }
						else if (G.epoche == 1) { gerani = "schlagen_2"; }
						else if (G.epoche == 2) { gerani = "schlagen_3"; }
						else if (G.epoche == 3) { gerani = "schlagen_4"; }
						else if (G.epoche == 4) { gerani = "schlagen_5"; }
						
						angreifen = 1;
					}
				} else if (Input.released("schlagen")) {
					
					angreifen = 0;
				}
			}
			
			// Idle
			if (geschwindX == 0 && geschwindY == 0 && !G.sitzt && angreifen == 0) { 
				
				steht = true; 
				
				if (!cast(scene, Mutterwelt).triggered) { stehtzaehler += HXP.elapsed; }
			}
			else { steht = false; stehtzaehler = 0; }
			
			if (stehtzaehler > 4) { //sonst 4
				grozi.callbackFunc = hinsetzen;
				G.MoriSitzt = new Point(this.x, this.y);
				
				if (G.epoche == 0) {
					
					if (richtung == 1) { gerani = "setzenN"; }
					if (richtung == 2) { gerani = "setzenO"; }
					if (richtung == 3) { gerani = "setzenS"; }
					if (richtung == 4) { gerani = "setzenW"; }						
				}
				else if (G.epoche == 1) {
					
					if (richtung == 1) { gerani = "setzenN_2"; }
					if (richtung == 2) { gerani = "setzenO_2"; }
					if (richtung == 3) { gerani = "setzenS_2"; }
					if (richtung == 4) { gerani = "setzenW_2"; }						
				}
				else if (G.epoche == 2) {
					
					if (richtung == 1) { gerani = "setzenN_3"; }
					if (richtung == 2) { gerani = "setzenO_3"; }
					if (richtung == 3) { gerani = "setzenS_3"; }
					if (richtung == 4) { gerani = "setzenW_3"; }						
				}
				else if (G.epoche == 3) {
					
					if (richtung == 1) { gerani = "setzenN_4"; }
					if (richtung == 2) { gerani = "setzenO_4"; }
					if (richtung == 3) { gerani = "setzenS_4"; }
					if (richtung == 4) { gerani = "setzenW_4"; }						
				}
				else if (G.epoche == 4) {
					
					if (richtung == 1) { gerani = "setzenN_5"; }
					if (richtung == 2) { gerani = "setzenO_5"; }
					if (richtung == 3) { gerani = "setzenS_5"; }
					if (richtung == 4) { gerani = "setzenW_5"; }						
				}
			}
			
			if (geschwindX != 0 || geschwindY != 0 || angreifen != 0) { G.sitzt = false; }
		}
	}
	
	private function animationen() {
		
		if (geschwindX > 0 && geschwindX > geschwindY && geschwindX > -geschwindY) { richtung = 2; }		// OST
		if (geschwindX < 0 && geschwindX < geschwindY && geschwindX < -geschwindY) { richtung = 4; }		// WEST
		if (geschwindY > 0 && geschwindY > geschwindX && geschwindY > -geschwindX) { richtung = 3; }		// SUD
		if (geschwindY < 0 && geschwindY < geschwindX && geschwindY < -geschwindX) { richtung = 1; }		// NORD
		
		if (angreifen == 0) {
			
			if (G.epoche == 0) {
				
				if (richtung == 1) {
					
					 if (G.sitzt) { gerani = "sitzenN"; }
					else if (steht) { gerani = "stehenN"; }	
					else if (ren == 1.7) { gerani = "rennenN"; }
					else if (ren == 1) { gerani = "gehenN"; }
				}
				if (richtung == 2) {
					
					 if (G.sitzt) { gerani = "sitzenO"; }
					else if (steht) { gerani = "stehenO"; }
					else if (ren == 1.7) { gerani = "rennenO"; }
					else if (ren == 1) { gerani = "gehenO"; }
				}
				if (richtung == 3) {
					
					 if (G.sitzt) { gerani = "sitzenS"; }
					else if (steht) { gerani = "stehenS"; }
					else if (ren == 1.7) { gerani = "rennenS"; }
					else if (ren == 1) { gerani = "gehenS"; }
				}
				if (richtung == 4) {
					
					 if (G.sitzt) { gerani = "sitzenW"; }
					else if (steht) { gerani = "stehenW"; }
					else if (ren == 1.7) { gerani = "rennenW"; }
					else if (ren == 1) { gerani = "gehenW"; }
				}				
			}
			else if (G.epoche == 1) {
				
				if (richtung == 1) {
					
					if (G.sitzt) { gerani = "sitzenN_2"; }
					else if (steht) { gerani = "stehenN_2"; }	
					else if (ren == 1.7) { gerani = "rennenN_2"; }
					else if (ren == 1) { gerani = "gehenN_2"; }
				}
				if (richtung == 2) {
					
					if (G.sitzt) { gerani = "sitzenO_2"; }
					else if (steht) { gerani = "stehenO_2"; }
					else if (ren == 1.7) { gerani = "rennenO_2"; }
					else if (ren == 1) { gerani = "gehenO_2"; }
				}
				if (richtung == 3) {
					
					if (G.sitzt) { gerani = "sitzenS_2"; }
					else if (steht) { gerani = "stehenS_2"; }
					else if (ren == 1.7) { gerani = "rennenS_2"; }
					else if (ren == 1) { gerani = "gehenS_2"; }
				}
				if (richtung == 4) {
					
					if (G.sitzt) { gerani = "sitzenW_2"; }
					else if (steht) { gerani = "stehenW_2"; }
					else if (ren == 1.7) { gerani = "rennenW_2"; }
					else if (ren == 1) { gerani = "gehenW_2"; }
				}				
			}
			else if (G.epoche == 2) {
				
				if (richtung == 1) {
					
					if (G.sitzt) { gerani = "sitzenN_3"; }
					else if (steht) { gerani = "stehenN_3"; }	
					else if (ren == 1.7) { gerani = "rennenN_3"; }
					else if (ren == 1) { gerani = "gehenN_3"; }
				}
				if (richtung == 2) {
					
					if (G.sitzt) { gerani = "sitzenO_3"; }
					else if (steht) { gerani = "stehenO_3"; }
					else if (ren == 1.7) { gerani = "rennenO_3"; }
					else if (ren == 1) { gerani = "gehenO_3"; }
				}
				if (richtung == 3) {
					
					if (G.sitzt) { gerani = "sitzenS_3"; }
					else if (steht) { gerani = "stehenS_3"; }
					else if (ren == 1.7) { gerani = "rennenS_3"; }
					else if (ren == 1) { gerani = "gehenS_3"; }
				}
				if (richtung == 4) {
					
					if (G.sitzt) { gerani = "sitzenW_3"; }
					else if (steht) { gerani = "stehenW_3"; }
					else if (ren == 1.7) { gerani = "rennenW_3"; }
					else if (ren == 1) { gerani = "gehenW_3"; }
				}				
			}
			else if (G.epoche == 3) {
				
				if (richtung == 1) {
					
					if (G.sitzt) { gerani = "sitzenN_4"; }
					else if (steht) { gerani = "stehenN_4"; }	
					else if (ren == 1.7) { gerani = "rennenN_4"; }
					else if (ren == 1) { gerani = "gehenN_4"; }
				}
				if (richtung == 2) {
					
					if (G.sitzt) { gerani = "sitzenO_4"; }
					else if (steht) { gerani = "stehenO_4"; }
					else if (ren == 1.7) { gerani = "rennenO_4"; }
					else if (ren == 1) { gerani = "gehenO_4"; }
				}
				if (richtung == 3) {
					
					if (G.sitzt) { gerani = "sitzenS_4"; }
					else if (steht) { gerani = "stehenS_4"; }
					else if (ren == 1.7) { gerani = "rennenS_4"; }
					else if (ren == 1) { gerani = "gehenS_4"; }
				}
				if (richtung == 4) {
					
					if (G.sitzt) { gerani = "sitzenW_4"; }
					else if (steht) { gerani = "stehenW_4"; }
					else if (ren == 1.7) { gerani = "rennenW_4"; }
					else if (ren == 1) { gerani = "gehenW_4"; }
				}				
			}
			else if (G.epoche == 4) {
				
				if (richtung == 1) {
					
					if (G.sitzt) { gerani = "sitzenN_5"; }
					else if (steht) { gerani = "stehenN_5"; }	
					else if (ren == 1.7) { gerani = "rennenN_5"; }
					else if (ren == 1) { gerani = "gehenN_5"; }
				}
				if (richtung == 2) {
					
					if (G.sitzt) { gerani = "sitzenO_5"; }
					else if (steht) { gerani = "stehenO_5"; }
					else if (ren == 1.7) { gerani = "rennenO_5"; }
					else if (ren == 1) { gerani = "gehenO_5"; }
				}
				if (richtung == 3) {
					
					if (G.sitzt) { gerani = "sitzenS_5"; }
					else if (steht) { gerani = "stehenS_5"; }
					else if (ren == 1.7) { gerani = "rennenS_5"; }
					else if (ren == 1) { gerani = "gehenS_5"; }
				}
				if (richtung == 4) {
					
					if (G.sitzt) { gerani = "sitzenW_5"; }
					else if (steht) { gerani = "stehenW_5"; }
					else if (ren == 1.7) { gerani = "rennenW_5"; }
					else if (ren == 1) { gerani = "gehenW_5"; }
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
	
	private function schattenpunkte() {
		
		if (SP > 0 && SP < SPmax) {
			SP -= 0.01;
			groziSCH.alpha = SP * 0.1;		// * 0.1
		}
		else if (SP <= 0) {
			SP = 0;
			groziSCH.alpha = 0;
		}
		else if (SP >= SPmax) {
			SP = SPmax;
			groziSCH.alpha = 1;
			
			if (SPmaxzaehler <= 300) {
				++SPmaxzaehler;
			}
			else {
				SPmaxzaehler = 0;
				SP -= 0.01;
			}
		}
	}
	
	private function ende() {
		
		if (GG) {
			
			gerani = "schlagen";
			angreifen = 0;
			grozi.callbackFunc = gg;		
		}
	}
	
	private function gg() {
		
		scene.remove(this);
		cast(scene, Mutterwelt).kamerastart = true;
		grozi.callbackFunc = null;
	}
	
	private function vergammelt() {
		
		amboden = true;
		grozi.callbackFunc = null;
	}
	
	private function hingesetzt() {
		
		sitzt = true;
		grozi.callbackFunc = null;
	}
	
	private function karotted() {
		
		G.humus = true;
	}
	
	private function angriffende() {
		
		angreifen = 0;
		grozi.callbackFunc = null;
	}
	
	private function hinsetzen() {
		
		G.sitzt = true;
		grozi.callbackFunc = null;
	}
	
	private function checkForStucking() {
		
		if (collide("schatten", this.x, this.y) != null) {
			
			var Bernd:Entity = collide("schatten", this.x, this.y);
			Bernd.stuckSolve("mori", 2, 6);
		}
		else checkStuckSchat = false;
	} 
	
	private function spritesheet() {
		
		//1
			grozi.add("stehenW", [0, 1], 1, true);
			grozi.add("gehenW", [2, 3, 4, 5, 6, 7, 8, 9], 10, true);
			grozi.add("rennenW", [2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			grozi.add("knockW", [10, 11, 12, 13, 14, 15, 16, 17, 18], 10, false);
			grozi.add("setzenW", [19, 20, 21, 22, 23, 24, 25, 26], 10, false);
			grozi.add("sitzenW", [27, 28], 1, true);
			
			grozi.add("stehenO", [31, 32], 1, true);
			grozi.add("gehenO", [33, 34, 35, 36, 37, 38, 39, 40], 10, true);
			grozi.add("rennenO", [33, 34, 35, 36, 37, 38, 39, 40], 16, true);
			grozi.add("knockO", [41, 42, 43, 44, 45, 46, 47, 48, 49], 10, false);
			grozi.add("setzenO", [50, 51, 52, 53, 54, 55, 56, 57], 10, false);
			grozi.add("sitzenO", [58, 59], 1, true);
			
			grozi.add("stehenS", [62, 63], 1, true);
			grozi.add("gehenS", [64, 65, 66, 67, 68, 69, 70, 71], 10, true);
			grozi.add("rennenS", [64, 65, 66, 67, 68, 69, 70, 71], 16, true);
			grozi.add("knockS", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, false);
			grozi.add("setzenS", [82, 83, 84, 85, 86, 87, 88, 89], 10, false);
			grozi.add("sitzenS", [90, 91], 1, true);
			
			grozi.add("stehenN", [93, 94], 1, true);
			grozi.add("gehenN", [95, 96, 97, 98, 99, 100, 101, 102], 10, true);
			grozi.add("rennenN", [95, 96, 97, 98, 99, 100, 101, 102], 16, true);
			grozi.add("knockN", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112], 10, false);
			grozi.add("setzenN", [113, 114, 115, 116, 117, 118, 119, 120], 10, false);
			grozi.add("sitzenN", [121, 122], 1, true);
			
			grozi.add("schlagen", [ 29, 30, 60, 61, 29, 30, 60, 61], 25, false);		
			
		//2
			grozi.add("stehenW_2", [124, 125], 1, true);
			grozi.add("gehenW_2", [126, 127, 128, 129, 130, 131, 132, 133], 10, true);
			grozi.add("rennenW_2", [126, 127, 128, 129, 130, 131, 132, 133], 16, true);
			grozi.add("knockW_2", [134, 135, 136, 137, 138, 139, 140, 141, 142], 10, false);
			grozi.add("setzenW_2", [143, 144, 145, 146, 147, 148, 149, 150], 10, false);
			grozi.add("sitzenW_2", [151, 152], 1, true);
			
			grozi.add("stehenO_2", [155, 156], 1, true);
			grozi.add("gehenO_2", [157, 158, 159, 160, 161, 162, 163, 164], 10, true);
			grozi.add("rennenO_2", [157, 158, 159, 160, 161, 162, 163, 164], 16, true);
			grozi.add("knockO_2", [165, 166, 167, 168, 169, 170, 171, 172, 173], 10, false);
			grozi.add("setzenO_2", [174, 175, 176, 177, 178, 179, 180, 181], 10, false);
			grozi.add("sitzenO_2", [182, 183], 1, true);
			
			grozi.add("stehenS_2", [186, 187], 1, true);
			grozi.add("gehenS_2", [188, 189, 190, 191, 192, 193, 194, 195], 10, true);
			grozi.add("rennenS_2", [188, 189, 190, 191, 192, 193, 194, 195], 16, true);
			grozi.add("knockS_2", [196, 197, 198, 199, 200, 201, 202, 203, 204, 205], 10, false);
			grozi.add("setzenS_2", [206, 207, 208, 209, 210, 211, 212, 213], 10, false);
			grozi.add("sitzenS_2", [214, 215], 1, true);
			
			grozi.add("stehenN_2", [217, 218], 1, true);
			grozi.add("gehenN_2", [219, 220, 221, 222, 223, 224, 225, 226], 10, true);
			grozi.add("rennenN_2", [219, 220, 221, 222, 223, 224, 225, 226], 16, true);
			grozi.add("knockN_2", [227, 228, 229, 230, 231, 232, 233, 234, 235, 236], 10, false);
			grozi.add("setzenN_2", [237, 238, 239, 240, 241, 242, 243, 244], 10, false);
			grozi.add("sitzenN_2", [245, 246], 1, true);
			
			grozi.add("schlagen_2", [ 153, 154, 184, 185, 153, 154, 184, 185], 25, false);			
			
		//3
			grozi.add("stehenW_3", [248, 249], 1, true);
			grozi.add("gehenW_3", [250, 251, 252, 253, 254, 255, 256, 257], 10, true);
			grozi.add("rennenW_3", [250, 251, 252, 253, 254, 255, 256, 257], 16, true);
			grozi.add("knockW_3", [258, 259, 260, 261, 262, 263, 264, 265, 266], 10, false);
			grozi.add("setzenW_3", [267, 268, 269, 270, 271, 272, 273, 274], 10, false);
			grozi.add("sitzenW_3", [275, 276], 1, true);
			
			grozi.add("stehenO_3", [279, 280], 1, true);
			grozi.add("gehenO_3", [281, 282, 283, 284, 285, 286, 287, 288], 10, true);
			grozi.add("rennenO_3", [281, 282, 283, 284, 285, 286, 287, 288], 16, true);
			grozi.add("knockO_3", [289, 290, 291, 292, 293, 294, 295, 296, 297], 10, false);
			grozi.add("setzenO_3", [298, 299, 300, 301, 302, 303, 304, 305], 10, false);
			grozi.add("sitzenO_3", [306, 307], 1, true);
			
			grozi.add("stehenS_3", [310, 311], 1, true);
			grozi.add("gehenS_3", [312, 313, 314, 315, 316, 317, 318, 319], 10, true);
			grozi.add("rennenS_3", [312, 313, 314, 315, 316, 317, 318, 319], 16, true);
			grozi.add("knockS_3", [320, 321, 322, 323, 324, 325, 326, 327, 328, 329], 10, false);
			grozi.add("setzenS_3", [330, 331, 332, 333, 334, 335, 336, 337], 10, false);
			grozi.add("sitzenS_3", [338, 339], 1, true);
			
			grozi.add("stehenN_3", [341, 342], 1, true);
			grozi.add("gehenN_3", [343, 344, 345, 346, 347, 348, 349, 350], 10, true);
			grozi.add("rennenN_3", [343, 344, 345, 346, 347, 348, 349, 350], 16, true);
			grozi.add("knockN_3", [351, 352, 353, 354, 355, 356, 357, 358, 359, 360], 10, false);
			grozi.add("setzenN_3", [361, 362, 363, 364, 365, 366, 367, 368], 10, false);
			grozi.add("sitzenN_3", [369, 370], 1, true);
			
			grozi.add("schlagen_3", [277, 278, 308, 309, 277, 278, 308, 309], 25, false);			
			
		//4
			grozi.add("stehenW_4", [372, 373], 1, true);
			grozi.add("gehenW_4", [374, 375, 376, 377, 378, 379, 380, 381], 10, true);
			grozi.add("rennenW_4", [374, 375, 376, 377, 378, 379, 380, 381], 16, true);
			grozi.add("knockW_4", [382, 383, 384, 385, 386, 387, 388, 389, 390], 10, false);
			grozi.add("setzenW_4", [391, 392, 393, 394, 395, 396, 397, 398], 10, false);
			grozi.add("sitzenW_4", [399, 400], 1, true);
			
			grozi.add("stehenO_4", [403, 404], 1, true);
			grozi.add("gehenO_4", [405, 406, 407, 408, 409, 410, 411, 412], 10, true);
			grozi.add("rennenO_4", [405, 406, 407, 408, 409, 410, 411, 412], 16, true);
			grozi.add("knockO_4", [413, 414, 415, 416, 417, 418, 419, 420, 421], 10, false);
			grozi.add("setzenO_4", [422, 423, 424, 425, 426, 427, 428, 429], 10, false);
			grozi.add("sitzenO_4", [430, 431], 1, true);
			
			grozi.add("stehenS_4", [434, 435], 1, true);
			grozi.add("gehenS_4", [436, 437, 438, 439, 440, 441, 442, 443], 10, true);
			grozi.add("rennenS_4", [436, 437, 438, 439, 440, 441, 442, 443], 16, true);
			grozi.add("knockS_4", [444, 445, 446, 447, 448, 449, 450, 451, 452, 453], 10, false);
			grozi.add("setzenS_4", [454, 455, 456, 457, 458, 459, 460, 461], 10, false);
			grozi.add("sitzenS_4", [462, 463], 1, true);
			
			grozi.add("stehenN_4", [465, 466], 1, true);
			grozi.add("gehenN_4", [467, 468, 469, 470, 471, 472, 473, 474], 10, true);
			grozi.add("rennenN_4", [467, 468, 469, 470, 471, 472, 473, 474], 16, true);
			grozi.add("knockN_4", [475, 476, 477, 478, 479, 480, 481, 482, 483, 484], 10, false);
			grozi.add("setzenN_4", [485, 486, 487, 488, 489, 490, 491, 492], 10, false);
			grozi.add("sitzenN_4", [493, 494], 1, true);
			
			grozi.add("schlagen_4", [401, 402, 432, 433, 401, 402, 432, 433], 25, false);		
			
		//5
			grozi.add("stehenW_5", [496, 497], 1, true);
			grozi.add("gehenW_5", [498, 499, 500, 501, 502, 503, 504, 505], 10, true);
			grozi.add("rennenW_5", [498, 499, 500, 501, 502, 503, 504, 505], 16, true);
			grozi.add("knockW_5", [506, 507, 508, 509, 510, 511, 512, 513, 514], 10, false);
			grozi.add("setzenW_5", [515, 516, 517, 518, 519, 520, 521, 522], 10, false);
			grozi.add("sitzenW_5", [523, 524], 1, true);
			
			grozi.add("stehenO_5", [527, 528], 1, true);
			grozi.add("gehenO_5", [529, 530, 531, 532, 533, 534, 535, 536], 10, true);
			grozi.add("rennenO_5", [529, 530, 531, 532, 533, 534, 535, 536], 16, true);
			grozi.add("knockO_5", [537, 538, 539, 540, 541, 542, 543, 544, 545], 10, false);
			grozi.add("setzenO_5", [546, 547, 548, 549, 550, 551, 552, 553], 10, false);
			grozi.add("sitzenO_5", [554, 555], 1, true);
			
			grozi.add("stehenS_5", [558, 559], 1, true);
			grozi.add("gehenS_5", [560, 561, 562, 563, 564, 565, 566, 567], 10, true);
			grozi.add("rennenS_5", [560, 561, 562, 563, 564, 565, 566, 567], 16, true);
			grozi.add("knockS_5", [568, 569, 570, 571, 572, 573, 574, 575, 576, 577], 10, false);
			grozi.add("setzenS_5", [578, 579, 580, 581, 582, 583, 584, 585], 10, false);
			grozi.add("sitzenS_5", [586, 587], 1, true);
			
			grozi.add("stehenN_5", [589, 590], 1, true);
			grozi.add("gehenN_5", [591, 592, 593, 594, 595, 596, 597, 598], 10, true);
			grozi.add("rennenN_5", [591, 592, 593, 594, 595, 596, 597, 598], 16, true);
			grozi.add("knockN_5", [599, 600, 601, 602, 603, 604, 605, 606, 607, 608], 10, false);
			grozi.add("setzenN_5", [609, 610, 611, 612, 613, 614, 615, 616], 10, false);
			grozi.add("sitzenN_5", [617, 618], 1, true);
			
			grozi.add("schlagen_5", [525, 526, 556, 557, 525, 526, 556, 557], 25, false);		
			
			
			
			//END
			grozi.add("humi", [586, 586, 586, 586, 586, 586, 587, 587, 587, 587, 587, 587, 586, 586, 586, 586, 586, 586, 587, 587, 587, 587, 587, 587,   620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 694, 694, 694, 694, 694, 694, 694, 694, 695, 696, 697, 698], 7, false);
			grozi.add("karotte", [699, 699, 700, 700, 701, 701, 702, 702, 703, 703, 704, 704, 705, 705, 706, 706, 707, 707], 1, false);
			
			
			
		
		//schatten
		//1
			groziSCH.add("stehenW", [0, 1], 1, true);
			groziSCH.add("gehenW", [2, 3, 4, 5, 6, 7, 8, 9], 10, true);
			groziSCH.add("rennenW", [2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			groziSCH.add("knockW", [10, 11, 12, 13, 14, 15, 16, 17, 18], 10, false);
			groziSCH.add("setzenW", [19, 20, 21, 22, 23, 24, 25, 26], 10, false);
			groziSCH.add("sitzenW", [27, 28], 1, true);
			
			groziSCH.add("stehenO", [ 31, 32], 1, true);
			groziSCH.add("gehenO", [33, 34, 35, 36, 37, 38, 39, 40], 10, true);
			groziSCH.add("rennenO", [33, 34, 35, 36, 37, 38, 39, 40], 16, true);
			groziSCH.add("knockO", [41, 42, 43, 44, 45, 46, 47, 48, 49], 10, false);
			groziSCH.add("setzenO", [50, 51, 52, 53, 54, 55, 56, 57], 10, false);
			groziSCH.add("sitzenO", [58, 59], 1, true);
			
			groziSCH.add("stehenS", [62, 63], 1, true);
			groziSCH.add("gehenS", [64, 65, 66, 67, 68, 69, 70, 71], 10, true);
			groziSCH.add("rennenS", [64, 65, 66, 67, 68, 69, 70, 71], 16, true);
			groziSCH.add("knockS", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, false);
			groziSCH.add("setzenS", [82, 83, 84, 85, 86, 87, 88, 89], 10, false);
			groziSCH.add("sitzenS", [90, 91], 1, true);
			
			groziSCH.add("stehenN", [93, 94], 1, true);
			groziSCH.add("gehenN", [95, 96, 97, 98, 99, 100, 101, 102], 10, true);
			groziSCH.add("rennenN", [95, 96, 97, 98, 99, 100, 101, 102], 16, true);
			groziSCH.add("knockN", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112], 10, false);
			groziSCH.add("setzenN", [113, 114, 115, 116, 117, 118, 119, 120], 10, false);
			groziSCH.add("sitzenN", [121, 122], 1, true);
			
			groziSCH.add("schlagen", [ 29, 30, 60, 61, 29, 30, 60, 61], 25, false);	
		 
		//2
			groziSCH.add("stehenW_2", [0, 1], 1, true);
			groziSCH.add("gehenW_2", [2, 3, 4, 5, 6, 7, 8, 9], 10, true);
			groziSCH.add("rennenW_2", [2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			groziSCH.add("knockW_2", [10, 11, 12, 13, 14, 15, 16, 17, 18], 10, false);
			groziSCH.add("setzenW_2", [19, 20, 21, 22, 23, 24, 25, 26], 10, false);
			groziSCH.add("sitzenW_2", [27, 28], 1, true);
			
			groziSCH.add("stehenO_2", [ 31, 32], 1, true);
			groziSCH.add("gehenO_2", [33, 34, 35, 36, 37, 38, 39, 40], 10, true);
			groziSCH.add("rennenO_2", [33, 34, 35, 36, 37, 38, 39, 40], 16, true);
			groziSCH.add("knockO_2", [41, 42, 43, 44, 45, 46, 47, 48, 49], 10, false);
			groziSCH.add("setzenO_2", [50, 51, 52, 53, 54, 55, 56, 57], 10, false);
			groziSCH.add("sitzenO_2", [58, 59], 1, true);
			
			groziSCH.add("stehenS_2", [62, 63], 1, true);
			groziSCH.add("gehenS_2", [64, 65, 66, 67, 68, 69, 70, 71], 10, true);
			groziSCH.add("rennenS_2", [64, 65, 66, 67, 68, 69, 70, 71], 16, true);
			groziSCH.add("knockS_2", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, false);
			groziSCH.add("setzenS_2", [82, 83, 84, 85, 86, 87, 88, 89], 10, false);
			groziSCH.add("sitzenS_2", [90, 91], 1, true);
			
			groziSCH.add("stehenN_2", [93, 94], 1, true);
			groziSCH.add("gehenN_2", [95, 96, 97, 98, 99, 100, 101, 102], 10, true);
			groziSCH.add("rennenN_2", [95, 96, 97, 98, 99, 100, 101, 102], 16, true);
			groziSCH.add("knockN_2", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112], 10, false);
			groziSCH.add("setzenN_2", [113, 114, 115, 116, 117, 118, 119, 120], 10, false);
			groziSCH.add("sitzenN_2", [121, 122], 1, true);
			
			groziSCH.add("schlagen_2", [ 29, 30, 60, 61, 29, 30, 60, 61], 25, false);			 
		 
		//3
			groziSCH.add("stehenW_3", [0, 1], 1, true);
			groziSCH.add("gehenW_3", [2, 3, 4, 5, 6, 7, 8, 9], 10, true);
			groziSCH.add("rennenW_3", [2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			groziSCH.add("knockW_3", [10, 11, 12, 13, 14, 15, 16, 17, 18], 10, false);
			groziSCH.add("setzenW_3", [19, 20, 21, 22, 23, 24, 25, 26], 10, false);
			groziSCH.add("sitzenW_3", [27, 28], 1, true);
			
			groziSCH.add("stehenO_3", [ 31, 32], 1, true);
			groziSCH.add("gehenO_3", [33, 34, 35, 36, 37, 38, 39, 40], 10, true);
			groziSCH.add("rennenO_3", [33, 34, 35, 36, 37, 38, 39, 40], 16, true);
			groziSCH.add("knockO_3", [41, 42, 43, 44, 45, 46, 47, 48, 49], 10, false);
			groziSCH.add("setzenO_3", [50, 51, 52, 53, 54, 55, 56, 57], 10, false);
			groziSCH.add("sitzenO_3", [58, 59], 1, true);
			
			groziSCH.add("stehenS_3", [62, 63], 1, true);
			groziSCH.add("gehenS_3", [64, 65, 66, 67, 68, 69, 70, 71], 10, true);
			groziSCH.add("rennenS_3", [64, 65, 66, 67, 68, 69, 70, 71], 16, true);
			groziSCH.add("knockS_3", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, false);
			groziSCH.add("setzenS_3", [82, 83, 84, 85, 86, 87, 88, 89], 10, false);
			groziSCH.add("sitzenS_3", [90, 91], 1, true);
			
			groziSCH.add("stehenN_3", [93, 94], 1, true);
			groziSCH.add("gehenN_3", [95, 96, 97, 98, 99, 100, 101, 102], 10, true);
			groziSCH.add("rennenN_3", [95, 96, 97, 98, 99, 100, 101, 102], 16, true);
			groziSCH.add("knockN_3", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112], 10, false);
			groziSCH.add("setzenN_3", [113, 114, 115, 116, 117, 118, 119, 120], 10, false);
			groziSCH.add("sitzenN_3", [121, 122], 1, true);
			
			groziSCH.add("schlagen_3", [ 29, 30, 60, 61, 29, 30, 60, 61], 25, false);	
			
		//4
			groziSCH.add("stehenW_4", [0, 1], 1, true);
			groziSCH.add("gehenW_4", [2, 3, 4, 5, 6, 7, 8, 9], 10, true);
			groziSCH.add("rennenW_4", [2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			groziSCH.add("knockW_4", [10, 11, 12, 13, 14, 15, 16, 17, 18], 10, false);
			groziSCH.add("setzenW_4", [19, 20, 21, 22, 23, 24, 25, 26], 10, false);
			groziSCH.add("sitzenW_4", [27, 28], 1, true);
			
			groziSCH.add("stehenO_4", [ 31, 32], 1, true);
			groziSCH.add("gehenO_4", [33, 34, 35, 36, 37, 38, 39, 40], 10, true);
			groziSCH.add("rennenO_4", [33, 34, 35, 36, 37, 38, 39, 40], 16, true);
			groziSCH.add("knockO_4", [41, 42, 43, 44, 45, 46, 47, 48, 49], 10, false);
			groziSCH.add("setzenO_4", [50, 51, 52, 53, 54, 55, 56, 57], 10, false);
			groziSCH.add("sitzenO_4", [58, 59], 1, true);
			
			groziSCH.add("stehenS_4", [62, 63], 1, true);
			groziSCH.add("gehenS_4", [64, 65, 66, 67, 68, 69, 70, 71], 10, true);
			groziSCH.add("rennenS_4", [64, 65, 66, 67, 68, 69, 70, 71], 16, true);
			groziSCH.add("knockS_4", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, false);
			groziSCH.add("setzenS_4", [82, 83, 84, 85, 86, 87, 88, 89], 10, false);
			groziSCH.add("sitzenS_4", [90, 91], 1, true);
			
			groziSCH.add("stehenN_4", [93, 94], 1, true);
			groziSCH.add("gehenN_4", [95, 96, 97, 98, 99, 100, 101, 102], 10, true);
			groziSCH.add("rennenN_4", [95, 96, 97, 98, 99, 100, 101, 102], 16, true);
			groziSCH.add("knockN_4", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112], 10, false);
			groziSCH.add("setzenN_4", [113, 114, 115, 116, 117, 118, 119, 120], 10, false);
			groziSCH.add("sitzenN_4", [121, 122], 1, true);
			
			groziSCH.add("schlagen_4", [ 29, 30, 60, 61, 29, 30, 60, 61], 25, false);	
			
		//5
			groziSCH.add("stehenW_5", [0, 1], 1, true);
			groziSCH.add("gehenW_5", [2, 3, 4, 5, 6, 7, 8, 9], 10, true);
			groziSCH.add("rennenW_5", [2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			groziSCH.add("knockW_5", [10, 11, 12, 13, 14, 15, 16, 17, 18], 10, false);
			groziSCH.add("setzenW_5", [19, 20, 21, 22, 23, 24, 25, 26], 10, false);
			groziSCH.add("sitzenW_5", [27, 28], 1, true);
			
			groziSCH.add("stehenO_5", [ 31, 32], 1, true);
			groziSCH.add("gehenO_5", [33, 34, 35, 36, 37, 38, 39, 40], 10, true);
			groziSCH.add("rennenO_5", [33, 34, 35, 36, 37, 38, 39, 40], 16, true);
			groziSCH.add("knockO_5", [41, 42, 43, 44, 45, 46, 47, 48, 49], 10, false);
			groziSCH.add("setzenO_5", [50, 51, 52, 53, 54, 55, 56, 57], 10, false);
			groziSCH.add("sitzenO_5", [58, 59], 1, true);
			
			groziSCH.add("stehenS_5", [62, 63], 1, true);
			groziSCH.add("gehenS_5", [64, 65, 66, 67, 68, 69, 70, 71], 10, true);
			groziSCH.add("rennenS_5", [64, 65, 66, 67, 68, 69, 70, 71], 16, true);
			groziSCH.add("knockS_5", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, false);
			groziSCH.add("setzenS_5", [82, 83, 84, 85, 86, 87, 88, 89], 10, false);
			groziSCH.add("sitzenS_5", [90, 91], 1, true);
			
			groziSCH.add("stehenN_5", [93, 94], 1, true);
			groziSCH.add("gehenN_5", [95, 96, 97, 98, 99, 100, 101, 102], 10, true);
			groziSCH.add("rennenN_5", [95, 96, 97, 98, 99, 100, 101, 102], 16, true);
			groziSCH.add("knockN_5", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112], 10, false);
			groziSCH.add("setzenN_5", [113, 114, 115, 116, 117, 118, 119, 120], 10, false);
			groziSCH.add("sitzenN_5", [121, 122], 1, true);
			
			groziSCH.add("schlagen_5", [ 29, 30, 60, 61, 29, 30, 60, 61], 25, false);			 
	}

	
	//Grafik
	public var grozi:Spritemap				= new Spritemap("graphics/enties/grozsprite2.png", 45, 70);
	public var groziSCH:Spritemap			= new Spritemap("graphics/enties/grozspriteSCH.png", 45, 70);
	
	private var sitzt:Bool = false;
}