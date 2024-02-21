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
	#category : #'Universal-Robots-Cobot'
}

{ #category : #'connection open/close' }
URCConnection >> startSession [
	| clientSocket serverAddress |
	clientSocket := Socket newTCP.
	serverAddress := NetNameResolver addressForName: 'localhost'.
	clientSocket 
		connectTo: serverAddress port: 30001;  
		waitForConnectionFor: 5.
	clientSocket isConnected 
		-> true
]
