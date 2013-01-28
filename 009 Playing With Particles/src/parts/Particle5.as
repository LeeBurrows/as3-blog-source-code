/**
 * Particle5.as by Lee Burrows
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
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	public class Particle5 extends Shape
	{
		private var velocity:Vector3D;

		public function Particle5()
		{
			super();
			init();
		}
		
		public function init():void
		{
			//set initial position
			var angle:Number = 2*Math.PI*Math.random();
			x = 100*Math.sin(angle);
			y = 100*Math.cos(angle);
			z = 100*Math.sin(angle)*Math.cos(angle);
			//set velocity pointing at right angle to center in x and y (so particles orbit rather than fall straight in). set z randomly
			angle += Math.PI*0.5;
			velocity = new Vector3D(2*Math.sin(angle), 2*Math.cos(angle),5);
			//draw a circle with a radial gradient to enhance the 3D feel
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(5, 5, 0, -5, -5);
			graphics.clear();
			graphics.beginGradientFill(GradientType.RADIAL, [0xFFFF00, 0x666600], [1, 1], [0, 255], matrix);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
		}
		
		public function update():void
		{
			//calculate acceleration from the distance to center (modelling gravity in 3 dimensions this time)
			var gravityVector:Vector3D = new Vector3D(-x, -y, -z);
			var distanceToCenter:Number = gravityVector.normalize();
			gravityVector.scaleBy(1/distanceToCenter*distanceToCenter);
			//update velocity
			velocity.incrementBy(gravityVector);
			//update position
			x += velocity.x;
			y += velocity.y;
			z += velocity.z;
			//set brightness based on z distance
			var brightnesFactor:Number = 200/(200+z);
			transform.colorTransform = new ColorTransform(brightnesFactor, brightnesFactor, brightnesFactor);
		}

	}
}