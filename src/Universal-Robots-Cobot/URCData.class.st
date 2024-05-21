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
		'waypoints'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Universal-Robots-Cobot'
}

{ #category : #accessing }
URCData class >> uniqueInstance [
    uniqueInstance ifNil: [ uniqueInstance := self new ].
    ^ uniqueInstance
]

{ #category : #'accessing - data' }
URCData >> clearWaypoints [
	^waypoints removeAll 
]

{ #category : #'accessing - data' }
URCData >> getCobotMode [
	| dataSocket byteArray double |
	dataSocket := URCConnection uniqueInstance getDataSocket.
	dataSocket skip: 1052.
	byteArray := dataSocket next: 8.
	
	byteArray := byteArray reversed.
	double := byteArray doubleAt: 1 bigEndian: false.
	^ double asFloat rounded
	



]

{ #category : #'accessing - data' }
URCData >> getToolPosition [
	| dataSocket byteArray doubles |
    dataSocket := URCConnection uniqueInstance getDataSocket.
    dataSocket skip: 444.

    "Collect six 8-byte doubles"
    doubles := (1 to: 6) collect: [:each |
        byteArray := dataSocket next: 8.
        byteArray reversed doubleAt: 1 bigEndian: false].

    ^ doubles
	



]

{ #category : #'accessing - data' }
URCData >> getWaypointWithName: aString [
	|waypointData waypointString|
	waypointData := waypoints  at: aString.
	^waypointString  := String streamContents: [:stream | 
    stream nextPutAll: (waypointData at: #x ifAbsent: [0]) asString; nextPut: $,.
    stream nextPutAll: (waypointData at: #y ifAbsent: [0]) asString; nextPut: $,.
    stream nextPutAll: (waypointData at: #z ifAbsent: [0]) asString; nextPut: $,.
    stream nextPutAll: (waypointData at: #rx ifAbsent: [0]) asString; nextPut: $,.
    stream nextPutAll: (waypointData at: #ry ifAbsent: [0]) asString; nextPut: $,.
    stream nextPutAll: (waypointData at: #rz ifAbsent: [0]) asString.
	].
]

{ #category : #initialization }
URCData >> initialize [ 
	super initialize.
	waypoints := Dictionary new
]

{ #category : #testing }
URCData >> isMoving [
	self getCobotMode = 2 ifTrue: [ ^true ] ifFalse: [ ^false ]
]

{ #category : #'accessing - data' }
URCData >> setWaypointWithName: aString [
	waypoints at: aString ifAbsentPut: [
        Dictionary newFrom: {
            #x -> (self getToolPosition at: 1).
            #y -> (self getToolPosition at: 2).
            #z -> (self getToolPosition at: 3).
            #rx -> (self getToolPosition at: 4).
            #ry -> (self getToolPosition at: 5).
            #rz -> (self getToolPosition at: 6)
        }
    ]
]
