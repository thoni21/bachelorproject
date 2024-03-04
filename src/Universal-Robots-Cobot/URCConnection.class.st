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
		'clientSocket'
	],
	#category : #'Universal-Robots-Cobot'
}

{ #category : #'connection open/close' }
URCConnection >> closeSession [
	clientSocket closeAndDestroy 
]

{ #category : #movement }
URCConnection >> getActualJointPosition [
	clientSocket sendCommand: 'get_actual_joint_positions()'.
	^ clientSocket receiveData
]

{ #category : #movement }
URCConnection >> moveDefault: aString [
	clientSocket sendCommand: 'movej(' , aString , ')'
]

{ #category : #movement }
URCConnection >> moveLinear: aString [
	clientSocket sendCommand: 'movel(' , aString , ')'
]

{ #category : #'error handling' }
URCConnection >> popup: message string: title [ 	
	clientSocket  sendCommand: 'popup("' , message , '","' , title , '")'
]

{ #category : #'connection open/close' }
URCConnection >> startSession [
	| serverAddress |
	clientSocket := Socket newTCP.
	serverAddress := NetNameResolver addressForName: 'localhost'.
	clientSocket 
		connectTo: serverAddress port: 30001
		waitForConnectionFor: 5.
		
	clientSocket isConnected
		


]
