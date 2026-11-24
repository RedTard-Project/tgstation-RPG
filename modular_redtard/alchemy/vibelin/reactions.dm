// Written by modular_redtard/tools/port_vibelin_alchemy.py from Vibelin (Vanderlin); do not edit by hand.
// Values of vars only: the bases and every proc are the module's alchemy code (see BASES in the script).
// Mixing reactions (Vibelin recipes/), on TG's reaction holder.

/datum/chemical_reaction/rogue_alchemy/alchemists_clarity
	required_reagents = list(/datum/reagent/buff/intelligence/concentrated = 4, /datum/reagent/medicine/healthpot = 2, /datum/reagent/water = 2)
	results = list(/datum/reagent/skill_elixir/alchemists_clarity = 10)
	mix_message = "The mixture emits a brief sulfurous flash before settling into a deep violet."

/datum/chemical_reaction/rogue_alchemy/arcane_solvent
	required_reagents = list(/datum/reagent/buff/intelligence/concentrated = 4, /datum/reagent/toxin/manabloom_juice = 4, /datum/reagent/water = 2)
	results = list(/datum/reagent/skill_elixir/arcane_solvent = 10)
	mix_message = "The mixture shifts through blue and violet before settling into a luminous azure."

/datum/chemical_reaction/rogue_alchemy/ashbinders_salve
	required_reagents = list(/datum/reagent/ash = 5, /datum/reagent/medicine/rosawater = 5, /datum/reagent/water = 5)
	results = list(/datum/reagent/medicine/ashbinders_salve = 15)
	mix_message = "The mixture cools and darkens into a thick grey salve."

/datum/chemical_reaction/rogue_alchemy/ashwarden_brew
	required_reagents = list(/datum/reagent/ash = 5, /datum/reagent/medicine/antidote = 5, /datum/reagent/consumable/nutriment/bone_marrow = 2)
	results = list(/datum/reagent/medicine/ashwarden_brew = 12)
	mix_message = "The brew darkens to near-black, releasing a sulphurous cloud."

/datum/chemical_reaction/rogue_alchemy/athletes_brine
	required_reagents = list(/datum/reagent/buff/endurance/concentrated = 4, /datum/reagent/consumable/ethanol/ale = 3, /datum/reagent/water = 3)
	results = list(/datum/reagent/skill_elixir/athletes_brine = 10)
	mix_message = "The mixture clears to a pale green and smells of sea air."

/datum/chemical_reaction/rogue_alchemy/beastwhisper
	required_reagents = list(/datum/reagent/buff/perception/concentrated = 3, /datum/reagent/buff/fortune/concentrated = 3, /datum/reagent/tree_sap = 2, /datum/reagent/consumable/nutriment/bone_marrow = 2)
	results = list(/datum/reagent/skill_elixir/beastwhisper = 10)
	mix_message = "The mixture turns a pale green and gives off a smell that is oddly calming."

/datum/chemical_reaction/rogue_alchemy/blade_arts_tincture
	required_reagents = list(/datum/reagent/buff/speed/concentrated = 3, /datum/reagent/buff/strength/concentrated = 3, /datum/reagent/blood = 2, /datum/reagent/consumable/eggyolk = 2)
	results = list(/datum/reagent/skill_elixir/blade_arts = 10)
	mix_message = "The mixture turns a deep arterial red and smells sharply of iron."

/datum/chemical_reaction/rogue_alchemy/blistergall
	required_reagents = list(/datum/reagent/medicine/soporpot = 3, /datum/reagent/toxin/venom = 5, /datum/reagent/water = 5)
	results = list(/datum/reagent/poison/blistergall = 13)
	mix_message = "The mixture boils with a caustic hiss before settling into a neon green slurry."

/datum/chemical_reaction/rogue_alchemy/bloodelder_wine
	required_reagents = list(/datum/reagent/blood = 5, /datum/reagent/medicine/healthpot = 5, /datum/reagent/water = 5)
	results = list(/datum/reagent/medicine/bloodelder_wine = 15)
	mix_message = "The blood dissolves into the mixture, yielding a dark crimson wine."

/datum/chemical_reaction/rogue_alchemy/brewers_wort
	required_reagents = list(/datum/reagent/buff/intelligence/concentrated = 4, /datum/reagent/consumable/sugar = 3, /datum/reagent/water = 3)
	results = list(/datum/reagent/skill_elixir/brewers_wort = 10)
	mix_message = "The mixture clouds to a murky amber and gives off a yeasty warmth."

/datum/chemical_reaction/rogue_alchemy/builders_draught
	required_reagents = list(/datum/reagent/buff/strength/concentrated = 4, /datum/reagent/ash = 3, /datum/reagent/water = 3)
	results = list(/datum/reagent/skill_elixir/builders_draught = 10)
	mix_message = "The mixture turns gritty and pale, smelling of cut wood and stone."

/datum/chemical_reaction/rogue_alchemy/coldvein_compress
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/medicine/antidote = 5, /datum/reagent/mercury = 3)
	results = list(/datum/reagent/medicine/coldvein_compress = 13)
	mix_message = "The solution drops sharply in temperature, exhaling a fine cold mist."

/datum/chemical_reaction/rogue_alchemy/cooks_brine
	required_reagents = list(/datum/reagent/buff/intelligence/concentrated = 4, /datum/reagent/consumable/nutriment/bone_marrow = 3, /datum/reagent/consumable/honey = 3)
	results = list(/datum/reagent/skill_elixir/cooks_brine = 10)
	mix_message = "The mixture takes on a rich golden colour and smells of a busy kitchen."

/datum/chemical_reaction/rogue_alchemy/craftsmans_wit
	required_reagents = list(/datum/reagent/buff/intelligence/concentrated = 4, /datum/reagent/ash = 3, /datum/reagent/toxin/fyritiusnectar = 1)
	results = list(/datum/reagent/skill_elixir/craftsmans_wit = 10)
	mix_message = "The mixture darkens and smells sharply of metal shavings and machine oil."

/datum/chemical_reaction/rogue_alchemy/crystalline_lymph
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/medicine/manapot = 5, /datum/reagent/medicine/antidote = 3)
	results = list(/datum/reagent/medicine/crystalline_lymph = 13)
	mix_message = "The liquid shimmers and briefly becomes almost transparent before settling."

/datum/chemical_reaction/rogue_alchemy/farmers_almanac_tonic
	required_reagents = list(/datum/reagent/buff/intelligence/concentrated = 4, /datum/reagent/caveweep = 3, /datum/reagent/consumable/honey = 3)
	results = list(/datum/reagent/skill_elixir/farmers_almanac = 10)
	mix_message = "The mixture turns a warm earthy brown and smells of turned soil and chamomile."

/datum/chemical_reaction/rogue_alchemy/fever_oil
	required_reagents = list(/datum/reagent/medicine/antidote = 5, /datum/reagent/toxin/plasma = 2, /datum/reagent/water = 5)
	results = list(/datum/reagent/medicine/fever_oil = 12)
	mix_message = "The mix heats rapidly, releasing a spicy burning aroma."

/datum/chemical_reaction/rogue_alchemy/gloomvenom
	required_reagents = list(/datum/reagent/toxin/venom = 5, /datum/reagent/toxin/fentanyl = 5, /datum/reagent/water = 3)
	results = list(/datum/reagent/poison/gloomvenom = 13)
	mix_message = "The venom and fentanyl fuse into a deep purple, slightly luminescent fluid."

/datum/chemical_reaction/rogue_alchemy/grosswaterify
	required_reagents = list(/datum/reagent/water/gross = 1, /datum/reagent/water = 1)
	results = list(/datum/reagent/water/gross = 2)

/datum/chemical_reaction/rogue_alchemy/heatcramp_oil
	required_reagents = list(/datum/reagent/toxin/venom = 5, /datum/reagent/toxin/fyritiusnectar = 3, /datum/reagent/water = 5)
	results = list(/datum/reagent/poison/heatcramp_oil = 13)
	mix_message = "The mixture grows scalding hot, releasing a sharp peppery aroma."

/datum/chemical_reaction/rogue_alchemy/heavy_arms_draught
	required_reagents = list(/datum/reagent/buff/strength/concentrated = 4, /datum/reagent/blood = 3, /datum/reagent/consumable/nutriment/bone_marrow = 3)
	results = list(/datum/reagent/skill_elixir/heavy_arms = 10)
	mix_message = "The mixture thickens and darkens, smelling of old blood and earth."

/datum/chemical_reaction/rogue_alchemy/ichor_of_mending
	required_reagents = list(/datum/reagent/medicine/healthpot = 5, /datum/reagent/ash = 3, /datum/reagent/medicine/rosawater = 5)
	results = list(/datum/reagent/medicine/ichor_of_mending = 13)
	mix_message = "The mixture thickens into a golden viscous ichor."

/datum/chemical_reaction/rogue_alchemy/ironblight
	required_reagents = list(/datum/reagent/mercury = 5, /datum/reagent/toxin/fyritiusnectar = 5, /datum/reagent/toxin/plasma = 2)
	results = list(/datum/reagent/poison/ironblight = 12)
	mix_message = "The reagents combine into a pitch-black fluid that immediately starts corroding the container slightly."

/datum/chemical_reaction/rogue_alchemy/locksmiths_oil
	required_reagents = list(/datum/reagent/buff/perception/concentrated = 4, /datum/reagent/toxin/fyritiusnectar = 4, /datum/reagent/water = 2)
	results = list(/datum/reagent/skill_elixir/locksmiths_oil = 10)
	mix_message = "The mixture shimmers with a faint silvery iridescence."

/datum/chemical_reaction/rogue_alchemy/marksmans_eye_drop
	required_reagents = list(/datum/reagent/buff/perception/concentrated = 4, /datum/reagent/medicine/rosawater = 3, /datum/reagent/water = 3)
	results = list(/datum/reagent/skill_elixir/marksmans_eye = 10)
	mix_message = "The mixture brightens to a clear amber and smells of pine resin."

/datum/chemical_reaction/rogue_alchemy/marrowbrew
	required_reagents = list(/datum/reagent/medicine/healthpot = 5, /datum/reagent/medicine/stampot = 5, /datum/reagent/consumable/nutriment/bone_marrow = 3)
	results = list(/datum/reagent/medicine/marrowbrew = 13)
	mix_message = "The reagents emulsify into a rich, cream-coloured broth."

/datum/chemical_reaction/rogue_alchemy/meth_precursor
	required_reagents = list(/datum/reagent/mercury = 5, /datum/reagent/medicine/soporpot = 5, /datum/reagent/water = 5)
	results = list(/datum/reagent/meth_precursor = 15)
	mix_message = "The mixture foams and takes on a sharp chemical smell."

/datum/chemical_reaction/rogue_alchemy/mindclear_tonic
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/medicine/manapot = 5, /datum/reagent/mercury = 3)
	results = list(/datum/reagent/medicine/mindclear_tonic = 13)
	mix_message = "The mixture briefly turns opaque before clearing into a cool teal fluid."

/datum/chemical_reaction/rogue_alchemy/miners_heart
	required_reagents = list(/datum/reagent/buff/strength/concentrated = 4, /datum/reagent/toxin/fyritiusnectar = 3, /datum/reagent/blood = 3)
	results = list(/datum/reagent/skill_elixir/miners_heart = 10)
	mix_message = "The mixture turns a deep charcoal black, smelling of stone and effort."

/datum/chemical_reaction/rogue_alchemy/miracle_water
	required_reagents = list(/datum/reagent/buff/fortune/concentrated = 4, /datum/reagent/medicine/rosawater = 3, /datum/reagent/water = 3)
	results = list(/datum/reagent/skill_elixir/miracle_water = 10)
	mix_message = "The mixture glows faintly and smells of incense and clean air."

/datum/chemical_reaction/rogue_alchemy/mirelung_brew
	required_reagents = list(/datum/reagent/water/gross = 5, /datum/reagent/toxin/venom = 5, /datum/reagent/toxin/bad_food = 3)
	results = list(/datum/reagent/poison/mirelung_brew = 13)
	mix_message = "The brew settles into a swampy green-brown fluid with a stagnant smell."

/datum/chemical_reaction/rogue_alchemy/mirewort_compress
	required_reagents = list(/datum/reagent/water/gross = 5, /datum/reagent/medicine/antidote = 5, /datum/reagent/ash = 3)
	results = list(/datum/reagent/medicine/mirewort_compress = 13)
	mix_message = "The mixture takes on the murky green quality of bog water."

/datum/chemical_reaction/rogue_alchemy/mirrorwaste
	required_reagents = list(/datum/reagent/mercury = 5, /datum/reagent/toxin/manabloom_juice = 5, /datum/reagent/water = 3)
	results = list(/datum/reagent/poison/mirrorwaste = 13)
	mix_message = "The mercury and mana-laced juice merge into a rippling silver liquid."

/datum/chemical_reaction/rogue_alchemy/nervebind_extract
	required_reagents = list(/datum/reagent/medicine/soporpot = 5, /datum/reagent/water = 5, /datum/reagent/ash = 3)
	results = list(/datum/reagent/medicine/nervebind_extract = 13)
	mix_message = "The soporific thins into a cool purple fluid with a mild numbing scent."

/datum/chemical_reaction/rogue_alchemy/pale_serum
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/mercury = 3, /datum/reagent/consumable/nutriment/bone_marrow = 5)
	results = list(/datum/reagent/medicine/pale_serum = 13)
	mix_message = "The mercury disperses into the solution, leaving a chalky white fluid."

/datum/chemical_reaction/rogue_alchemy/prep_hands_tonic
	required_reagents = list(/datum/reagent/buff/speed/concentrated = 4, /datum/reagent/consumable/eggyolk = 3, /datum/reagent/water = 3)
	results = list(/datum/reagent/skill_elixir/prep_hands_tonic = 10)
	mix_message = "The mixture fizzes and brightens to a vivid herbal green."

/datum/chemical_reaction/rogue_alchemy/quietdeath
	required_reagents = list(/datum/reagent/toxin/amanitin = 5, /datum/reagent/water = 7, /datum/reagent/mercury = 3)
	results = list(/datum/reagent/poison/quietdeath = 15)
	mix_message = "The mixture turns completely clear with barely a sound — not even a bubble."

/datum/chemical_reaction/rogue_alchemy/rotwater
	required_reagents = list(/datum/reagent/water/gross = 7, /datum/reagent/toxin/amatoxin = 3, /datum/reagent/toxin/bad_food = 3)
	results = list(/datum/reagent/poison/rotwater = 13)
	mix_message = "The ingredients slurry together into a revolting brown sludge."

/datum/chemical_reaction/rogue_alchemy/scholars_ink
	required_reagents = list(/datum/reagent/buff/intelligence/concentrated = 4, /datum/reagent/toxin/manabloom_juice = 2, /datum/reagent/toxin/plasma = 2)
	results = list(/datum/reagent/skill_elixir/scholars_ink = 10)
	mix_message = "The mixture turns a deep blue-black and smells of old books and fresh ink."

/datum/chemical_reaction/rogue_alchemy/seamstress_thimble_drop
	required_reagents = list(/datum/reagent/buff/perception/concentrated = 4, /datum/reagent/consumable/honey = 3, /datum/reagent/medicine/rosawater = 3)
	results = list(/datum/reagent/skill_elixir/seamstress_thimble_drop = 10)
	mix_message = "The mixture turns pale and fragrant, with a faint silky sheen."

/datum/chemical_reaction/rogue_alchemy/shadow_tonic
	required_reagents = list(/datum/reagent/buff/speed/concentrated = 3, /datum/reagent/buff/perception/concentrated = 3, /datum/reagent/water = 4)
	results = list(/datum/reagent/skill_elixir/shadow_tonic = 10)
	mix_message = "The mixture fades to near-colourless and gives off almost no scent at all."

/datum/chemical_reaction/rogue_alchemy/shield_bearers_draught
	required_reagents = list(/datum/reagent/buff/endurance/concentrated = 4, /datum/reagent/ash = 3, /datum/reagent/water = 3)
	results = list(/datum/reagent/skill_elixir/shield_bearer = 10)
	mix_message = "The mixture turns a chalky grey and settles heavily in the vessel."

/datum/chemical_reaction/rogue_alchemy/skinners_elixir
	required_reagents = list(/datum/reagent/buff/perception/concentrated = 4, /datum/reagent/blood = 3, /datum/reagent/ash = 3)
	results = list(/datum/reagent/skill_elixir/skinners_elixir = 10)
	mix_message = "The mixture takes on a greasy, amber hue and smells of raw hide."

/datum/chemical_reaction/rogue_alchemy/smelters_patience
	required_reagents = list(/datum/reagent/buff/endurance/concentrated = 5, /datum/reagent/ash = 3, /datum/reagent/blood = 2)
	results = list(/datum/reagent/skill_elixir/smelters_patience = 10)
	mix_message = "The mixture flares briefly warm and settles into a deep orange-brown."

/datum/chemical_reaction/rogue_alchemy/smiths_blood
	required_reagents = list(/datum/reagent/buff/strength/concentrated = 4, /datum/reagent/blood = 3, /datum/reagent/ash = 3)
	results = list(/datum/reagent/skill_elixir/smiths_blood = 10)
	mix_message = "The mixture turns a deep arterial red and smells of the forge."

/datum/chemical_reaction/rogue_alchemy/spiritwood_elixir
	required_reagents = list(/datum/reagent/medicine/healthpot = 5, /datum/reagent/medicine/rosawater = 5, /datum/reagent/medicine/manapot = 5)
	results = list(/datum/reagent/medicine/spiritwood_elixir = 15)
	mix_message = "The three reagents spiral together in pale green light before settling into an elixir."

/datum/chemical_reaction/rogue_alchemy/stonevein_broth
	required_reagents = list(/datum/reagent/medicine/healthpot = 5, /datum/reagent/mercury = 3, /datum/reagent/water = 5)
	results = list(/datum/reagent/medicine/stonevein_broth = 13)
	mix_message = "The reagents fuse into a heavy, silvery-grey broth."

/datum/chemical_reaction/rogue_alchemy/sunpetal_decoction
	required_reagents = list(/datum/reagent/medicine/antidote = 5, /datum/reagent/toxin/fyritiusnectar = 5, /datum/reagent/water = 3)
	results = list(/datum/reagent/medicine/sunpetal_decoction = 13)
	mix_message = "The mix brightens to a warm golden yellow with a sweet floral scent."

/datum/chemical_reaction/rogue_alchemy/thornmorrow_tincture
	required_reagents = list(/datum/reagent/thorn_essence = 5, /datum/reagent/medicine/antidote = 5, /datum/reagent/water = 5)
	results = list(/datum/reagent/medicine/thornmorrow_tincture = 15)
	mix_message = "The tincture darkens to a deep forest green and thickens slowly."

/datum/chemical_reaction/rogue_alchemy/tombsilt_tincture
	required_reagents = list(/datum/reagent/ash = 5, /datum/reagent/medicine/antidote = 5, /datum/reagent/mercury = 3)
	results = list(/datum/reagent/medicine/tombsilt_tincture = 13)
	mix_message = "The concoction turns a deep brownish grey as the ash settles into suspension."

/datum/chemical_reaction/rogue_alchemy/trappers_sense
	required_reagents = list(/datum/reagent/buff/perception/concentrated = 4, /datum/reagent/water = 3, /datum/reagent/consumable/honey = 3)
	results = list(/datum/reagent/skill_elixir/trappers_sense = 10)
	mix_message = "The mixture darkens to a mossy green-brown and smells of wet bark."

/datum/chemical_reaction/rogue_alchemy/vital_ichor
	required_reagents = list(/datum/reagent/buff/constitution/concentrated = 4, /datum/reagent/blood = 3, /datum/reagent/toxin/manabloom_juice = 3)
	results = list(/datum/reagent/skill_elixir/vital_ichor = 10)
	mix_message = "The mixture deepens to a pulsing crimson, smelling of iron and old magic."

/datum/chemical_reaction/rogue_alchemy/vitalroot_draught
	required_reagents = list(/datum/reagent/medicine/antidote = 5, /datum/reagent/water = 5, /datum/reagent/medicine/rosawater = 5)
	results = list(/datum/reagent/medicine/vitalroot_draught = 15)
	mix_message = "The liquid takes on a vibrant green hue as it settles."

/datum/chemical_reaction/rogue_alchemy/whip_hand_oil
	required_reagents = list(/datum/reagent/buff/speed/concentrated = 3, /datum/reagent/buff/perception/concentrated = 3, /datum/reagent/toxin/fyritiusnectar = 1)
	results = list(/datum/reagent/skill_elixir/whip_hand = 10)
	mix_message = "The mixture shimmers as the concentrates merge into a supple, sharp-smelling oil."

/datum/chemical_reaction/rogue_alchemy/wild_draught
	required_reagents = list(/datum/reagent/buff/perception/concentrated = 3, /datum/reagent/buff/fortune/concentrated = 3, /datum/reagent/thorn_essence = 2, /datum/reagent/tree_sap = 2)
	results = list(/datum/reagent/skill_elixir/wild_draught = 10)
	mix_message = "The mixture darkens to a forest green and smells of moss and morning dew."

/datum/chemical_reaction/rogue_alchemy/witchknit_paste
	required_reagents = list(/datum/reagent/ash = 5, /datum/reagent/consumable/ethanol/aqua_vitae = 5, /datum/reagent/water = 3)
	results = list(/datum/reagent/medicine/witchknit_paste = 13)
	mix_message = "The ash dissolves unevenly into the rosawater, forming a pale grey paste."

/datum/chemical_reaction/rogue_alchemy/woundwrack_oil
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/ash = 5, /datum/reagent/tree_sap = 3)
	results = list(/datum/reagent/medicine/woundwrack_oil = 13)
	mix_message = "The mixture separates briefly before fusing into a shimmering amber oil."
