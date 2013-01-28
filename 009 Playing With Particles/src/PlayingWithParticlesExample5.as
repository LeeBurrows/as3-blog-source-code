/**
 * PlayingWithParticlesExample5.as by Lee Burrows
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
	import flash.events.MouseEvent;
	
	import parts.Particle5;
	
	[SWF(backgroundColor="#333333", frameRate="30", width="300", height="300")]
	public class PlayingWithParticlesExample5 extends Sprite
	{
		private const PARTICLE_NUMBER:uint = 250;
		private var particles:Array;
		
		private var holder:Sprite;

		public function PlayingWithParticlesExample5()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//add holder for particles to center of swf (so x,y,z=0 for particles is at center of swf too)
			holder = new Sprite();
			holder.x = 150;
			holder.y = 150;
			addChild(holder);
			//somewhere to store a reference to the particles
			particles = [];
			//create particles
			for (var i:uint=0;i<PARTICLE_NUMBER;i++)
			{
				var p:Particle5 = new Particle5();
				//add particle to stage
				holder.addChild(p);
				//store reference to particle for later
				particles.push(p);
			}
			//listen for mouse click
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			//start looping
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			//loop through the particles
			for (var i:uint=0;i<PARTICLE_NUMBER;i++)
			{
				//tell each particle to reset itself
				particles[i].init();
			}
		}
		
		private function loop(event:Event):void
		{
			//loop through the particles
			for (var i:uint=0;i<PARTICLE_NUMBER;i++)
			{
				//tell each particle to update itself
				particles[i].update();
			}
			//depth sort: sort particles by z distance
			particles.sortOn("z", Array.DESCENDING | Array.NUMERIC);
			//add re-add to display list one at a time (particle[0] ends up at the bottom)
			for (i=0;i<PARTICLE_NUMBER;i++)
			{
				holder.addChild(particles[i]);
			}			
		}

	}
}