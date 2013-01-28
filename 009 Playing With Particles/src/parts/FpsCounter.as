/**
 * FpsCounter.as by Lee Burrows
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
package parts
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class FpsCounter extends Sprite
	{
		private var tf:TextField;
		private var timer:Timer;
		private var frameCount:int;

		public function FpsCounter()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//draw background
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(0, 0, 20, 15);
			graphics.endFill();
			//add textfield
			tf = new TextField();
			tf.width = 20;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.defaultTextFormat = new TextFormat("sans", 10, 0xFFFFFF);
			addChild(tf);
			//set counter
			frameCount = 0;
			//start 1 second repeat timer
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			//start loop
			addEventListener(Event.ENTER_FRAME, loop);
		}		
		
		private function loop(event:Event):void
		{
			//count a frame each loop
			frameCount++;
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			//update textfield with frames in last seconds
			tf.text = String(frameCount);
			//reset counter
			frameCount = 0;
		}

	}
}