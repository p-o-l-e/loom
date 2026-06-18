
(define sd
  (make-sector-descriptor
    1           ; id
    10 20       ; left top
    60 20       ; width height
    ST_SOCKET   ; type
    SS_A        ; subtype
    0.0         ; default_value
    -8.0 8.0    ; range
    1.0 0.1     ; step coarse/fine
    1           ; radio_id
    MOVEABLE))  ; flags

