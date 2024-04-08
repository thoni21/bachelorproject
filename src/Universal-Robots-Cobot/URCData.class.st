"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:
asd
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
	#name : #URCData,
	#superclass : #Object,
	#instVars : [
		's'
	],
	#category : #'Universal-Robots-Cobot'
}

{ #category : #'accessing - data' }
URCData >> clearWaypoints [
	'waypoints.txt' asFileReference 
	writeStreamDo: [ :stream | stream truncate].
]

{ #category : #'connection open/close' }
URCData >> createSocketForData [
	
	s := SocketStream openConnectionToHostNamed: 'localhost'
    port: 30003.
		
	s binary.
		
]

{ #category : #'accessing - data' }
URCData >> getActualToolPose [
	^'C:\Users\thhhe\cobot-tool-position.csv' asFileReference 
	readStreamDo:  [ :stream | stream upToEnd].
	
	
	"| csvFilePath |
	
	csvFilePath := 'C:\Users\thhhe\cobot-tool-position.csv'.
	^ (NeoCSVReader on: csvFilePath asFileReference readStream) upToEnd first asStringWithCr."
	



]

{ #category : #'accessing - data' }
URCData >> getWaypointWithName: aString [
	'waypoints.txt' asFileReference 
	readStreamDo:  [ :stream | stream setToEnd. stream << 'Hello, World!' ].
]

{ #category : #'accessing - data' }
URCData >> setWaypoint [
	'waypoints.txt' asFileReference 
	writeStreamDo: [ :stream | stream setToEnd. stream << 'Hello, World!' ].
]

{ #category : #'accessing - data' }
URCData >> setWaypointWithName: aString [
	'waypoints.txt' asFileReference 
	writeStreamDo: [ :stream | stream setToEnd. stream << (aString , ';' , self getActualToolPose) ].
]
