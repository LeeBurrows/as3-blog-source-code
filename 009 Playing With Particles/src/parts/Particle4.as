/**
 * Particle4.as by Lee Burrows
 * Feb 21, 2011
 * Visit blog.leeburrows.com for more stuff
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/
package parts
{
	import flash.display.Shape;
	
	public class Particle4 extends Shape
	{
		private var velx:Number;
		private var vely:Number;
		
		private var accx:Number = 0;
		private var accy:Number = -0.1;

		private var delay:int;
		
		public function Particle4(delay:int)
		{
			super();
			this.delay = delay;
			init();
		}
		
		private function init():void
		{
			//set to center bottom of swf
			x = 150;
			y = 250;
			//set small random x velocity
			velx = 0.5*Math.random()-0.25;
			vely = 0;
			//set random size
			var size:Number = 8*Math.random();
			//clear any previous circle
			graphics.clear();
			//draw a greyscale circle
			var gry:uint = 0xFF*Math.random();
			var col:uint = gry<<16 | gry<<8 | gry;
			graphics.beginFill(col, 0.5);
			graphics.drawCircle(0, 0, size*0.5);
			graphics.endFill();
			//hide until delay passed
			visible = false;
			//reset any values altered by update()
			alpha = 1;
			scaleX = scaleY = 1;
		}
		
		public function update():void
		{
			if (--delay<0)
			{
				visible = true;
				//fade out a bit
				alpha *= 0.96;
				//scale up a bit
				scaleX *= 1.05;
				scaleY *= 1.05;
				//update velocity
				velx += accx;
				vely += accy;
				//update position
				x += velx;
				y += vely;
				//check if faded out
				if (alpha<0.01)
				{
					//if so, restart
					init();
					//and bring to front of display list
					parent.addChildAt(this, 0);
				}
			}
		}

	}
}