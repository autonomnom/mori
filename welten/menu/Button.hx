package welten.menu;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import haxe.Constraints.Function;
import openfl.geom.Point;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import com.haxepunk.utils.Joystick.XBOX_GAMEPAD;

class Button extends Entity
{

	public function new(callback:Dynamic, argument:Dynamic, x:Float, y:Float) {
		
		super(x, y);
		
		_argument = argument;
		_callback = callback;
	}
	
	override public function added() {
		
		super.added();
		
		startp = new Point(this.x, this.y);
		
		//setting the wanderdirection
		var run:Float = Math.random();
		if (run <= 0.5) { O = true; }
		else { W = true; }
	}
	
	override public function update() {
		
		super.update();
		
		if (chosen) {
			
			if (Input.joystick(0).connected) {
				
				if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON) || Input.joystick(0).pressed(XBOX_GAMEPAD.X_BUTTON)) {
				 
					clicked();
				}
			}
			else if (Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE)) {
				
				clicked();
			}
			
			wandern(speed, intervall, radius);
			buttmap.color = 0x75ceef;
		}
		else {
			
			buttmap.color = 0xFFFFFF;
		}
		
		//applying button animation
		buttmap.play("leer");
	}
	
	/**
	 * Action function, triggering the clicking event.
	 * @param	_argument	is for maybe needed argument in the set callback function.
	 */
	private function clicked() {
		
		if (!_argument) {
			
			_callback();
		}
		else {
			
			_callback(_argument);
		}
	}
	
	/**
	 * Setting the graphic for the button. A-must!
	 * @param	asset	the Spritemap
	 * @param	fw		Width of a single frame.
	 * @param	fh		Height of a single frame.
	 * */
	public function setSpritemap(asset, fw:Int, fh:Int) {
		
		//init
		buttmap = new Spritemap(asset, fw, fh);
		
		//animationen
		buttmap.add("leer", [0]);
		/*	buttmap.add("clicked", [1,2,3,4], 10, true);
			buttmap.add("init", [5,6,7,8], 10, true); 	*/
		
		//applying
		graphic = buttmap;
		
		//positioning
		buttmap.x = fw * -0.5;
		buttmap.y = fh * -0.5;
		originX = Std.int(fw * 0.5);
		originY = Std.int(fh * 0.5);
		
		//setting the hitbox
		setHitbox(fw, fh, Std.int(fw * 0.5), Std.int(fh * 0.5));
	}
	
	/**
	 * Let the button wander around like a glimmering hinkypunk.
	 * @param	s	Speed.	
	 * @param	c	Interval of the changing the direction rhythm.
	 * @param	r	Radius of the allowed distance to the core-position of the button.
	 */
	private function wandern(s:Float, c:Int, r:Int) {
		
		var jetzt:Point = new Point(this.x, this.y);
		var _indicat:Float = Math.random();
		var _speed:Float = s;
		var _countermax:Int = c;
		var _radius:Int = r;
		
		if (HXP.distance(jetzt.x, jetzt.y, startp.x, startp.y) <= _radius) {
			
			if (NW == true)	{
				
				if (counter <= _countermax)	{
					
					counter++;
					this.x += _speed * HXP.elapsed;
					this.y += _speed * HXP.elapsed;
				}
				else {
					
					NW = false;
					counter = 0;
					
					if (_indicat <= 0.33) {
						
						this.x += _speed * HXP.elapsed;
						W = true;
					}
					else if (_indicat >= 0.66) {
						
						this.x += _speed * HXP.elapsed;
						this.y += _speed * HXP.elapsed;
						NW = true;
					}
					else {
						
						this.y += _speed * HXP.elapsed;
						N = true;
					}
				}
			}
			else if (N == true) {
				
				if (counter <= _countermax) {
					
					counter++;
					this.y += _speed * HXP.elapsed;
				}
				else {			
					
					N = false;
					counter = 0;
					
					if (_indicat <= 0.33) {
						
						this.x += _speed * HXP.elapsed;
						this.y += _speed * HXP.elapsed;
						NW = true;					
					}
					else if (_indicat >= 0.66) {
						
						this.y += _speed * HXP.elapsed;
						N = true;					
					}
					else  {
						
						this.x -= _speed * HXP.elapsed;
						this.y += _speed * HXP.elapsed;
						NO = true;
					}
				}
			}
			else if (NO == true) {
				
				if (counter <= _countermax) {
					
					counter++;
					this.x -= _speed * HXP.elapsed;
					this.y += _speed * HXP.elapsed;
				}
				else
				{
					NO = false;
					counter = 0;
					
					if (_indicat <= 0.33)	{
						
						this.y += _speed * HXP.elapsed;
						N = true;							
					}
					else if (_indicat >= 0.66)	{
						
						this.x -= _speed * HXP.elapsed;
						this.y += _speed * HXP.elapsed;
						NO = true;					
					}
					else {
						
						this.x -= _speed * HXP.elapsed;
						O = true;
					}
				}
			}
			else if (W == true)
			{
				if (counter <= _countermax)
				{
					counter++;
					this.x += _speed * HXP.elapsed;
				}
				else
				{
					W = false;
					counter = 0;
				
					if (_indicat <= 0.33)
					{
						this.x += _speed * HXP.elapsed;
						this.y -= _speed * HXP.elapsed;
						SW = true;							
					}
					else if (_indicat >= 0.66)
					{
						this.x += _speed * HXP.elapsed;
						W = true;					
					}
					else 
					{
						this.x += _speed * HXP.elapsed;
						this.y += _speed * HXP.elapsed;
						NW = true;
					}
				}
			}
			else if (O == true)
			{
				if (counter <= _countermax)
				{
					counter++;
					this.x -= _speed * HXP.elapsed;
				}
				else
				{
					O = false;
					counter = 0;
				
					if (_indicat <= 0.33)
					{
						this.x -= _speed * HXP.elapsed;
						this.y += _speed * HXP.elapsed;
						NO = true;							
					}
					else if (_indicat >= 0.66)
					{
						this.x -= _speed * HXP.elapsed;
						O = true;					
					}
					else 
					{
						this.x -= _speed * HXP.elapsed;
						this.y -= _speed * HXP.elapsed;
						SO = true;
					}
				}
			}
			else if (SW == true)
			{
				if (counter <= _countermax)
				{
					counter++;
					this.x += _speed * HXP.elapsed;
					this.y -= _speed * HXP.elapsed;
				}
				else
				{
					SW = false;
					counter = 0;
				
					if (_indicat <= 0.33)
					{
						this.y -= _speed * HXP.elapsed;
						S = true;
					}
					else if (_indicat >= 0.66)
					{
						this.x += _speed * HXP.elapsed;
						this.y -= _speed * HXP.elapsed;
						SW = true;
					}
					else 
					{
						this.x += _speed * HXP.elapsed;
						W = true;
					}
				}
			}
			else if (S == true)
			{
				if (counter <= _countermax)
				{
					counter++;
					this.y -= _speed * HXP.elapsed;
				}
				else
				{
					S = false;
					counter = 0;
				
					if (_indicat <= 0.33)
					{
						this.x -= _speed * HXP.elapsed;
						this.y -= _speed * HXP.elapsed;
						SO = true;
					}
					else if (_indicat >= 0.66)
					{
						this.y -= _speed * HXP.elapsed;
						S = true;
					}
					else 
					{
						this.x += _speed * HXP.elapsed;
						this.y -= _speed * HXP.elapsed;
						SW = true;
					}
				}
			}
			else if (SO == true)
				{
				if (counter <= _countermax)
				{
					counter++;
					this.x -= _speed * HXP.elapsed;
					this.y -= _speed * HXP.elapsed;
				}
				else
				{
					SO = false;
					counter = 0;
			
					if (_indicat <= 0.33)
					{
						this.x -= _speed * HXP.elapsed;
						O = true;
					}
					else if (_indicat >= 0.66)
					{
						this.x -= _speed * HXP.elapsed;
						this.y -= _speed * HXP.elapsed;
						SO = true;					
					}
					else 
					{
						this.y -= _speed * HXP.elapsed;
						S = true;					
					}
				}
			}
		}
		else {
			
			if ( NW == true) {
				
				this.x -= _speed * HXP.elapsed;
				this.y -= _speed * HXP.elapsed;
				SO = true;
				NW = false;
			}
			else if (N == true) {
				
				this.y -= _speed * HXP.elapsed;
				S = true;
				N = false;
			}
			else if (NO == true) {
				
				this.x += _speed * HXP.elapsed;
				this.y -= _speed * HXP.elapsed;
				SW = true;
				NO = false;
			}
			else if (O == true)	{
				
				this.x += _speed * HXP.elapsed;
				W = true;
				O = false;
			}
			else if (SO == true) {	
				
				this.x += _speed * HXP.elapsed;
				this.y += _speed * HXP.elapsed;
				NW = true;
				SO = false;
			}
			else if (S == true)	{
				
				this.y += _speed * HXP.elapsed;
				N = true;
				S = false;
			}
			else if (SW == true) {
				
				this.x -= _speed * HXP.elapsed;
				this.y += _speed * HXP.elapsed;
				NO = true;
				SW = false;
			}
			else if (W == true)	{
				
				this.x -= _speed * HXP.elapsed;
				O = true;
				W = false;
			}
		}		
	}
	
	//wandering
	private var startp:Point;
	private var counter:Int = 0;
	private var speed:Float = 2;
	private var intervall:Int = 22;
	private var radius:Int = 15;
	
	private var NW:Bool;
	private var N:Bool;
	private var NO:Bool;
	private var W:Bool;
	private var O:Bool;
	private var SW:Bool;
	private var S:Bool;
	private var SO:Bool;
	
	
	//general
	private var gedrueckt:Bool = false;
	public var chosen:Bool = false;
	private var buttmap:Spritemap;
	
	//callback
	private var _argument:Dynamic;	// in case the callback function needing some arguments CAN BE OF DIFFERENT TYPE (_argument:* doesn't work cause of lack in type clarification)
	private var _callback:Dynamic;//Void -> Void;
}