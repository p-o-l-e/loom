(define L 0)
(define R 0)

(define W 299)
(define H 199)

(define descriptors
  (list
    (create-sector-descriptor
      1                                 ; id
      0                                 ; node id
      0 0                               ; left top
      W H                               ; width height
      ST_NODE                           ; type
      SS_A                              ; subtype
      0.0                               ; default_value
      -8.0 8.0                          ; range
      1.0 0.1                           ; step coarse/fine
      1                                 ; radio_id
      MOVEABLE)                         ; flags  

    (create-sector-descriptor
      2                                 ; id                      
      1                                 ; node id
      10 10                             ; left top
      (quotient W 2)                    ; width
      10                                ; height
      ST_TEXTBOX                        ; type
      SS_A                              ; subtype
      0.0                               ; default_value
      -8.0 8.0                          ; range
      1.0 0.1                           ; step coarse/fine
      1                                 ; radio_id
      (logior MOVEABLE TRANSPARENT))    ; flags      

    (create-sector-descriptor
      3                                 ; id                      
      1                                 ; node id
      10 10                             ; left top
      (quotient W 2)                    ; width
      (quotient H 10)                   ; height
      ST_SLIDER                         ; type
      SS_B                              ; subtype
      0.0                               ; default_value
      -8.0 8.0                          ; range
      1.0 0.1                           ; step coarse/fine
      1                                 ; radio_id
      MOVEABLE)                       ; flags            

    (create-sector-descriptor
      4                                 ; id
      1                                 ; node id
      50 60                             ; left top
      20 20                             ; width height
      ST_CHECKBOX                       ; type
      SS_B                              ; subtype
      0.0                               ; default_value
      0.0 1.0                           ; range
      1.0 0.0                           ; step coarse/fine
      2                                 ; radio_id
      0)))                              ; flags            
