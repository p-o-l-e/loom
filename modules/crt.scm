(define crt-id 0)
(define crt-width 324) 
(define crt-height 224)

(define (crt-descriptor)
    (let*  ((static-id   (control-counter 0))
            (control-id  (control-counter 0))
            (input-id    (control-counter 0))
            (output-id   (control-counter 0))
            (display-w 250)
            (display-h 200)
            (input-x-id  (encode-uid CMT_CRT crt-id F_CT_INPUT (input-id)))
            (input-y-id  (encode-uid CMT_CRT crt-id F_CT_INPUT (input-id)))
            )

    (list
        (sector
            ID:             crt-id
            Width:          crt-width
            Height:         crt-height
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "CRT"
            Flags:          MOVEABLE
        )

        ;---INPUTS--------------------------------------------------------------------------------------------------------------
        (sector
            ID:             input-x-id
            NodeID:         crt-id
            Left:           (grid-x 0)
            Top:            (grid-y 4)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_CRT crt-id F_CT_STATIC (static-id))
            NodeID:         crt-id
            Left:           (grid-x 1)
            Top:            (grid-y 4)
            Width:          (* 1 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "X"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             input-y-id
            NodeID:         crt-id
            Left:           (grid-x 0)
            Top:            (grid-y 5)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_CRT crt-id F_CT_STATIC (static-id))
            NodeID:         crt-id
            Left:           (grid-x 1)
            Top:            (grid-y 5)
            Width:          (* 1 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "Y"
            Flags:          TRANSPARENT
        )

        ;---CRT-----------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid CMT_CRT crt-id F_CT_STATIC (static-id))
            NodeID:         crt-id
            Left:           (grid-x 2)
            Top:            (quotient (- crt-height display-h) 2)
            Width:          display-w
            Height:         display-h
            Type:           ST_CRT
            Flags:          TRANSPARENT
            InputX:         input-x-id
            InputY:         input-y-id
        )
    ))
)
