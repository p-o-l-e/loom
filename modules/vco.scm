(define NodeID      1)

(define descriptors
    (let ((NodeWidth  199) 
          (NodeHeight 299)
          (Unit 12)
          (TBoxCoarse (encode-uid MT_VCO NodeID ST_TEXTBOX 2))
          (TBoxFine   (encode-uid MT_VCO NodeID ST_TEXTBOX 3)))
    (list
        (sector
            ID:             NodeID
            Width:          NodeWidth
            Height:         NodeHeight
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "VCO"
            Flags:          MOVEABLE
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX 1)
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 0)
            Width:          (grid-x 9)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "OSCILLATOR"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxCoarse
            NodeID:         NodeID
            Left:           (grid-x 7)
            Top:            (grid-y 1)
            Width:          (quotient NodeWidth 3)
            Height:         Unit
            Type:           ST_TEXTBOX
            SubType:        SS_A
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       0.0
            StepCoarse:     0.0
            StepFine:       0.0
            RadioID:        0
            Label:          "0.00"
            Flags:          TRANSPARENT
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SLIDER 1)
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 1)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_SLIDER
            SubType:        SS_A
            DefaultValue:   1.0
            RangeMin:       1.0
            RangeMax:       100.0
            StepCoarse:     1.0
            StepFine:       0.1
            RadioID:        0
            Label:          "COARSE"
            Flags:          MOVEABLE
            Output:         TBoxCoarse
        )

        (sector
            ID:             TBoxFine
            NodeID:         NodeID
            Left:           (grid-x 7)
            Top:            (grid-y 2)
            Width:          (quotient NodeWidth 3)
            Height:         Unit
            Type:           ST_TEXTBOX
            SubType:        SS_A
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       0.0
            StepCoarse:     0.0
            StepFine:       0.0
            RadioID:        0
            Label:          "0.0"
            Flags:          0;TRANSPARENT
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SLIDER 2)
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 2)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_SLIDER
            SubType:        SS_A
            DefaultValue:   1.0
            RangeMin:       0.01
            RangeMax:       10.0
            StepCoarse:     0.1
            StepFine:       0.01
            RadioID:        0
            Label:          "FINE"
            Flags:          MOVEABLE
            Output:         TBoxFine
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_CHECKBOX 1)
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 3)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            SubType:        SS_B
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       1.0
            StepCoarse:     1.0
            StepFine:       0.0
            RadioID:        1
            Label:          "SWITCH"
            Flags:          RADIO
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_CHECKBOX 2)
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 4)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            SubType:        SS_B
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       1.0
            StepCoarse:     1.0
            StepFine:       0.0
            RadioID:        1
            Label:          "SWITCH"
            Flags:          RADIO
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_CHECKBOX 3)
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 5)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            SubType:        SS_B
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       1.0
            StepCoarse:     1.0
            StepFine:       0.0
            RadioID:        1
            Label:          "SWITCH"
            Flags:          RADIO
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX 4)
            NodeID:         NodeID
            Left:           (grid-x 1)
            Top:            (grid-y 3)
            Width:          40
            Height:         Unit
            Type:           ST_TEXTBOX
            SubType:        SS_A
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       0.0
            StepCoarse:     0.0
            StepFine:       0.0
            RadioID:        0
            Label:          "SINE"
            Flags:          TRANSPARENT
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX 5)
            NodeID:         NodeID
            Left:           (grid-x 1)
            Top:            (grid-y 4)
            Width:          (* Unit 3)
            Height:         Unit
            Type:           ST_TEXTBOX
            SubType:        SS_A
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       0.0
            StepCoarse:     0.0
            StepFine:       0.0
            RadioID:        0
            Label:          "SAW"
            Flags:          TRANSPARENT
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX 6)
            NodeID:         NodeID
            Left:           (grid-x 1)
            Top:            (grid-y 5)
            Width:          50
            Height:         Unit
            Type:           ST_TEXTBOX
            SubType:        SS_A
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       0.0
            StepCoarse:     0.0
            StepFine:       0.0
            RadioID:        0
            Label:          "SQUARE"
            Flags:          TRANSPARENT
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET 0)
            NodeID:         NodeID
            Left:           (grid-x 11)
            Top:            (grid-y 5)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON OUTPUT MOVEABLE)
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET 1)
            NodeID:         NodeID
            Left:           (grid-x 11)
            Top:            (grid-y 6)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON INPUT MOVEABLE)
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET 2)
            NodeID:         NodeID
            Left:           (grid-x 11)
            Top:            (grid-y 7)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON INPUT MOVEABLE)
        )
    ))
)
