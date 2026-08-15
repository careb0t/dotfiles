-- Change the default Omarchy look'n'feel.

-- Fix screenshot ghosting bug: skip the layer-shell animation for wayfreeze.
hl.layer_rule({ match = { namespace = "wayfreeze" }, no_anim = true })
