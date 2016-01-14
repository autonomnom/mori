package entitaeten.spielbare;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import openfl.display.BitmapData;
import com.haxepunk.HXP;

class Faust extends Entity
{

	public function new() {
		
		super();
		type = "faust";
	}
	
	override public function added() {
		
		super.added();
		
		// Mori
		if (G.current == 0) {
			graphic = Image.createRect(30, 30, 0x00000, 0);
			setHitbox(30, 30, 0, 0);			
		}
		// Grozi
		else if (G.current == 1) {
			
			graphic = Image.createRect(30, 30, 0x00000, 0);
			setHitbox(40, 40, 20, 20);				
		}
		
		onehit = true;
	}
	
	override public function update() {
		
		super.update();
		
		if (collide("schatten", this.x, this.y) != null) {
			
			var mori:Morikkel = cast(HXP.scene.nearestToEntity("mori", this), Morikkel);
			
			if (mori != null && onehit) {
				
				if(mori.SP == mori.SPmax) {
					
					mori.GG = true;
				}
				else {
					
					mori.SP += 2;
				}
				
				onehit = false;
			}
		}
	}
	
	public var onehit:Bool = false;			//antischmelz
}