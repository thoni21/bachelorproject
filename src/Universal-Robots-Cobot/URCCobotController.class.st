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
	#name : #URCCobotController,
	#superclass : #Object,
	#instVars : [
		'waypoint',
		'moveType'
	],
	#category : #'Universal-Robots-Cobot'
}

{ #category : #'tool controlling' }
URCCobotController >> activateTool: anInt [
	URCConnection uniqueInstance sendCommand: 'set_tool_digital_out(', anInt asString ,',True)' .
	0.3 seconds wait
]

{ #category : #message }
URCCobotController >> createPopupTitle: title Message: message [
	  URCConnection uniqueInstance sendCommand: 'popup("' , message , '","' , title , '") '
]

{ #category : #'tool controlling' }
URCCobotController >> disactivateTool: anInt [
	URCConnection uniqueInstance sendCommand: 'set_tool_digital_out(', anInt asString,',False)' .
	0.3 seconds wait
]

{ #category : #initialization }
URCCobotController >> initialize [ 
	super initialize.
	URCConnection uniqueInstance startSession
]

{ #category : #movement }
URCCobotController >> moveTo: aWaypoint as: aMoveType [
	"aMoveType should be either j for default movement, l for linear movement or p for blend circular movement"
	 moveType := aMoveType.
    waypoint := aWaypoint.
    self schedule.
]

{ #category : #gripper }
URCCobotController >> openGripper [
"open
 rq_set_pos_spd_for(0, 102, 133, ""1"")
    rq_wait_pos_spe_for_request(0, 102, 133, ""1"")
    rq_go_to(""1"")
    rq_wait(""1"")

closeGrippper
 rq_set_pos_spd_for(255, 133, 102, ""1"")
    rq_wait_pos_spe_for_request(255, 133, 102, ""1"")
    rq_go_to(""1"")
    rq_wait(""1"")

"
]

{ #category : #movement }
URCCobotController >> performMovement [
	    URCConnection uniqueInstance sendCommand: 'move', moveType, '(p[', (URCData uniqueInstance getWaypointWithName: waypoint), '])'.
]

{ #category : #private }
URCCobotController >> retryAfterDelay [
	 [ 
        (Delay forMilliseconds: 500) wait.
        self schedule.
    ] fork.
]

{ #category : #private }
URCCobotController >> schedule [
	 URCData uniqueInstance getCobotMode = 1 ifTrue: [
        self performMovement
    ] ifFalse: [
        self retryAfterDelay
    ].
]

{ #category : #'i/o' }
URCCobotController >> setDigitalOutputFalse: anInt [ 
	URCConnection uniqueInstance sendCommand: 'set_standard_digital_out(', anInt asString,', False)' .
	0.3 seconds wait
]

{ #category : #'i/o' }
URCCobotController >> setDigitalOutputTrue: anInt [ 
	URCConnection uniqueInstance sendCommand: 'set_standard_digital_out(', anInt asString,', True)' .
	0.3 seconds wait
]

{ #category : #movement }
URCCobotController >> stopMovement [
	URCConnection uniqueInstance sendCommand: 'stopj(2)'.

	
]
