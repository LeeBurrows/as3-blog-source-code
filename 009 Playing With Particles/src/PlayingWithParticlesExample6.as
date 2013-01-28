/**
 * PlayingWithParticlesExample6.as by Lee Burrows
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
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import parts.Particle6;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="300", height="300")]
	public class PlayingWithParticlesExample6 extends Sprite
	{
		private const NEW_POINT:Point = new Point();
		private const BMD_RECT:Rectangle = new Rectangle(0, 0, 300, 300);

		private const PARTICLE_NUMBER:uint = 300;
		private var particles:Array;
		
		private var holder:Sprite;
		private var bitmapData:BitmapData;
		private var filter:BlurFilter;

		public function PlayingWithParticlesExample6()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//add bitmap to display motion trail
			bitmapData = new BitmapData(300, 300, true, 0x00000000);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			addChild(bitmap);
			//add blur filter for motion trail
			filter = new BlurFilter();
			//add holder for particles
			holder = new Sprite();
			addChild(holder);
			//somewhere to store a reference to the particles
			particles = [];
			//create particles
			for (var i:uint=0;i<PARTICLE_NUMBER;i++)
			{
				var p:Particle6 = new Particle6();
				//add particle to stage
				holder.addChild(p);
				//store reference to particle for later
				particles.push(p);
			}
			//start looping
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(event:Event):void
		{
			//loop through the particles
			for (var i:uint=0;i<PARTICLE_NUMBER;i++)
			{
				//tell each particle to update itself
				particles[i].update();
			}
			//copy particles to bitmap
			bitmapData.draw(holder);
			//blur bitmap (using 2 const values for optimisation)
			bitmapData.applyFilter(bitmapData, BMD_RECT, NEW_POINT, filter);
		}

	}
}