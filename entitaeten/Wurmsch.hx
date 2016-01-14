package entitaeten;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import welten.Mutterwelt;

class Wurmsch extends Entity
{

	public function new(x:Float = 0, y:Float = 0) {
		
		super(x, y);
	}
	
	override public function added() {
		
		super.added();
		
		graphic = gesicht;
		
		gesicht.add("schauen", [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2 , 1], 8, true);
		gesicht.add("hello", [5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 10, false);
		gesicht.add("ciao", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32], 19, false);
		gesicht.add("versteck", [32], 1, true);
		
		layer = -Std.int(this.y);
		gerani = "hello";
		gesicht.callbackFunc = genughallo;
		
		type = "wurm";
	}
	
	override public function update() {
		
		super.update();
		
		wastun();
		
		gesicht.play(gerani);		
	}
	
	private function wastun() {
		
		morii = cast(scene, Mutterwelt)._mori;
		distanz = HXP.distance(this.x, this.y, morii.x, morii.y);
		
		if (distanz > 100 && gerani == "schauen") {
			
			gesicht.callbackFunc = genuggeschaut;
		}
		else if (distanz <= 30) {
			
			if (gerani == "hello") {
				
				gesicht.callbackFunc = verstecken;
			}
			else if (gerani == "schauen") {
				
				gerani = "ciao";
				gesicht.callbackFunc = versteckt;
			}
		}
		else if (distanz > 30 && distanz <= 100) {
			
			if (gerani == "versteck") {
				
				gerani = "hello";
				gesicht.callbackFunc = genughallo;
			}
		}
	}
	
	private function genughallo() {
		
		gerani = "schauen";
		gesicht.callbackFunc = null;
	}
	
	private function genuggeschaut() {
		
		gerani = "ciao";
		gesicht.callbackFunc = genugistgenug;
	}
	
	private function verstecken() {
		
		gerani = "ciao";
		gesicht.callbackFunc = versteckt;
	}
	
	private function versteckt() {
		
		gerani = "versteck";
	}
	
	private function genugistgenug() {
		
		HXP.scene.remove(this);
	}
	
	private var gesicht:Spritemap = new Spritemap("graphics/malerei/wurmelsprite.png", 9, 12);
	private var gerani:String;
	private var distanz:Float;
	private var morii:Entity;
}