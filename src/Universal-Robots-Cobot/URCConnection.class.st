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
	| serverAddress |
	clientSocket := Socket newTCP.

	"Resolve the server address; replace 'localhost' with your server's address if different"
	serverAddress := NetNameResolver addressForName: 'localhost'.

	"Connect to the server on port 30003; adjust the port as necessary"
	clientSocket connectTo: serverAddress port: 30003 waitForConnectionFor: 10.

	"Check if the socket is connected"
	clientSocket isConnected ifFalse: [
    	Transcript show: 'Failed to connect.'; cr.
    	^self
	].

	"Create a data socket from the client socket"
	dataSocket := SocketStream on: clientSocket.
	dataSocket binary.
	^dataSocket 


]

{ #category : #'accessing - data' }
URCConnection >> getDataUR [
	| byteArray double |

	"Skip initial bytes if needed, here skipping 1052 bytes"
	dataSocket skip: 1052.

	"Read the next 8 bytes expected to be a double"
	byteArray := dataSocket next: 8.

	"Ensure the byteArray is in the correct endian order for Pharo (little-endian)"
	byteArray := byteArray reversed.

	"Convert the reversed ByteArray to a double"
	double := byteArray doubleAt: 1 bigEndian: false.
	^ double
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
		
	clientSocket isConnected
		


]

{ #category : #'connection open/close' }
URCConnection >> startSessionForData [
	| serverAddress |
	clientSocket := Socket newTCP.

	"Resolve the server address; replace 'localhost' with your server's address if different"
	serverAddress := NetNameResolver addressForName: 'localhost'.

	"Connect to the server on port 30003; adjust the port as necessary"
	clientSocket connectTo: serverAddress port: 30003 waitForConnectionFor: 10.

	"Check if the socket is connected"
	clientSocket isConnected ifFalse: [
    	Transcript show: 'Failed to connect.'; cr.
    	^self
	].

	"Create a data socket from the client socket"
	dataSocket := SocketStream on: clientSocket.
	dataSocket binary.
	^dataSocket 


]
