/**
 * MakingSoundsExample4.as by Lee Burrows
 * Mar 26, 2011
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
	import flash.utils.ByteArray;

	[SWF(backgroundColor="#333333", frameRate="30", width="100", height="100")]
	public class MakingSoundsExample4 extends Sprite
	{
		static private const RADS:Number = 2*Math.PI;

		private var channel:SoundChannel;
		private var sound:Sound;
		private var isPlaying:Boolean;

		//storage for generated sound
		private var soundBytes:ByteArray;

		public function MakingSoundsExample4()
		{
			init();
		}

		private function init():void
		{
			//set playing flag
			isPlaying = false;
			//create bytes for sound
			buildSound();
			//create new sound object
			sound = new Sound();
			//add sound listener
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleHandler);
			//add mouse listener
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function sampleHandler(event:SampleDataEvent):void
		{
			//see how many bytes to copy
			var byteNum:uint = Math.min(4*2*8192, soundBytes.bytesAvailable);
			if (byteNum>0)
			{
				//copy bytes to event ByteArray
				event.data.writeBytes(soundBytes, soundBytes.position, byteNum);
				//update position in generated sound
				soundBytes.position += byteNum;
			}
			//any more sound?
			if (soundBytes.bytesAvailable==0)
				isPlaying = false;
		}
		
		private function buildSound():void
		{
			//init ByteArray
			soundBytes = new ByteArray();
			//number of pairs of values to add
			const SIZE:uint = 100000;
			//loop
			for (var i:uint=0;i<SIZE;i++)
			{
				//calc position in sine wave
				var wavePos:Number = 400*(RADS*i/SIZE);
				//calc amplitude
				var amplitude:Number = Math.sin(wavePos);
				//easing in/out
				const EASE_SIZE:uint = 1000;
				//easing at start?
				if (i<EASE_SIZE)
				{
					amplitude *= i/EASE_SIZE;
				}
				//easing at end?
				if (i>SIZE-EASE_SIZE)
				{
					amplitude *= (SIZE-i-1)/EASE_SIZE;
				}
				//save pair of values
				soundBytes.writeFloat(amplitude);
				soundBytes.writeFloat(amplitude);
			}
			//fill with zeros
			var sizeMod:int = Math.ceil(SIZE/8192)*8192;
			for (i=SIZE;i<sizeMod;i++)
			{
				soundBytes.writeFloat(0);
				soundBytes.writeFloat(0);
			}
		}

		private function clickHandler(event:MouseEvent):void
		{
			//toggle playing flag
			isPlaying = !isPlaying;
			//start or stop sound
			if (isPlaying)
			{
				//set position at start
				soundBytes.position = 0;
				//start sound
				channel = sound.play();
			}
			else
			{
				//stop sound
				channel.stop();
			}
		}

	}
}