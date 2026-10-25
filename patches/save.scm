#|
 | patches/save.scm — saved patch layout.
 |
 | Written by the menu SAVE button (patch.h:patch_save_current).
 | Mirrors patches/init.scm: creates the core rack, instantiates and
 | places modules, wires them to core nodes, restores cord
 | connections, and starts the processing thread.
 |
 | Each connect-sockets call is one cable:
 |   (connect-sockets output-socket-uid input-socket-uid)
 |
 | Each set-control call is one control value:
 |   (set-control control-uid value)
 |#

(define FPS 60)

;;--------------------------------------------------------------------------
;; Core rack — the DSP-side processing graph.
;;--------------------------------------------------------------------------

(define rack (create-rack 16))

;;--------------------------------------------------------------------------
;; Modules — one place-node call per module.
;; With core-type: load GUI + create core node + place + bind.
;; Without: load GUI + place only (menu, CRT, unbound generators).
;;--------------------------------------------------------------------------

(place-node rack "menu"      0   0)
(place-node rack "vco"       0   25   CMT_VCO)
(place-node rack "generator" 0   225  CMT_GENERATOR)
(place-node rack "generator" 0   325  CMT_GENERATOR)
(place-node rack "generator" 0   425  CMT_GENERATOR)
(place-node rack "crt"       350 75)
(place-node rack "split"     250 325  CMT_SPLIT)

;;--------------------------------------------------------------------------
;; Cord connections — one connect-sockets call per cable (output → input).
;;--------------------------------------------------------------------------

(connect-sockets #x1000300 #x3000200)
(connect-sockets #x1010300 #x3000201)

;;--------------------------------------------------------------------------
;; Control values — one set-control call per control (slider, encoder,
;; checkbox). Value is the displayed total (coarse + fine).
;;--------------------------------------------------------------------------

(set-control #x2000100 1)
(set-control #x2000101 1)
(set-control #x2000102 0)
(set-control #x2000103 0)
(set-control #x2000104 0)
(set-control #x2000105 0)
(set-control #x2000106 0)
(set-control #x2000107 0)
(set-control #x2000108 1)
(set-control #x1000100 100)
(set-control #x1000101 1)
(set-control #x1000102 0.349999994)
(set-control #x1010100 42)
(set-control #x1010101 1)
(set-control #x1010102 0.25999999)
(set-control #x1020100 1)
(set-control #x1020101 1)
(set-control #x1020102 0)
(set-control #x5000100 0)
(set-control #x5000101 0)

;;--------------------------------------------------------------------------
;; CRT display refresh rate.
;;--------------------------------------------------------------------------

(set-crt-fps FPS)

;;--------------------------------------------------------------------------
;; Start the core processing thread (runs in the background).
;;--------------------------------------------------------------------------

(start-core rack FPS)
