#|
 | patches/init.scm — default patch layout.
 |
 | Loaded from disk via loadPatch() (not #embed). Constructs the initial
 | patch: creates the core rack, instantiates and places modules, wires
 | them to core nodes, and starts the processing thread.
 |
 | Each place-node call is one module:
 |   (place-node rack prefix x y [core-type core-uid])
 |
 | Without core-type/uid, only the GUI is loaded and placed (no core node).
 |#

(define FPS 60)

;;--------------------------------------------------------------------------
;; Core rack — the DSP-side processing graph.
;;--------------------------------------------------------------------------

(define rack (create-rack 16))

;;--------------------------------------------------------------------------
;; Modules — one place-node call per module.
;; With core-type + uid: load GUI + create core node + place + bind.
;; Without: load GUI + place only (menu, CRT, unbound generators).
;;--------------------------------------------------------------------------

(place-node rack "menu"      0   0)
(place-node rack "vco"       200 50   CMT_VCO       #xc)
(place-node rack "generator" 500 50   CMT_GENERATOR #xa)
(place-node rack "generator" 500 175  CMT_GENERATOR #xb)
(place-node rack "generator" 750 175  CMT_GENERATOR #xe)
(place-node rack "crt"       500 300)
(place-node rack "split"     50  350  CMT_SPLIT     #xd)

;;--------------------------------------------------------------------------
;; CRT display refresh rate.
;;--------------------------------------------------------------------------

(set-crt-fps FPS)

;;--------------------------------------------------------------------------
;; Start the core processing thread (runs in the background).
;;--------------------------------------------------------------------------

(start-core rack FPS)
