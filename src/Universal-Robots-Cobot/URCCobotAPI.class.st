"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:
sd
For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	controller:		<Object>
	data:		<Object>


    Implementation Points
"
Class {
	#name : #URCCobotAPI,
	#superclass : #Object,
	#instVars : [
		'controller'
	],
	#category : #'Universal-Robots-Cobot'
}

{ #category : #initialization }
URCCobotAPI >> initialize [ 
	controller := URCCobotController new.
	^ self
]

{ #category : #movement }
URCCobotAPI >> moveDefault: aString [
	controller moveDefault: aString 
	
]

{ #category : #movement }
URCCobotAPI >> moveDefaultToPos: aString [
	controller moveDefaultToPosition: aString 
	
]

{ #category : #'instance creation' }
URCCobotAPI >> new [ 
	^ super new initialize
]
