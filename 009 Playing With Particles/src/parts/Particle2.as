/**
 * Particle2.as by Lee Burrows
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
	
	public class Particle2 extends Shape
	{
		private var velx:Number;
		private var vely:Number;

		public function Particle2()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//set to center of swf
			x = 150;
			y = 150;
			//set a random direction to travel
			var angle:Number = 2*Math.PI*Math.random();
			//set a random speed to travel at
			var speed:Number = 5+Math.random()*5;
			//convert direction and speed into x and y velocities
			velx = speed*Math.sin(angle);
			vely = speed*Math.cos(angle);
			//clear any previous square
			graphics.clear();
			//draw a square
			graphics.beginFill(Math.random()*0xFFFFFF);
			graphics.drawRect(0, 0, 20, 20);
			graphics.endFill();
		}
		
		public function update():void
		{
			//update position
			x += velx;
			y += vely;
			//check if passed any edge
			if (x<-20 || x>300 || y<-20 || y>300)
				//if so, restart
				init();
				//and bring to front of display list
				parent.addChild(this);
		}

	}
}