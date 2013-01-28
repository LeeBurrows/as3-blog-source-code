/**
 * PlayingWithParticlesExample2.as by Lee Burrows
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
	import flash.display.Sprite;
	import flash.events.Event;
	
	import parts.Particle2;
	
	[SWF(backgroundColor="#333333", frameRate="30", width="300", height="300")]
	public class PlayingWithParticlesExample2 extends Sprite
	{
		private const PARTICLE_NUMBER:uint = 100;
		private var particles:Array;

		public function PlayingWithParticlesExample2()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//somewhere to store a reference to the particles
			particles = [];
			//create particles
			for (var i:uint=0;i<PARTICLE_NUMBER;i++)
			{
				//create a particle with random position and velocity
				var p:Particle2 = new Particle2();
				//add particle to stage
				addChild(p);
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
		}

	}
}