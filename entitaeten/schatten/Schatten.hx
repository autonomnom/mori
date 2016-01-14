package entitaeten.schatten;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import entitaeten.spielbare.Faust;
import openfl.geom.Point;
import entitaeten.spielbare.Morikkel;
import com.haxepunk.utils.Input; 
import com.haxepunk.utils.Key;
import welten.Mutterwelt;

class Schatten extends Entity
{
	public function new(x:Float = 0, y:Float = 0 ) {
		
		super(x,y);
	}
	
	override public function added() {
		
		super.added();
		
		type = "schatten";
		
		startwinkel = Math.random() * Math.PI;
		
		//stuckChecking = true;			// Grid Stuck Check (still necessary?)
	}
	
	override public function update() {
		
		super.update();
		
		mori = cast(HXP.scene.nearestToEntity("mori", this), Morikkel);
		
		if (spe.length > maxSpeed) {
			
			spe.normalize(maxSpeed);
		}
		
		geschwindX = spe.x * bes * fri * HXP.elapsed;
		geschwindY = spe.y * bes * fri * HXP.elapsed;
		
		//run run run
		if (!sitzend) {
			
			moveBy(geschwindX, geschwindY, ["mori", "solid", "faust", "schatten", "interesting"], true); 
		}
		
		welchesverhalten();
		nonMoveCollision();
	}
	
	private function nonMoveCollision() {
		
		if (collide("mori", x, y) != null) {
			
			
			if (mori.ren != 1) {
				
				// HP vom Schatten
				if (HPP > 0) {
					
					--HPP;
				} else {
					
					HXP.scene.remove(this);
					--G.mlvl;
				}	
				
				// Moris Schattenpunkte
				if (mori.SP == mori.SPmax && G.newborn <= 0) {
					mori.GG = true;
				}
				else if (mori.SP != mori.SPmax) {
					mori.SP += 2;
				}
				
				mori.knock = 60;
			}
		}		
	}
	
	override public function moveCollideX(e:Entity):Bool {
		
		if (e.type == "solid") {
			
			//kehrtwende für wandern
			if (vg == 0) {
				
				bes = -bes;
			}
			
			return true;
		} 
		else if (e.type == "interesting") {
			
			return true;
		}
		else if (e.type == "mori") {
			
			if (G.sitzt && !mori.genuggehoert) { return true; }
			else if (G.sitzt && mori.genuggehoert) { verhalten(2); return true; }
			else if (mori.steht) { 		//damit knockback auch getriggert wird obwohl moveCollide in der mori class nicht getriggert wurde 
				
				mori.anne = HXP.angle(e.x, e.y, this.x, this.y);
				mori.anne = mori.anne * Math.PI / 180;
				
				if (mori.name != "lysop" && mori.ren != 1) {	
					
					mori.knock = 60;				
				}
				
				verhalten(2);
				return true;
			}
			else { verhalten(2); return true; }
		}
		else if (e.type == "faust") {
			
			var moriwi:Float = HXP.angle(this.x, this.y, mori.x, mori.y);
			moriwi *= Math.PI / 180;
			moveBy( -Math.cos(moriwi) * 40, Math.sin(moriwi) * 40, ["solid"], true);
			
			var faust:Faust = cast(HXP.scene.nearestToEntity("faust", this), Faust);	
			if (faust.onehit && !hitten) {
				
				// HP vom Schatten
				if (HPP > 0) {
					
					--HPP;
				} else {
					
					HXP.scene.remove(this);
					--G.mlvl;
				}	
				
				// Moris Schattenpunkte
				if (mori.SP == mori.SPmax && G.newborn <= 0) {
					mori.GG = true;
				}
				else if (mori.SP != mori.SPmax) {
					mori.SP += 2;
				}
				
				// damit es pro faust nur einmal getriggert wird
				faust.onehit = false;
				hitten = true;
			}
			
			verhalten(2);
			return true;
		}
		else return false; 
	}
	
	override public function moveCollideY(e:Entity):Bool {
		
		if (e.type == "solid") {
			
			//kehrtwende für wandern
			if (vg == 0) {
				
				bes = -bes;
			}
			
			return true;
		} 
		else if (e.type == "interesting") {
			
			return true;
		}
		else if (e.type == "mori") {
			
			if (G.sitzt && !mori.genuggehoert) { return true; }
			else if (G.sitzt && mori.genuggehoert) { verhalten(2); return true; }
			else if (mori.steht) { 		//damit knockback auch getriggert wird obwohl moveCollide in der mori class nicht getriggert wurde 
				
				mori.anne = HXP.angle(e.x, e.y, this.x, this.y);
				mori.anne = mori.anne * Math.PI / 180;
				
				if (mori.name != "lysop" && mori.ren != 1) {	
					
					mori.knock = 60;				
				}
				
				verhalten(2);
				return true;
			}
			else { verhalten(2); return true; }
		}
		else if (e.type == "faust") {
			
			var moriwi:Float = HXP.angle(this.x, this.y, mori.x, mori.y);
			moriwi *= Math.PI / 180;
			moveBy( -Math.cos(moriwi) * 40, Math.sin(moriwi) * 40, ["solid"], true);
			
			var faust:Faust = cast(HXP.scene.nearestToEntity("faust", this), Faust);	
			if (faust.onehit && !hitten) {
				
				// HP vom Schatten
				if (HPP > 0) {
					
					--HPP;
				} else {
					
					HXP.scene.remove(this);
					--G.mlvl;
				}	
				
				// Moris Schattenpunkte
				if (mori.SP == mori.SPmax && G.newborn <= 0) {
					mori.GG = true;
				}
				else if (mori.SP != mori.SPmax) {
					mori.SP += 2;
				}
				
				// damit es pro faust nur einmal getriggert wird
				faust.onehit = false;
				hitten = true;
			}
			
			verhalten(2);
			return true;
		}
		else return false;
	}
	
	private function welchesverhalten() {
		
		if (mori != null) { 
			
			var akdis:Float = HXP.distance(mori.x, mori.y, this.x, this.y);
			
			/**	Damit die schatten wissen, was zu tun ist.
			 * * * * Manchmal nach dem erzählen, verfolgen sie mori vernarrt. Got to be fixed! 
			 * * * * FAILED: erster versuch: flüchten an erste stelle, anstatt wandern -> verfolgen!
			 * * * * FAILED: zweiter versuch: mehr bools und reihenfolge geändert. erzählen höhere priorität.
			 * * * * dritter versuch: '''PROBLEM scheint GELÖST'''
			 */
			
			// lysop fliegt davon
			if (mori.name == "lysop" && G.schwebt) { verhalten(0);	}
			
			// -> erzählen
			else if (akdis < 500 && G.sitzt && !mori.genuggehoert) { verhalten(1); }
			
			// -> flüchten nach erzählen
			else if (akdis < 500 && G.sitzt && mori.genuggehoert) { verhalten(2); }	
			
			// flüchten
			else if (akdis <= 300 && folgflucht && !G.sitzt) { verhalten(2); }	
			
			// flüchten -> wandern
			else if (akdis > 300 && folgflucht) { verhalten(0); folgflucht = false; }
			
			// wandern -> verfolgen
			else if (akdis <= 100 && !folgflucht && !G.sitzt) { verhalten(3); }	
			
			// - > wandern
			else if (akdis >= 500) { verhalten(0); }	
			
			// rest
			else { verhalten(0); }
			
			
			
			// nicht mehr erzählen
			if (!G.sitzt) { scherzaehlt = false; } 											// weg?
		} 
		else {
			
			verhalten(0); 
		}	
		
		if (geschwindX > 0 && geschwindX > geschwindY && geschwindX > -geschwindY) { richtung = 2; }		// OST
		if (geschwindX < 0 && geschwindX < geschwindY && geschwindX < -geschwindY) { richtung = 4; }		// WEST
		if (geschwindY > 0 && geschwindY > geschwindX && geschwindY > -geschwindX) { richtung = 3; }		// SUD
		if (geschwindY < 0 && geschwindY < geschwindX && geschwindY < -geschwindX) { richtung = 1; }		// NORD
	}
	
	/**
	 * Schattenverhalten.
	 * @param	v	wie soll sich der schatten jetzt verhalten?
	 * 
	 * 			0	Wandern
	 * 			1	Erzählen
	 * 			2	Fluechten
	 * 			3	Verfolgen
	 */
	public function verhalten(v:Int = 0) {
		
		/**
		 * 	zum abfragen aus anderen klassen
		 * 	vg - public
		 */
		vg = v;											
		
		/**
		 * 	Leitsystem
		 */
		if (v == 0) {
			
			wandern();
		}
		else if (v == 1) {
			
			erzaehlen();
			sitzend = false;
		}
		else if (v == 2) {
			
			fluechten();
			folgflucht = true;
			sitzend = false;
		}
		else if (v == 3) {
			
			verfolgen();
			sitzend = false;
		}
		else v = 0;
	}
	
	
	private function wandern() {
		
		/** Rhythmus von Sitzen/Wandern
		 * 	+ wird durch ne if in der update() geregelt. #moveBy
		 * 	+ Grafik wird in den tochterschatten geregelt.
		 */
		if (sitzend) {
			if (sitztimer <= 20) {
				sitztimer += HXP.elapsed;
			}
			else {
				sitzend = false;
				sitztimer = 0;
			}
		}
		else {
			if (sitztimer <= 25) {
				sitztimer += HXP.elapsed;
			}
			else {
				sitzend = true;
				sitztimer = 0;
			}
		}
		
		/**	Winkelveränderung
		 * 	winkeltimer ist für ein rhytmisches wandeln des winkel.
		 * 	0 - winkelanker1 	taumeln in eine richtung
		 * 	- winkelanker2		chance auf stärkere aenderung
		 * 	leftright 			entscheided in welche richtung der stärkere wandel sich orientiert
		 */
		if (winkeltimer > winkelanker1 && winkeltimer <= winkelanker2) { 
			++winkeltimer; 
			startwinkel += Math.random() * winkelaend * leftright; 
		}
		else if ( winkeltimer > winkelanker2) { 
			winkeltimer = 0; 
			winkelanker1 = Math.random() * 200 + 200;
			winkelanker2 = winkelanker1 + 150;
			leftright = Math.random();
			if (leftright > 0.5) { leftright = 1; }
			else if (leftright < 0.5) { leftright = -1; }	
		}
		else if (winkeltimer >= 0 && winkeltimer <= winkelanker1) { 
			++winkeltimer;
			startwinkel += Math.random() * winkelaend - winkelaend * 0.5;
		}
		
		//die original beschleunigung wieder herstellen
		bes = _bes;
		
		//Hypothenuse
		hypo.x = 1;
		hypo.y = 0;
		var hyp:Float = hypo.length; 
		
		//Richtung berechnen
		schaspe.x = Math.sin(startwinkel) * hyp;
		schaspe.y = -Math.cos(startwinkel) * hyp;
		
		//Anwenden
		if (sitzend) {
			
			spe.x += 0;
			spe.y += 0;			
		} else {
			
			spe.x += schaspe.x;
			spe.y += schaspe.y;		
		}
	}
	
	private function erzaehlen() {
		
		// Speichern der ursprünglichen Beschleunigung
		if (bessave) { _bes = bes; bes = 20; bessave = false; }		// speichert die alte beschleunigung und setzt die aktuelle auf ne gemütliche (fürs langsamer werden)
		
		// Brauch einen Anlaufpunkt,
		// muss gesetzt werden wenn die Erzählfuntion initiiert wird.
		dimosa = HXP.distance(G.MoriSitzt.x, G.MoriSitzt.y, this.x, this.y); //HXP.distanceRects(mori.originX, mori.originY, mori.width, mori.height, this.originX, this.originY, this.width, this.height);
		startwinkel = HXP.angle(x, y, G.MoriSitzt.x, G.MoriSitzt.y) / 180 * Math.PI;
		
		//Richtung berechnen
		schaspe.x = Math.cos(startwinkel);
		schaspe.y = -Math.sin(startwinkel);
		
		//Anwenden
		spe.x += schaspe.x;
		spe.y += schaspe.y;		
		
		//Langsamer werden
		if (dimosa <= 150) {
			bes = Math.max(bes - dimosa / 19.9 * HXP.elapsed, 0);				// 19.9 ist für bes 20 
		}
		else bes = 20;		///// N.E.U. damit die nicht auf halber strecke schlapp machen, noch nicht ausgiebig getested
		
		//damit moveBy die collision nicht verhindert
		if (bes == 0 && collide("mori", this.x, this.y) == null && !mori.genuggehoert) {
			
			var morinexttome:Morikkel = cast(HXP.scene.nearestToEntity("mori", this), Morikkel);
			this.moveBy(Math.cos(HXP.angle(x, y, morinexttome.x, morinexttome.y) / 180 * Math.PI) * HXP.elapsed, -Math.sin(HXP.angle(x, y, morinexttome.x, morinexttome.y) / 180 * Math.PI) * HXP.elapsed, "solid");
		}
		else if (collide("mori", this.x, this.y) != null) {
			
			if (!scherzaehlt) {
				
				mori.erzaehler.push(this);
				scherzaehlt = true;
				
				//für groz --> if name == groz
				if (richtung == 1) { HXP.scene.add(new Sprechblase(this.x - 25, this.y - 35, 1, 0)); }
				if (richtung == 2) { HXP.scene.add(new Sprechblase(this.x + 10, this.y - 25, 2, 0)); }
				if (richtung == 3) { HXP.scene.add(new Sprechblase(this.x, this.y - 10, 3, 0)); }
				if (richtung == 4) { HXP.scene.add(new Sprechblase(this.x - 36, this.y -25, 4, 0)); }
			}
		}
	}
	
	private function fluechten() {
		
		//die original beschleunigung wieder herstellen
		bes = _bes;
		if (bes < 0) { bes *= -1; }
		
		//das erähler array zurücksetzen
		scherzaehlt = false;
		
		startwinkel = HXP.angle(x, y, mori.x, mori.y) / 180 * Math.PI;
		
		//Richtung berechnen
		schaspe.x = -Math.cos(startwinkel) * 2;
		schaspe.y = Math.sin(startwinkel) * 2;
		
		//Anwenden
		spe.x += schaspe.x;
		spe.y += schaspe.y;	
	}
	
	private function verfolgen() {
		
		//die original beschleunigung wieder herstellen	
		bes = _bes;
		
		startwinkel = HXP.angle(x, y, mori.x, mori.y) / 180 * Math.PI;
		
		//Richtung berechnen
		schaspe.x = Math.cos(startwinkel) * 2;
		schaspe.y = -Math.sin(startwinkel) * 2;
		
		//Anwenden
		spe.x += schaspe.x;
		spe.y += schaspe.y;		
	}
	
	
	// V
	
	private var mori:Morikkel;
	
	
	// erzählen
	public var scherzaehlt:Bool = false;

	
	// hinsetzen
	public var sitztimer:Float = 0;
	public var sitzend:Bool = false;
	
	
	// Verhalten gerade
	public var vg:Int = 0;
	private var folgflucht:Bool = false;

	
	// Geschwindigkeitmodifikator für Geschwind
	private var geschwindX:Float = 0;
	private var geschwindY:Float = 0;
	private var spe = new Point(.1,.1);
	private var schaspe = new Point();
	
	
	//stuckCheck
	public var stuckChecking:Bool = false;
	
	
	// Richtung
	public var richtung:Int = 0;
	
	public var startwinkel:Float = 0;
	public var winkelaend:Float = 1;
	private var winkeltimer:Float = 0;
	private var leftright:Float = 0;
	private var winkelanker1:Float = 200;
	private var winkelanker2:Float = 300;
	
	private var kehrtwende:Bool = false;
	private var beszaehler:Float = 0;
	public var _bes:Float = 0;
	private var bessave:Bool = true;
	
	
	// Distanz
	public var dimosa:Float = 0;
	private var hypo:Point = new Point();	

	
	//
	// Beschleunigung, muss von den Schatten geliefert werden
	public var bes:Float = 0;	
	
	// Reibung
	public var fri:Float = 0;
	
	// maxSpeed
	public var maxSpeed:Float = 0;
	
	// Lebenspunkte
	public var HPP:Int = 8;
	public var hitten:Bool = false;
}