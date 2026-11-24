// Written by modular_redtard/tools/port_vibelin_alchemy.py from Vibelin (Vanderlin); do not edit by hand.
// Values of vars only: the bases and every proc are the module's alchemy code (see BASES in the script).
// Distillation in the still (Vibelin recipes/distillation/).

/datum/distillation_recipe/aqua_vitae
	name = "Aqua Vitae - Apple"
	id = "aqua_vitae_apple"
	distill_message = "The brandy begins to separate into a concentrated spirit!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy
	results = list(/datum/reagent/consumable/ethanol/aqua_vitae = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/aqua_vitae/pear
	name = "Aqua Vitae - Pear"
	distill_message = "The brandy begins to separate into a concentrated spirit!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy/pear
	results = list(/datum/reagent/consumable/ethanol/aqua_vitae = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/aqua_vitae/plum
	name = "Aqua Vitae - Plum"
	distill_message = "The brandy begins to separate into a concentrated spirit!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/consumable/ethanol/plum_wine
	results = list(/datum/reagent/consumable/ethanol/aqua_vitae = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/aqua_vitae/strawberry
	name = "Aqua Vitae - Strawberry"
	distill_message = "The brandy begins to separate into a concentrated spirit!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy/strawberry
	results = list(/datum/reagent/consumable/ethanol/aqua_vitae = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/aqua_vitae/tangerine
	name = "Aqua Vitae - Tangerine"
	distill_message = "The brandy begins to separate into a concentrated spirit!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/consumable/ethanol/brandy/tangerine
	results = list(/datum/reagent/consumable/ethanol/aqua_vitae = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/concentrated_constitution
	name = "Concentrated Constitution"
	id = "concentrated_constitution"
	distill_message = "The constitution essence thickens into something dense and fortifying!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/buff/constitution
	results = list(/datum/reagent/buff/constitution/concentrated = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/concentrated_endurance
	name = "Concentrated Endurance"
	id = "concentrated_endurance"
	distill_message = "The endurance essence reduces into a tireless, burning concentrate!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/buff/endurance
	results = list(/datum/reagent/buff/endurance/concentrated = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/concentrated_fortune
	name = "Concentrated Fortune"
	id = "concentrated_fortune"
	distill_message = "The fortune essence crystallizes into something impossibly lucky!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/buff/fortune
	results = list(/datum/reagent/buff/fortune/concentrated = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/concentrated_intelligence
	name = "Concentrated Intelligence"
	id = "concentrated_intelligence"
	distill_message = "The intelligence essence clarifies into a razor-sharp concentrate!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/buff/intelligence
	results = list(/datum/reagent/buff/intelligence/concentrated = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/concentrated_mush_toxin
	name = "Amatoxin"
	id = "mush_tox_conc"
	distill_message = "The mushroom toxin starts turning an orangish brown it smells foul."
	distilled_reagent = /datum/reagent/toxin/amanitin
	consume_reagents = TRUE
	results = list(/datum/reagent/toxin/amatoxin = 0.5)
	required_temp = 393.15

/datum/distillation_recipe/concentrated_perception
	name = "Concentrated Perception"
	id = "concentrated_perception"
	distill_message = "The perception essence sharpens into something almost blinding!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/buff/perception
	results = list(/datum/reagent/buff/perception/concentrated = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/concentrated_speed
	name = "Concentrated Speed"
	id = "concentrated_speed"
	distill_message = "The speed essence refines into a heart-hammering concentrate!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/buff/speed
	results = list(/datum/reagent/buff/speed/concentrated = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/concentrated_strength
	name = "Concentrated Strength"
	id = "concentrated_strength"
	distill_message = "The raw strength essence condenses into something almost painfully potent!"
	distill_sound = 'sound/effects/bubbles/bubbles.ogg'
	distilled_reagent = /datum/reagent/buff/strength
	results = list(/datum/reagent/buff/strength/concentrated = 0.5)
	required_temp = 351.15

/datum/distillation_recipe/gloomvenom_refined
	name = "Refined Gloomvenom"
	id = "gloomvenom_refined"
	distill_message = "The venom concentrates through distillation, stripping impurities and deepening its violet hue."
	distilled_reagent = /datum/reagent/poison/gloomvenom
	required_reagents = list(/datum/reagent/toxin/fentanyl = 3)
	consume_reagents = TRUE
	results = list(/datum/reagent/poison/gloomvenom = 1.75)
	required_temp = 383.15

/datum/distillation_recipe/methamphetamine
	name = "Methamphetamine"
	id = "methamphetamine"
	distill_message = "The precursor boils down into a clear crystalline liquid."
	distilled_reagent = /datum/reagent/meth_precursor
	consume_reagents = TRUE
	results = list(/datum/reagent/drug/methamphetamine = 1.5)
	required_temp = 413.15

/datum/distillation_recipe/mirrorwaste_refined
	name = "Refined Mirrorwaste"
	id = "mirrorwaste_refined"
	distill_message = "The mercury burns off and the mirrorwaste concentrates into a purer form."
	distilled_reagent = /datum/reagent/poison/mirrorwaste
	required_reagents = list(/datum/reagent/mercury = 3)
	consume_reagents = TRUE
	results = list(/datum/reagent/poison/mirrorwaste = 1.75)
	required_temp = 393.15

/datum/distillation_recipe/mushroom_toxin
	name = "Amanitin"
	id = "mush_tox"
	distill_message = "The tears turn a pure white and release a foul stench."
	distilled_reagent = /datum/reagent/caveweep
	consume_reagents = TRUE
	results = list(/datum/reagent/toxin/amanitin = 1)
	required_temp = 423.15

/datum/distillation_recipe/quietdeath_concentrated
	name = "Concentrated Quietdeath"
	id = "quietdeath_concentrated"
	distill_message = "The water evaporates away, leaving an even more potent concentrate behind."
	distilled_reagent = /datum/reagent/poison/quietdeath
	required_reagents = list(/datum/reagent/toxin/amanitin = 3)
	consume_reagents = TRUE
	results = list(/datum/reagent/poison/quietdeath = 2)
	required_temp = 373.15

/datum/distillation_recipe/sea_salt
	name = "Sea Salt"
	id = "sea_salt"
	distill_message = "The water boils away leaving salt."
	distilled_reagent = /datum/reagent/water/salt
	consume_reagents = TRUE
	results = list(/datum/reagent/consumable/salt = 0.2, /datum/reagent/water = 0.8)
	required_temp = 373.15

/datum/distillation_recipe/soulweave_distillate
	name = "Soulweave Distillate"
	id = "soulweave_distillate"
	distill_message = "The pale serum and rosawater fuse into a faintly luminescent distillate."
	distilled_reagent = /datum/reagent/medicine/pale_serum
	required_reagents = list(/datum/reagent/medicine/rosawater = 5)
	consume_reagents = TRUE
	results = list(/datum/reagent/medicine/soulweave_distillate = 1.5)
	required_temp = 423.15

/datum/distillation_recipe/vitalroot_distilled
	name = "Distilled Vitalroot"
	id = "vitalroot_distilled"
	distill_message = "The vitalroot draught and rosawater condense through the heat into a spiritwood-like elixir."
	distilled_reagent = /datum/reagent/medicine/vitalroot_draught
	required_reagents = list(/datum/reagent/medicine/rosawater = 5)
	results = list(/datum/reagent/medicine/spiritwood_elixir = 1.25)
	required_temp = 403.15
