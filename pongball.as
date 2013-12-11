package  {
	
	import flash.ui.Mouse;
    import flash.events.MouseEvent;  
	import flash.ui.Keyboard;
    import flash.display.MovieClip;
	import flash.events.*;
	
	
	public class pongball extends MovieClip {
		var xlocal:int       = new int();
		var ylocal:int       = new int();
		var starting:Boolean = new Boolean();
		var velocity:int     = new int();
		
		var xpos:Number      = new Number();
		var ypos:Number      = new Number();
		
		var xnew: Number     = new Number();
		var ynew: Number     = new Number();
		
		var HitRight:Boolean      = new Boolean();
		
		
		
		public function pongball(xlocal, ylocal) {
			// constructor code
			this.x = xlocal;
			this.y = ylocal;
			starting = true;
			HitRight = false;
			
			
			addEventListener(Event.ENTER_FRAME,mover);

		}
		private function mover(e:Event):void {
			if (starting == true)
				this.x -= 20;
		
				this.x+= xnew;
				this.y+= ynew;
				
			
		}
		public function moveCoord(xpos, ypos): void {
			if (HitRight == false) {
				xnew = xpos;
				ynew = ypos;
				HitRight = true;
			}
			else {
		
				xnew = -xpos;
				ynew = -ypos;
				HitRight = false;
			}
				
			starting = false;
		}
		public function Bouncer(): void {
			xnew = xnew;
			ynew = -ynew
		}
	}
	
}
