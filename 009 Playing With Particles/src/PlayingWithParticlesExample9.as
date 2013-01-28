/**
 * PlayingWithParticlesExample9.as by Lee Burrows
 * Feb 24, 2011
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
	import flash.geom.Rectangle;
	
	import parts.FpsCounter;
	import parts.Particle9;

	[SWF(backgroundColor="#000000", frameRate="30", width="400", height="400")]
	public class PlayingWithParticlesExample9 extends Sprite
	{
		private const BMD_RECT:Rectangle = new Rectangle(0, 0, 400, 400);
		private const PARTICLE_NUMBER:uint = 10000;

		private var firstParticle:Particle9;
		private var bitmapData:BitmapData;
		
		private var map:Vector.<uint>;
		
		[Embed(source="../assets/image1.jpg")]
		private var imgClass:Class;

		public function PlayingWithParticlesExample9()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//create mapping data
			var bitmap:Bitmap = new imgClass();
			map = bitmap.bitmapData.getVector(BMD_RECT);
			//add bitmap to stage
			bitmapData = new BitmapData(BMD_RECT.width, BMD_RECT.height, false, 0x333333);
			addChild(new Bitmap(bitmapData));
			//create linked list of particles
			var i:int = PARTICLE_NUMBER;
			var particle:Particle9;
			var nextParticle:Particle9;
			//repeat until i is false (less than zero)
			while (--i)
			{
				particle = new Particle9();
				particle.next = nextParticle;
				nextParticle = particle;
			}
			firstParticle = particle;
			//add debug info to bottom right
			var fps:FpsCounter = new FpsCounter();
			fps.x = BMD_RECT.width-fps.width;
			fps.y = BMD_RECT.height-fps.height;
			addChild(fps);
			//start looping
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(event:Event):void
		{
			//lock and clear bitmapdata
			bitmapData.lock();
			bitmapData.fillRect(BMD_RECT, 0x333333);
			//read data from bitmap
			var v:Vector.<uint> = bitmapData.getVector(BMD_RECT);
			//loop through the particles
			var particle:Particle9 = firstParticle;
			while (particle)
			{
				//update position
				var mapCol:uint = map[BMD_RECT.width*int(particle.y)+int(particle.x)];
				var mapX:uint = mapCol>>8 & 0xFF;
				var mapY:uint = mapCol & 0xFF;
				particle.dx += (mapX-127.5)/512;
				particle.dy += (mapY-127.5)/512;
				particle.dx *= 0.98;
				particle.dy *= 0.98;
				particle.x += particle.dx;
				particle.y += particle.dy;
				//if hit edge, wrap around position
				if (particle.x<0)
					particle.x += BMD_RECT.width;
				else if (particle.x>=BMD_RECT.width)
					particle.x -= BMD_RECT.width;
				if (particle.y<0)
					particle.y += BMD_RECT.height;
				else if (particle.y>=BMD_RECT.height)
					particle.y -= BMD_RECT.height;
				//update data for pixel
				v[BMD_RECT.width*int(particle.y)+int(particle.x)] = particle.colour;
				//move to next particle
				particle = particle.next;
			}
			//write data back to bitmap
			bitmapData.setVector(BMD_RECT, v);
			//unlock bitmapdata
			bitmapData.unlock();
		}

	}
}