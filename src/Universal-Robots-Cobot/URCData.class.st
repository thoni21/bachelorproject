"
I gather data from the cobot.

I set and return waypoints.
I can tell if the robot is moving.

I collaborate with URCCobotController and URCConnection.
I connect to the cobot using URCConnection.
I give data to URCCobotController.

Issues:
The ""setWaypointWithName:"" method is quite slow +-3 seconds, this is most likely due to how it is saved (dictionary in dictionary).
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

	double := byteArray doubleAt: 1 bigEndian: true.
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
        byteArray doubleAt: 1 bigEndian: true].

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
