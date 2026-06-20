(define NodeWidth   299)
(define NodeHeight  199)

(define NodeID      1)

(define descriptors
    (list
        (sector
            ID:             NodeID
            Left:           0
            Top:            0
            Width:          NodeWidth
            Height:         NodeHeight
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "VCO"
            Flags:          MOVEABLE
        )

        (sector
            ID:             2
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 0)
            Width:          (quotient NodeWidth 3)
            Height:         (grid-x 1)
            Type:           ST_TEXTBOX
            SubType:        SS_A
            DefaultValue:   0.0
            RangeMin:       -8.0
            RangeMax:       8.0
            StepCoarse:     1.0
            StepFine:       0.1
            Label:          "OSCILLATOR"
            Flags:          TRANSPARENT
            Output:         0
        )

        (sector
            ID:             3
            NodeID:         NodeID
            Left:           (grid-x 7)
            Top:            (grid-y 1)
            Width:          (quotient NodeWidth 3)
            Height:         10
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
            ID:             4
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 1)
            Width:          (* 6 GridStepX)
            Height:         12
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
            Output:         3
        )

        (sector
            ID:             5
            NodeID:         NodeID
            Left:           (grid-x 7)
            Top:            (grid-y 2)
            Width:          (quotient NodeWidth 3)
            Height:         10
            Type:           ST_TEXTBOX
            SubType:        SS_A
            DefaultValue:   0.0
            RangeMin:       0.0
            RangeMax:       0.0
            StepCoarse:     0.0
            StepFine:       0.0
            RadioID:        0
            Label:          "0.0"
            Flags:          TRANSPARENT
            Output:         0
        )

        (sector
            ID:             6
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 2)
            Width:          (* 6 GridStepX)
            Height:         12
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
            Output:         5
        )

        (sector
            ID:             7
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 3)
            Width:          10
            Height:         10
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
            ID:             8
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 4)
            Width:          10
            Height:         10
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
            ID:             9
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 5)
            Width:          10
            Height:         10
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
            ID:             10
            NodeID:         NodeID
            Left:           (grid-x 1)
            Top:            (grid-y 3)
            Width:          40
            Height:         10
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
            ID:             11
            NodeID:         NodeID
            Left:           (grid-x 1)
            Top:            (grid-y 4)
            Width:          30
            Height:         10
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
            ID:             12
            NodeID:         NodeID
            Left:           (grid-x 1)
            Top:            (grid-y 5)
            Width:          50
            Height:         10
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
            ID:             13
            NodeID:         NodeID
            Left:           (grid-x 14)
            Top:            (grid-y 5)
            Width:          10
            Height:         10
            Type:           ST_SOCKET
            Flags:          (logior INTERCON INPUT MOVEABLE)
        )
    )
)
