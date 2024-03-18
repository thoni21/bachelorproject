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

{ #category : #'connection open/close' }
URCData >> createSocketForData [
	
	s := SocketStream openConnectionToHostNamed: 'localhost'
    port: 30003.
		
	s binary.
		
]

{ #category : #'accessing - data' }
URCData >> getActualToolPose [
	| x packet_1 packet_2 packet_3 packet_4 packet_5 packet_6 packet_7 packet_8 packet_9 packet_10 packet_11 packet_12 packet_13 packet_14 packet_15 packet_16 packet_17 |


]
