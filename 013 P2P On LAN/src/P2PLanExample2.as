/**
 * P2PLanExample2.as by Lee Burrows
 * Nov 2, 2011
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
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	[SWF(width="250",height="300",backgroundColor="#EEEEEE")]
	public class P2PLanExample2 extends Sprite
	{
		private var netConn:NetConnection;
		private var group:NetGroup;

		private var label:Label;
		private var inputText:InputText;
		private var outputText:TextArea;
		private var submitButton:PushButton;
		private var peerList:ComboBox;

		public function P2PLanExample2()
		{
			//create UI (using minimalComps)
			label = new Label(this, 10, 10);
			label.width = 230;
			inputText = new InputText(this, 10, 35, "");
			inputText.width = 230;
			peerList = new ComboBox(this, 10, 60);
			peerList.width = 110;
			submitButton = new PushButton(this, 130, 60, "Send", btnHandler);
			submitButton.width = 110;
			submitButton.enabled = false;
			outputText = new TextArea(this, 10, 95, "");
			outputText.width = 230;
			outputText.height = 195;
			
			//setup list of users
			peerList.items = [{label:"ALL"}];
			peerList.selectedIndex = 0;
			
			//setup connection object
			netConn = new NetConnection();
			//listen for result of setup
			netConn.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
			//connect to LAN
			netConn.connect("rtmfp:");			
		}
		
		private function btnHandler(event:MouseEvent):void
		{
			// Create an object to hold the data to send
			var obj:Object = new Object();
			//add the data
			obj.txt = inputText.text;
			//add some extra data to ensure every sent object is unique
			obj.id = new Date().time;
			//update UI
			outputText.text += "[SENDING TO "+peerList.selectedItem.label+"]\n"+inputText.text+"\n";

			if (peerList.selectedItem.label=="ALL")
			{
				//send to everyone in group
				group.post(obj);
			}
			else
			{
				//get group address of peer
				var destination:String = group.convertPeerIDToGroupAddress(String(peerList.selectedItem.id));
				//save to message object
				obj.destination = destination;
				//send message
				group.sendToNearest(obj, destination);
			}
		}
		
		private function netHandler(event:NetStatusEvent):void
		{
			//update UI
			//outputText.text += "[EVENT]\n"+event.info.code+"\n";
			//handle event
			switch(event.info.code)
			{
				//connection succeeded so setup a group
				case "NetConnection.Connect.Success":
					label.text = "ID: "+truncateString(netConn.nearID);
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
				//neighbour connected so add details to list
				case "NetGroup.Neighbor.Connect":
					var peer:Object = new Object();
					peer.id = event.info.peerID.toString();
					peer.label = truncateString(event.info.peerID);
					peerList.addItem(peer);
					break;
				//neighbour disconnected so remove details from list
				case "NetGroup.Neighbor.Disconnect":
					var len:uint = peerList.items.length;
					for (var i:uint=0;i<len;i++)
					{
						if (peerList.items[i].id==event.info.peerID)
						{
							peerList.removeItemAt(i);
							break;
						}
					}
					break;
				//directed message received so check if this is the final destination
				case "NetGroup.SendTo.Notify":
					if (event.info.fromLocal==true)
						//is destination so display it
						outputText.text += "[RECEIVED]\n"+event.info.message.txt+"\n";
					else
						//not destination so re-send
						group.sendToNearest(event.info.message, event.info.message.destination);
					break;
			}
		}
		
		private function setupGroup():void
		{
			//create a GroupSpecifier object
			var groupspec:GroupSpecifier = new GroupSpecifier("myGroup");
			//enable posting (to entire group)
			groupspec.postingEnabled = true;
			//enable direct routing (to individual peer)
			groupspec.routingEnabled = true;
			//allow data to be exchanged on IP multicast sockets
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			//set the IP adress and port to use
			groupspec.addIPMulticastAddress("225.225.0.1:30000");
			//create NetGroup with our NetConnection using GroupSpecifier details
			group = new NetGroup(netConn, groupspec.groupspecWithAuthorizations());
			//listen for result of setup
			group.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
		}
		
		private function truncateString(str:String):String
		{
			return str.substr(0, 10)+"...";
		}

	}
}