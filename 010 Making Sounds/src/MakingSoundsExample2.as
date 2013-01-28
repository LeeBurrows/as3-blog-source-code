/**
 * MakingSoundsExample2.as by Lee Burrows
 * Mar 23, 2011
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
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	[SWF(backgroundColor="#333333", frameRate="30", width="100", height="100")]
	public class MakingSoundsExample2 extends Sprite
	{
		static private const RADS:Number = 2*Math.PI;

		private var channel:SoundChannel;
		private var sound:Sound;
		private var isPlaying:Boolean;

		public function MakingSoundsExample2()
		{
			init();
		}

		private function init():void
		{
			//set playing flag
			isPlaying = false;
			//create new sound object
			sound = new Sound();
			//add sound listener
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleHandler);
			//add mouse listener
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function sampleHandler(event:SampleDataEvent):void
		{
			var xpos:int = mouseX+1;
			//add 2 x 2048 random values to ByteArray
			for (var i:uint=0;i<2048;i++)
			{
				//calc position in sine wave
				var wavePos:Number = xpos*RADS*i/2048;
				//left sound channel
				event.data.writeFloat(Math.sin(wavePos));
				//right sound channel
				event.data.writeFloat(Math.sin(wavePos));
			}
		}

		private function clickHandler(event:MouseEvent):void
		{
			//toggle playing flag
			isPlaying = !isPlaying;
			//start or stop sound
			if (isPlaying)
				channel = sound.play();
			else
				channel.stop();
		}

	}
}