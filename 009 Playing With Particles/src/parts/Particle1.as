/**
 * Particle1.as by Lee Burrows
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
	
	public class Particle1 extends Shape
	{
		private var velx:Number;
		private var vely:Number;

		public function Particle1()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//set a random position
			x = Math.random()*280;
			y = Math.random()*280;
			//set a random velocity
			velx = Math.random()*10-5;
			vely = Math.random()*10-5;
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
			//check if hitting left edge of swf
			if (x<0)
			{
				x = -x;
				velx = -velx;
			}
			//check if hitting right edge of swf
			//right edge is 300, square is 20 wide, so check against 300-20=280
			else if (x>280)
			{
				x = 280-(x-280);
				velx = -velx;
			}
			//check if hitting top edge of swf
			if (y<0)
			{
				y = -y;
				vely = -vely;
			}
			//check if hitting bottom edge of swf
			//bottom edge is 300, square is 20 high, so check against 300-20=280
			else if (y>280)
			{
				y = 280-(y-280);
				vely = -vely;
			}
		}

	}
}