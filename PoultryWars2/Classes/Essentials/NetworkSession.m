//
//  NetworkSession.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/8/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import "NetworkSession.h"

@implementation NetworkSession

@synthesize gameSession;
@synthesize tossStatus;
@synthesize gamePeerId;
@synthesize levelSelected;
@synthesize addEggInvocation;

#pragma mark Data Send/Receive Methods

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.tossStatus = kNotDecided;
		self.levelSelected = ZERO;
		self.gamePeerId = nil;
	}
	return self;
}


/*
 * Getting a data packet. This is the data receive handler method expected by the GKSession. 
 * We set ourselves as the receive data handler in the -peerPickerController:didConnectPeer:toSession: method.
 */
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context 
{ 
	unsigned char *incomingPacket = (unsigned char *)[data bytes];
	int *pIntData = (int *)&incomingPacket[0];
	//
	// developer  check the network time and make sure packers are in order
	//
	int packetID = pIntData[0];
	if(packetID != NETWORK_COINTOSS) {
		//return;	
	}
	
	switch( packetID ) {
		case NETWORK_COINTOSS:
		{
			// coin toss to determine roles of the two players
			int coinToss = pIntData[1];
			int gameUniqueID = [[[UIDevice currentDevice] uniqueIdentifier] hash];
			// if other player's coin is higher than ours then that player is the server
			if(coinToss > gameUniqueID) 
			{
				self.tossStatus = kLost;
			}
			else
			{
				self.tossStatus = kWon;
			}
		}
			break;
		case NETWORK_LEVEL:
		{
			// coin toss to determine roles of the two players
			int lvl = pIntData[1];
			// if other player's coin is higher than ours then that player is the server
			switch (lvl) {
				case ONE:
					self.levelSelected = ONE;
					break;
				case TWO:
					self.levelSelected = TWO;
					break;
				case THREE:
					self.levelSelected = THREE;
					break;
				default:
					break;
			}
		}
			break;
		case NETWORK_THROWEGG:
		{
			int type = OPPONENT;
			[addEggInvocation setArgument:&pIntData[1] atIndex:2];
			[addEggInvocation setArgument:&pIntData[2] atIndex:3];
			[addEggInvocation setArgument:&type atIndex:4];
			[addEggInvocation setArgument:&pIntData[3] atIndex:5];
			[addEggInvocation setArgument:&pIntData[4] atIndex:6];
			[addEggInvocation invoke];
			
			break;
		}
		default:
			// error
			break;
	}
}

- (void)sendNetworkPacketWithId:(int)packetID withData:(void *)data ofLength:(int)length reliable:(BOOL)howtosend {
	// the packet we'll send is resued
	static unsigned char networkPacket[1024];
	const unsigned int packetHeaderSize = sizeof(int); // we have two "ints" for our header
	
	if(length < (1024 - packetHeaderSize)) { // our networkPacket buffer size minus the size of the header info
		int *pIntData = (int *)&networkPacket[0];
		// header info
		pIntData[0] = packetID;
		// copy data in after the header
		memcpy( &networkPacket[packetHeaderSize], data, length ); 
		
		NSData *packet = [NSData dataWithBytes: networkPacket length: (length+sizeof(int))];
		if(howtosend == YES) 
		{ 
			[gameSession sendData:packet toPeers:[NSArray arrayWithObject:gamePeerId] withDataMode:GKSendDataReliable error:nil];
		}
		else 
		{
			[gameSession sendData:packet toPeers:[NSArray arrayWithObject:gamePeerId] withDataMode:GKSendDataUnreliable error:nil];
		}
	}
}

#pragma mark GKSessionDelegate Methods

// we've gotten a state change in the session
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state { 
	if(self.gameSession && state == GKPeerStateConnected) ;
	{
		return;				// only do stuff if we're in multiplayer, otherwise it is probably for Picker
	}
	
	if(state == GKPeerStateDisconnected) 
	{
		//		// We've been disconnected from the other peer.
		//		
		//		// Update user alert or throw alert if it isn't already up
		//		NSString *message = [NSString stringWithFormat:@"Could not reconnect with %@.", [session displayNameForPeer:peerID]];
		//		if((self.gameState == kStateMultiplayerReconnect) && self.connectionAlert && self.connectionAlert.visible) {
		//			self.connectionAlert.message = message;
		//		}
		//		else {
		//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lost Connection" message:message delegate:self cancelButtonTitle:@"End Game" otherButtonTitles:nil];
		//			self.connectionAlert = alert;
		//			[alert show];
		//			[alert release];
		//		}
		//		
		//		// go back to start mode
		//		self.gameState = kStateStartGame; 
	} 
} 

#pragma mark -

- (void)dealloc {
	[gameSession release];
	[gamePeerId release];
	[addEggInvocation release];
	[super dealloc];
}

@end
