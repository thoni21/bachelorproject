"
I handle connection to the cobot, utilising TCP/IP socketstreams.

I establish connections.
I close connections.
I send messages to the cobot.

I collaborate with URCCobotController and URCData.
I allow for URCCobotController to connect to the cobot and send commands.
I allow for URCData to connect to the cobot and recieve data.
"
Class {
	#name : #URCConnection,
	#superclass : #Object,
	#instVars : [
		'clientSocket',
		'dataSocket'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Universal-Robots-Cobot'
}

{ #category : #accessing }
URCConnection class >> uniqueInstance [
    uniqueInstance ifNil: [ uniqueInstance := self new ].
    ^ uniqueInstance
]

{ #category : #'connection open/close' }
URCConnection >> closeSession [
	clientSocket closeAndDestroy 
]

{ #category : #'connection open/close' }
URCConnection >> getDataSocket [
	| serverAddress socketSocket|
	socketSocket := Socket newTCP.
	serverAddress := NetNameResolver addressForName: '192.168.5.1'.

	socketSocket connectTo: serverAddress port: 30003 waitForConnectionFor: 10.

	socketSocket isConnected ifFalse: [
    	Transcript show: 'Failed to connect.'; cr.
    	^self
	].

	dataSocket := SocketStream on: socketSocket.
	dataSocket binary.
	^dataSocket 


]

{ #category : #'private - protocol' }
URCConnection >> sendCommand: aString [
	clientSocket sendCommand: aString
]

{ #category : #'connection open/close' }
URCConnection >> startSession [
	| serverAddress |
	clientSocket := Socket newTCP.
	serverAddress := NetNameResolver addressForName: '192.168.5.1'.
	clientSocket 
		connectTo: serverAddress port: 30002
		waitForConnectionFor: 5.
		
	clientSocket isConnected.
	
	clientSocket := SocketStream on: clientSocket
		


]
