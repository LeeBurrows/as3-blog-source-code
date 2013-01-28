/**
 * P2PLanExample1.as by Lee Burrows
 * Oct 31, 2011
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
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	[SWF(width="250",height="300",backgroundColor="#EEEEEE")]
	public class P2PLanExample1 extends Sprite
	{
		private var netConn:NetConnection;
		private var group:NetGroup;

		private var inputText:InputText;
		private var outputText:TextArea;
		private var submitButton:PushButton;

		public function P2PLanExample1()
		{
			//create UI (using minimalComps)
			inputText = new InputText(this, 10, 10, "");
			submitButton = new PushButton(this, 120, 10, "Send", btnHandler);
			submitButton.width = 70;
			submitButton.enabled = false;
			outputText = new TextArea(this, 10, 35, "");
			outputText.width = 230;
			outputText.height = 255;
			
			//setup connection object
			netConn = new NetConnection();
			//listen for result of setup
			netConn.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
			//connect to LAN
			netConn.connect("rtmfp:");			
		}
		
		private function btnHandler(event:MouseEvent):void
		{
			//update UI
			outputText.text += "[SENDING]\n"+inputText.text+"\n";
			// Create an object to hold the data to send
			var obj:Object = new Object();
			//add the data
			obj.txt = inputText.text;
			//add some extra data to ensure every sent object is unique
			obj.id = new Date().time;
			//send to everyone in group
			group.post(obj);
		}
		
		private function netHandler(event:NetStatusEvent):void
		{
			//update UI
			outputText.text += "[EVENT]\n"+event.info.code+"\n";
			//handle event
			switch(event.info.code)
			{
				//connection succeeded so setup a group
				case "NetConnection.Connect.Success":
					setupGroup();
					break;
				//group setup succeeded so enable submit
				case "NetGroup.Connect.Success":
					submitButton.enabled = true;
					break;
				//posting received so add to output
				case "NetGroup.Posting.Notify":
					outputText.text += "[RECEIVED]\n"+event.info.message.txt+"\n";
					break;
			}
		}
		
		private function setupGroup():void
		{
			//create a GroupSpecifier object
			var groupspec:GroupSpecifier = new GroupSpecifier("myGroup");
			//enable posting (to entire group)
			groupspec.postingEnabled = true;
			//allow data to be exchanged on IP multicast sockets
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			//set the IP adress and port to use
			groupspec.addIPMulticastAddress("225.225.0.1:30000");
			//create NetGroup with our NetConnection using GroupSpecifier details
			group = new NetGroup(netConn, groupspec.groupspecWithAuthorizations());
			//listen for result of setup
			group.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
		}

	}
}