"
I represent the API user interface.

I am responsible for giving the user the ability to manipulate the cobot.

I access URCConnection and URCData.
URCConnection allows me to send commands.
URCData allows me to get data from the robot.

Issues:
In schedule any ""waypoint"" and ""moveType"" when moving that is not the first or last is overwritten, if it is the same instance, due to these being instance variables set by the moveTo:as: command.

Example:

moveTo: x as: j - ""waypoint"" and ""moveType"" set (movement being performed)
moveTo: y as: j - new ""waypoint"" and ""moveType"" set (previous movement being performed, so this skipped)
moveTo: z as: j - new ""waypoint"" and ""moveType"" set (As this is last call, the instance variables stay the same and this is called when the cobot has finished the first movement)
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
