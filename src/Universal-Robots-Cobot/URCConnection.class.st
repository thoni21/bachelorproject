"
URLConnection handles connection to TCP/IP Sockets.

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
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
	serverAddress := NetNameResolver addressForName: 'localhost'.

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
	serverAddress := NetNameResolver addressForName: 'localhost'.
	clientSocket 
		connectTo: serverAddress port: 30002
		waitForConnectionFor: 5.
		
	clientSocket isConnected.
	
	clientSocket := SocketStream on: clientSocket
		


]
