(define L 0)
(define R 0)

(define W 299)
(define H 199)

(define NodeID 1)
(define VOffset 3)

(define LeftMargin 8)

(define descriptors
    (list
    (create-sector-descriptor
        NodeID                            ; id
        0                                 ; node id
        0 0                               ; left top
        W H                               ; width height
        ST_NODE                           ; type
        SS_A                              ; subtype
        0.0                               ; default_value
        -8.0 8.0                          ; range
        1.0 0.1                           ; step coarse/fine
        0                                 ; radio_id
        "VCO"
        MOVEABLE
        0)                                ; flags  

    (create-sector-descriptor
        2                                 ; id                      
        NodeID                            ; node id
        LeftMargin 8                               ; left top
        (quotient W 3)                    ; width
        10                                ; height
        ST_TEXTBOX                        ; type
        SS_A                              ; subtype
        0.0                               ; default_value
        -8.0 8.0                          ; range
        1.0 0.1                           ; step coarse/fine
        0                                 ; radio_id
        "OSCILLATOR"
        TRANSPARENT
        0)                                ; flags      

    (create-sector-descriptor
        3                                 ; id                      
        NodeID                            ; node id
        (+ (quotient W 3) 15) (+ 25 VOffset)                              ; left top
        (quotient W 3)                    ; width
        10                                ; height
        ST_TEXTBOX                        ; type
        SS_A                              ; subtype
        0.0                               ; default_value
        0.0 0.0                          ; range
        0.0 0.0                           ; step coarse/fine
        0                                 ; radio_id
        "COARSE"
        TRANSPARENT
        0)                      ; flags  
    
    (create-sector-descriptor
        4                                 ; id                      
        NodeID                            ; node id
        LeftMargin 25                              ; left top
        (quotient W 3)                    ; width
        12                                ; height
        ST_SLIDER                         ; type
        SS_A                              ; subtype
        1.0                               ; default_value
        1.0 100.0                         ; range
        1.0 0.1                           ; step coarse/fine
        0                                 ; radio_id
        "COARSE"
        MOVEABLE
        3)                                ; flags       

    (create-sector-descriptor
        5                                 ; id                      
        NodeID                            ; node id
        (+ (quotient W 3) 15) (+ 45 VOffset)                              ; left top
        (quotient W 3)                    ; width
        10                                ; height
        ST_TEXTBOX                        ; type
        SS_A                              ; subtype
        0.0                               ; default_value
        0.0 0.0                          ; range
        0.0 0.0                           ; step coarse/fine
        0                                 ; radio_id
        "COARSE"
        TRANSPARENT
        0)                      ; flags  

    (create-sector-descriptor
        6                                 ; id                      
        NodeID                            ; node id
        LeftMargin 45                              ; left top
        (quotient W 3)                    ; width
        12                                ; height
        ST_SLIDER                         ; type
        SS_A                              ; subtype
        1.0                               ; default_value
        0.01 10.0                         ; range
        0.1 0.01                          ; step coarse/fine
        0                                 ; radio_id
        "FINE"
        MOVEABLE
        5)                                ; flags

    (create-sector-descriptor
        7                                 ; id
        NodeID                            ; node id
        LeftMargin 65                              ; left top
        10 10                             ; width height
        ST_CHECKBOX                       ; type
        SS_B                              ; subtype
        0.0                               ; default_value
        0.0 1.0                           ; range
        1.0 0.0                           ; step coarse/fine
        1                                 ; radio_id
        "SWITCH"
        RADIO
        0)

    (create-sector-descriptor
        8                                 ; id
        NodeID                            ; node id
        (+ 14 LeftMargin) 65                              ; left top
        10 10                             ; width height
        ST_CHECKBOX                       ; type
        SS_B                              ; subtype
        0.0                               ; default_value
        0.0 1.0                           ; range
        1.0 0.0                           ; step coarse/fine
        1                                 ; radio_id
        "SWITCH"
        RADIO
        0)
    
    (create-sector-descriptor
        9                                 ; id
        NodeID                            ; node id
        (+ 28 LeftMargin) 65                              ; left top
        10 10                             ; width height
        ST_CHECKBOX                       ; type
        SS_B                              ; subtype
        0.0                               ; default_value
        0.0 1.0                           ; range
        1.0 0.0                           ; step coarse/fine
        1                                 ; radio_id
        "SWITCH"
        RADIO
        0)
    )  
)
