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
	#category : #'Universal-Robots-Cobot'
}

{ #category : #'accessing - data' }
URCData >> addNameOfWaypointToFile: aString [
	'names-of-waypoints.csv' asFileReference 
	writeStreamDo: [ :stream | stream setToEnd. stream << (aString , ',') ].
]

{ #category : #'accessing - data' }
URCData >> clearWaypoints [
	'waypoints.txt' asFileReference 
	writeStreamDo: [ :stream | stream truncate].
	'names-of-waypoints.csv' asFileReference 
	writeStreamDo: [ :stream | stream truncate].
]

{ #category : #'accessing - data' }
URCData >> getCobotMode [
	| dataSocket byteArray double |
	dataSocket := URCConnection uniqueInstance getDataSocket.
	dataSocket skip: 1052.
	byteArray := dataSocket next: 8.
	dataSocket destroy.
	
	byteArray := byteArray reversed.
	double := byteArray doubleAt: 1 bigEndian: false.
	^ double
	



]

{ #category : #'accessing - data' }
URCData >> getNamesOfWaypoints [
	^ (NeoCSVReader on: 'names-of-waypoints.csv'  asFileReference readStream) 
		upToEnd flatCollect: [:each | each ]
]

{ #category : #'accessing - data' }
URCData >> getToolPosition [
	| dataSocket byteArray doubles valuesString |
    dataSocket := URCConnection uniqueInstance getDataSocket.
    dataSocket skip: 444.

    "Collect six 8-byte doubles"
    doubles := (1 to: 6) collect: [:each |
        byteArray := dataSocket next: 8.
        byteArray reversed doubleAt: 1 bigEndian: false].

    dataSocket destroy.

    "Convert the collection of doubles to a comma-separated string"
    valuesString := String streamContents: [:stream | 
        doubles do: [:each | stream nextPutAll: each asString] separatedBy: [stream nextPut: $,]].

    ^ valuesString
	



]

{ #category : #'accessing - data' }
URCData >> getWaypointWithName: aString [

	| fileContent segments index|
    fileContent := 'waypoints.txt' asFileReference readStreamDo: [ :stream | stream upToEnd].
   	segments := fileContent splitOn: $;.
   index := segments  indexOf: aString ifAbsent: [^ nil]. 
    (index + 1) <= segments  size ifTrue: [^ segments  at: index + 1].
	
]

{ #category : #'accessing - data' }
URCData >> setWaypointWithName: aString [

	self getNamesOfWaypoints detect: [:each | each = aString] 

	ifFound:  
		[
		UIManager default inform: 'Waypoints can not have the same name.'. 42.
		]
	ifNone:  
		[ 
		'waypoints.txt' asFileReference 
		writeStreamDo: [ :stream | stream setToEnd. stream << 
		(aString , ';' , self getActualToolPose , ';') ].
		self addNameOfWaypointToFile: aString.
		 ]
	
]
