(define split-id 0)
(define split-width 99)
(define split-height 99)

(define (split-descriptor)
    (let*  ((static-id   (control-counter 0))
            (control-id  (control-counter 0))
            (input-id    (control-counter 0))
            (output-id   (control-counter 0))
            )

    (list
        (sector
            ID:             split-id
            Width:          split-width
            Height:         split-height
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "SPLIT"
            Flags:          MOVEABLE
        )

        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_STATIC (static-id))
            NodeID:         split-id
            Left:           (grid-x 1)
            Top:            (grid-y 0)
            Width:          (grid-x 9)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "SPLIT"
            Flags:          TRANSPARENT
        )

        ;---INPUT---------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_INPUT (input-id))
            NodeID:         split-id
            Left:           (grid-x 0)
            Top:            (grid-y 0)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_INPUT (input-id))
            NodeID:         split-id
            Left:           (grid-x 0)
            Top:            (grid-y 2)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_INPUT (input-id))
            NodeID:         split-id
            Left:           (grid-x 0)
            Top:            (grid-y 3)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        ;---OUTPUT A------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_OUTPUT (output-id))
            NodeID:         split-id
            Left:           (grid-x 4)
            Top:            (grid-y 2)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_OUTPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        ;---OUTPUT B------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_OUTPUT (output-id))
            NodeID:         split-id
            Left:           (grid-x 4)
            Top:            (grid-y 3)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_OUTPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        ;---INVERT A------------------------------------------------------------------------------------------------------------

        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_CONTROL (control-id))
            NodeID:         split-id
            Left:           (grid-x 1)
            Top:            (grid-y 2)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            CoreType:       F_CT_CONTROL
            DefaultValue:   0.0
            Label:          "INV"
            Flags:          0
            CallbackTarget: 0
        )

        ;---INVERT B------------------------------------------------------------------------------------------------------------

        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_CONTROL (control-id))
            NodeID:         split-id
            Left:           (grid-x 1)
            Top:            (grid-y 3)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            CoreType:       F_CT_CONTROL
            DefaultValue:   0.0
            Label:          "INV"
            Flags:          0
            CallbackTarget: 0
        )

        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_STATIC (static-id))
            NodeID:         split-id
            Left:           (grid-x 2)
            Top:            (grid-y 2)
            Width:          (* 5 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "INV"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_SPLIT split-id F_CT_STATIC (static-id))
            NodeID:         split-id
            Left:           (grid-x 2)
            Top:            (grid-y 3)
            Width:          (* 5 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "INV"
            Flags:          TRANSPARENT
        )
    ))
)
