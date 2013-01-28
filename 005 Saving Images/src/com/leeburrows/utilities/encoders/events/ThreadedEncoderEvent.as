/**
 * ThreadedEncoderEvent.as by Lee Burrows
 * Dec 31, 2010
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
package com.leeburrows.utilities.encoders.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ThreadedEncoderEvent extends Event
	{
		static public const PROGRESS:String = "progress";
		static public const COMPLETED:String = "completed";

		public var ratioComplete:Number;
		public var data:ByteArray;

		public function ThreadedEncoderEvent(type:String, ratioComplete:Number=0, data:ByteArray=null)
		{
			this.ratioComplete = ratioComplete;
			this.data = data;
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new ThreadedEncoderEvent(type, ratioComplete, data);
		}

	}
}