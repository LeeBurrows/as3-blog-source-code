/**
 * Particle6.as by Lee Burrows
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
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	public class Particle6 extends Shape
	{
		private var velocity:Vector3D;

		private var rotationSpeed:Number;

		public function Particle6()
		{
			super();
			init();
		}
		
		public function init():void
		{
			//set random x, y and z
			x = Math.random()*300;
			y = Math.random()*300;
			z = Math.random()*6000;
			//set velocity pointing towards viewer (ie: z only)
			velocity = new Vector3D(0, 0, -10);
			//set random rotation speed
			rotationSpeed = 5+Math.random()*10;
			if (Math.random()<0.5)
				rotationSpeed = -rotationSpeed;
			//draw a square (the x,y offset gives the twisty look when rotated)
			graphics.beginFill(0x00FF00);
			graphics.drawRect(3, 3, 3, 3);
			graphics.endFill();
		}
		
		public function update():void
		{
			//update rotation
			rotation += rotationSpeed;
			//update position
			z += velocity.z;
			//if close to viewer, restart
			if (z<-1000)
			{
				//reset position
				x = Math.random()*300;
				y = Math.random()*300;
				z = 5000;
			}
			//set brightness based on z distance
			var brightnesFactor:Number = 500/(500+z);
			transform.colorTransform = new ColorTransform(brightnesFactor, brightnesFactor, brightnesFactor);
		}

	}
}