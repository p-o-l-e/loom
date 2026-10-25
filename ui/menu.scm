(define menu-id 0)
(define menu-width 0)
(define menu-height 24)
; Menu bar is pinned to the top border and stretches between the left and
; right window borders when the window is resized.
(define menu-anchors (logior ANCHOR_LEFT ANCHOR_TOP ANCHOR_RIGHT))

; UID of the SAVE button — published for patch.h (loadPatch reads this to
; wire the save handler). Set during menu-descriptor evaluation.
(define menu-save-button-uid #f)

(define (menu-descriptor)
    (let*  ((static-id   (control-counter 0))
            (control-id  (control-counter 0))
            (input-id    (control-counter 0))
            (output-id   (control-counter 0))
            (TBoxNew     (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            (TBoxAbout   (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            (TBoxSave    (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            (BtnNew      (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            (BtnAbout    (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            (BtnSave     (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            )

    (set! menu-save-button-uid BtnSave)

    (list
        (sector
            ID:             menu-id
            Width:          menu-width
            Height:         menu-height
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "MAINMENU"
            Flags:          0
        )

        (sector
            ID:             BtnNew
            NodeID:         menu-id
            Left:           (grid-x 0)
            Top:            (grid-y 0)
            Width:          (grid-x 4)
            Height:         Unit
            Type:           ST_MOMENTARY
            Label:          "NEW"
            Flags:          0
            CallbackTarget: TBoxNew
            CallbackEvent:  F_CE_REPAINT
        )

        (sector
            ID:             TBoxNew
            NodeID:         menu-id
            Left:           (grid-x 1)
            Top:            (grid-y 0)
            Width:          (grid-x 5)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "NEW"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             BtnAbout
            NodeID:         menu-id
            Left:           (grid-x 5)
            Top:            (grid-y 0)
            Width:          (grid-x 4)
            Height:         Unit
            Type:           ST_MOMENTARY
            Label:          "NEW"
            Flags:          0
            CallbackTarget: TBoxAbout
            CallbackEvent:  F_CE_REPAINT
        )

        (sector
            ID:             TBoxAbout
            NodeID:         menu-id
            Left:           (grid-x 6)
            Top:            (grid-y 0)
            Width:          (grid-x 5)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "ABOUT"
            Flags:          TRANSPARENT
        )

        ;; SAVE button — writes the current patch layout to patches/save.scm.
        ;; Its UID is published as menu-save-button-uid; patch.h reads that
        ;; variable to wire the save handler (no hardcoded slot number).
        (sector
            ID:             BtnSave
            NodeID:         menu-id
            Left:           (grid-x 10)
            Top:            (grid-y 0)
            Width:          (grid-x 4)
            Height:         Unit
            Type:           ST_MOMENTARY
            Label:          "SAVE"
            Flags:          0
            CallbackTarget: TBoxSave
            CallbackEvent:  F_CE_REPAINT
        )

        (sector
            ID:             TBoxSave
            NodeID:         menu-id
            Left:           (grid-x 11)
            Top:            (grid-y 0)
            Width:          (grid-x 5)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "SAVE"
            Flags:          TRANSPARENT
        )
        ;---COARSE--------------------------------------------------------------------------------------------------------------


        ;---FINE----------------------------------------------------------------------------------------------------------------




    ))
)
