(define L 0)
(define R 0)

(define W 299)
(define H 199)

(define NodeID 1)
(define VOffset 3)

(define LeftMargin 8)

(define descriptors
    (list
    (sector
        ID: NodeID
        NodeID: 0
        Left: 0
        Top: 0
        Width: W
        Height: H
        Type: ST_NODE
        SubType: SS_A
        DefaultValue: 0.0
        RangeMin: -8.0
        RangeMax: 8.0
        StepCoarse: 1.0
        StepFine: 0.1
        RadioID: 0
        Label: "VCO"
        Flags: MOVEABLE
        Output: 0)

    (sector
        ID: 2
        NodeID: NodeID
        Left: LeftMargin
        Top: 8
        Width: (quotient W 3)
        Height: 10
        Type: ST_TEXTBOX
        SubType: SS_A
        DefaultValue: 0.0
        RangeMin: -8.0
        RangeMax: 8.0
        StepCoarse: 1.0
        StepFine: 0.1
        RadioID: 0
        Label: "OSCILLATOR"
        Flags: TRANSPARENT
        Output: 0)

    (sector
        ID: 3
        NodeID: NodeID
        Left: (+ (quotient W 3) 15)
        Top: (+ 25 VOffset)
        Width: (quotient W 3)
        Height: 10
        Type: ST_TEXTBOX
        SubType: SS_A
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 0.0
        StepCoarse: 0.0
        StepFine: 0.0
        RadioID: 0
        Label: "0.00"
        Flags: TRANSPARENT
        Output: 0)

    (sector
        ID: 4
        NodeID: NodeID
        Left: LeftMargin
        Top: 25
        Width: (quotient W 3)
        Height: 12
        Type: ST_SLIDER
        SubType: SS_A
        DefaultValue: 1.0
        RangeMin: 1.0
        RangeMax: 100.0
        StepCoarse: 1.0
        StepFine: 0.1
        RadioID: 0
        Label: "COARSE"
        Flags: MOVEABLE
        Output: 3)

    (sector
        ID: 5
        NodeID: NodeID
        Left: (+ (quotient W 3) 15)
        Top: (+ 45 VOffset)
        Width: (quotient W 3)
        Height: 10
        Type: ST_TEXTBOX
        SubType: SS_A
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 0.0
        StepCoarse: 0.0
        StepFine: 0.0
        RadioID: 0
        Label: "0.0"
        Flags: TRANSPARENT
        Output: 0)

    (sector
        ID: 6
        NodeID: NodeID
        Left: LeftMargin
        Top: 45
        Width: (quotient W 3)
        Height: 12
        Type: ST_SLIDER
        SubType: SS_A
        DefaultValue: 1.0
        RangeMin: 0.01
        RangeMax: 10.0
        StepCoarse: 0.1
        StepFine: 0.01
        RadioID: 0
        Label: "FINE"
        Flags: MOVEABLE
        Output: 5)

    (sector
        ID: 7
        NodeID: NodeID
        Left: LeftMargin
        Top: 65
        Width: 10
        Height: 10
        Type: ST_CHECKBOX
        SubType: SS_B
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 1.0
        StepCoarse: 1.0
        StepFine: 0.0
        RadioID: 1
        Label: "SWITCH"
        Flags: RADIO
        Output: 0)

    (sector
        ID: 8
        NodeID: NodeID
        Left: LeftMargin
        Top: 79
        Width: 10
        Height: 10
        Type: ST_CHECKBOX
        SubType: SS_B
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 1.0
        StepCoarse: 1.0
        StepFine: 0.0
        RadioID: 1
        Label: "SWITCH"
        Flags: RADIO
        Output: 0)

    (sector
        ID: 9
        NodeID: NodeID
        Left: LeftMargin
        Top: 93
        Width: 10
        Height: 10
        Type: ST_CHECKBOX
        SubType: SS_B
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 1.0
        StepCoarse: 1.0
        StepFine: 0.0
        RadioID: 1
        Label: "SWITCH"
        Flags: RADIO
        Output: 0)

    (sector
        ID: 10
        NodeID: NodeID
        Left: (+ 28 LeftMargin)
        Top: 66
        Width: 40
        Height: 10
        Type: ST_TEXTBOX
        SubType: SS_A
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 0.0
        StepCoarse: 0.0
        StepFine: 0.0
        RadioID: 0
        Label: "SINE"
        Flags: TRANSPARENT
        Output: 0)

    (sector
        ID: 11
        NodeID: NodeID
        Left: (+ 28 LeftMargin)
        Top: 80
        Width: 30
        Height: 10
        Type: ST_TEXTBOX
        SubType: SS_A
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 0.0
        StepCoarse: 0.0
        StepFine: 0.0
        RadioID: 0
        Label: "SAW"
        Flags: TRANSPARENT
        Output: 0)

    (sector
        ID: 12
        NodeID: NodeID
        Left: (+ 28 LeftMargin)
        Top: 94
        Width: 50
        Height: 10
        Type: ST_TEXTBOX
        SubType: SS_A
        DefaultValue: 0.0
        RangeMin: 0.0
        RangeMax: 0.0
        StepCoarse: 0.0
        StepFine: 0.0
        RadioID: 0
        Label: "SQUARE"
        Flags: TRANSPARENT
        Output: 0)

)
