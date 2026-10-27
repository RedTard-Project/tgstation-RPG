/// Ratwood's goblins, orcs and dark elves as TG species (Ratwood species_types/roguetown/goblin/goblinp.dm, other/orc.dm,
/// elf/elfd.dm; npc/goblin.dm draws the goblin). Their bodies are Ratwood's sprites as TG body parts, all in one sheet the
/// porter makes (ROGUE_BODIES_ICON): the orc's muscular body and the dark elf's slender one, a state per zone and sex,
/// greyscale and coloured by the skin as Ratwood colours it (the TG mutant colour); the goblin's whole-body sprite of
/// its kind, drawn by the chest. Ears and tusks are Ratwood's sprites too, and worn things, hair and held items sit where
/// Ratwood puts them on that body: its offset_features per species and sex, ported as rogue_offsets.

/datum/species
	/// Ratwood's offset_features: per sex ("m", "f") the offset keys (TG's OFFSET_* and the module's ROGUE_OFFSET_*) and
	/// their list(x, y) shift (rockhill/ported/species.dm).
	var/list/rogue_offsets
	/// The skin a body of this species gets when nothing else sets it (an orc spawned by hand is green).
	var/rogue_default_skin
	/// Which goblin's sprite the goblin body parts draw (Ratwood raceicon).
	var/rogue_goblin_kind
	/// Players pick it on medieval maps (Ratwood's playable races).
	var/rogue_playable = FALSE
	/// Ratwood's race_bonus as an attribute sheet (rockhill/ported/species.dm).
	var/rogue_race_sheet
	/// Ratwood's inherent_traits of the race.
	var/list/rogue_race_traits
	/// Whose clothes the race wears, "m" or "f" (Ratwood use_m: the women wear the men's, use_f: the men the women's).
	var/rogue_worn_sex
	/// Ratwood's desc of the race, without its markup: the description and, by paragraph, the lore of the preferences.
	var/rogue_description
	var/list/rogue_lore

/datum/species/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE, replace_missing = TRUE)
	if(rogue_default_skin && !pref_load)
		human_who_gained_species.dna.features[FEATURE_MUTANT_COLOR] = rogue_default_skin
	. = ..()
	for(var/trait in rogue_race_traits)
		ADD_TRAIT(human_who_gained_species, trait, SPECIES_TRAIT)
	human_who_gained_species.rogue_update_race_sheet()

/datum/species/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	for(var/trait in rogue_race_traits)
		REMOVE_TRAIT(human, trait, SPECIES_TRAIT)
	return ..()

/// Ratwood's playable races are picked by players on medieval maps, beside what the config allows.
/datum/species/check_roundstart_eligible()
	if(rogue_playable && rogue_combat_enabled())
		return TRUE
	return ..()

/// The race's stat bonuses on its page of the preferences.
/datum/species/create_pref_unique_perks()
	. = ..()
	if(!rogue_race_sheet)
		return
	if(!GLOB.rogue_attribute_sheets[rogue_race_sheet])
		GLOB.rogue_attribute_sheets[rogue_race_sheet] = new rogue_race_sheet
	var/datum/attribute_holder/sheet/sheet = GLOB.rogue_attribute_sheets[rogue_race_sheet]
	for(var/datum/attribute/stat as anything in sheet.raw_attribute_list)
		var/amount = sheet.raw_attribute_list[stat]
		if(!amount)
			continue
		LAZYADD(., list(list(
			SPECIES_PERK_TYPE = amount > 0 ? SPECIES_POSITIVE_PERK : SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = amount > 0 ? FA_ICON_ARROW_UP : FA_ICON_ARROW_DOWN,
			SPECIES_PERK_NAME = "[initial(stat.name)] [amount > 0 ? "+" : ""][amount]",
			SPECIES_PERK_DESC = "Ratwood's racial bonus to [LOWER_TEXT(initial(stat.name))].",
		)))

/mob/living/carbon/human
	/// The race sheet of attributes this body has now (it moves with the species).
	var/rogue_race_sheet

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	rogue_update_race_sheet()

/// Swaps the race's stat bonuses for the current species'; before the attributes exist (species set early in
/// Initialize) it waits for them. Ratwood's NPCs go without: their outfits set the stats outright (H.STASTR = 16).
/mob/living/carbon/human/proc/rogue_update_race_sheet()
	var/wanted = rogue_npc ? null : dna?.species?.rogue_race_sheet
	if(wanted == rogue_race_sheet || !istype(attributes, /datum/attribute_holder))
		return
	if(rogue_race_sheet)
		attributes.subtract_sheet(rogue_race_sheet)
	rogue_race_sheet = wanted
	if(wanted)
		attributes.add_sheet(wanted)

/datum/species/rogue_orc
	name = "Orc"
	id = "rogue_orc"
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	rogue_default_skin = "#50715C"
	rogue_playable = TRUE
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/rogue_orc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/rogue_orc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/rogue_orc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/rogue_orc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/rogue_orc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/rogue_orc,
	)

/datum/species/rogue_orc/get_species_description()
	return rogue_description

/datum/species/rogue_orc/get_species_lore()
	return rogue_lore

/datum/species/rogue_drow
	name = "Dark Elf"
	id = "rogue_drow"
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	rogue_default_skin = "#5F5F70"
	rogue_playable = TRUE
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/rogue_drow,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/rogue_drow,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/rogue_drow,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/rogue_drow,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/rogue_drow,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/rogue_drow,
	)

/datum/species/rogue_drow/get_species_description()
	return rogue_description

/datum/species/rogue_drow/get_species_lore()
	return rogue_lore

/// Ratwood's playable goblin (goblinp): a small body (anthro_small_male, the woman's fd) wearing the women's clothes
/// lower down, goblin ears, no underwear drawn (TG's would not fit the small body).
/datum/species/rogue_goblinp
	name = "Goblin"
	id = "rogue_goblinp"
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_NO_UNDERWEAR,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	rogue_default_skin = "#4C6835"
	rogue_playable = TRUE
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/rogue_goblinp,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/rogue_goblinp,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/rogue_goblinp,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/rogue_goblinp,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/rogue_goblinp,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/rogue_goblinp,
	)

/datum/species/rogue_goblinp/get_species_description()
	return rogue_description

/datum/species/rogue_goblinp/get_species_lore()
	return rogue_lore

/// Ratwood's goblin: one sprite for the whole body, no hair, eyes or underwear drawn, a male voice and build only, and
/// no shirt, trousers, mask, gloves or shoes (no_equip); worn armor and helmets show as the goblin's own.
/datum/species/rogue_goblin
	name = "Goblin"
	id = "rogue_goblin"
	sexes = FALSE
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_ROGUE_GOBLIN_BODY,
	)
	no_equip_flags = ITEM_SLOT_MASK | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE | ITEM_SLOT_ROGUE_SHIRT
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	rogue_goblin_kind = "goblin"
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/rogue_goblin,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/rogue_goblin,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/rogue_goblin,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/rogue_goblin,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/rogue_goblin,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/rogue_goblin,
	)

/datum/species/rogue_goblin/cave
	name = "Cave Goblin"
	id = "rogue_goblin_cave"
	rogue_goblin_kind = "goblin_cave"

/datum/species/rogue_goblin/hell
	name = "Hell Goblin"
	id = "rogue_goblin_hell"
	rogue_goblin_kind = "goblin_hell"

/datum/species/rogue_goblin/sea
	name = "Sea Goblin"
	id = "rogue_goblin_sea"
	rogue_goblin_kind = "goblin_sea"

/datum/species/rogue_goblin/moon
	name = "Moon Goblin"
	id = "rogue_goblin_moon"
	rogue_goblin_kind = "goblin_moon"

/// Where each offset key goes: the body zone ("arm" and "leg" for both) and the TG variable that holds it, if TG reads
/// one (the module's own layers read feature_offsets).
GLOBAL_LIST_INIT(rogue_offset_parts, list(
	OFFSET_HEAD = list(BODY_ZONE_HEAD, "worn_head_offset"),
	OFFSET_FACE = list(BODY_ZONE_HEAD, "worn_face_offset"),
	OFFSET_FACEMASK = list(BODY_ZONE_HEAD, "worn_mask_offset"),
	OFFSET_GLASSES = list(BODY_ZONE_HEAD, "worn_glasses_offset"),
	OFFSET_EARS = list(BODY_ZONE_HEAD, "worn_ears_offset"),
	ROGUE_OFFSET_MOUTH = list(BODY_ZONE_HEAD, null),
	OFFSET_UNIFORM = list(BODY_ZONE_CHEST, "worn_uniform_offset"),
	OFFSET_SUIT = list(BODY_ZONE_CHEST, "worn_suit_offset"),
	OFFSET_S_STORE = list(BODY_ZONE_CHEST, "worn_suit_storage_offset"),
	OFFSET_BELT = list(BODY_ZONE_CHEST, "worn_belt_offset"),
	OFFSET_BACK = list(BODY_ZONE_CHEST, "worn_back_offset"),
	OFFSET_NECK = list(BODY_ZONE_CHEST, "worn_neck_offset"),
	OFFSET_ID = list(BODY_ZONE_CHEST, "worn_id_offset"),
	ROGUE_OFFSET_SHIRT = list(BODY_ZONE_CHEST, null),
	ROGUE_OFFSET_CLOAK = list(BODY_ZONE_CHEST, null),
	ROGUE_OFFSET_WRISTS = list(BODY_ZONE_CHEST, null),
	ROGUE_OFFSET_RING = list(BODY_ZONE_CHEST, null),
	OFFSET_GLOVES = list("arm", "worn_glove_offset"),
	OFFSET_HELD = list("arm", "held_hand_offset"),
	OFFSET_SHOES = list("leg", "worn_foot_offset"),
))

/obj/item/bodypart
	/// Offset keys this part took from its owner's rogue_offsets, so a change of sex can clear them.
	var/list/rogue_offset_keys
	/// The goblin's kind the part was last on (goblin parts draw that sprite, also once cut off).
	var/rogue_kind = "goblin"

/obj/item/bodypart/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	if(!. || !owner?.dna?.species)
		return
	var/datum/species/owner_species = owner.dna.species
	if(owner_species.rogue_goblin_kind)
		rogue_kind = owner_species.rogue_goblin_kind
	if(owner_species.rogue_offsets || rogue_offset_keys)
		rogue_apply_offsets(owner_species.rogue_offsets?[limb_gender])

/// Shifts where worn things sit on this part as Ratwood does for the owner's species and sex; keys the part no longer
/// gets go back to no shift.
/obj/item/bodypart/proc/rogue_apply_offsets(list/offsets)
	for(var/key in GLOB.rogue_offset_parts)
		var/list/where = GLOB.rogue_offset_parts[key]
		if(!rogue_offset_fits(where[1]))
			continue
		var/list/shift = offsets?[key]
		var/datum/worn_feature_offset/offset = feature_offsets[key]
		if(!shift)
			if(offset && (key in rogue_offset_keys))
				offset.offset_x = list("south" = 0)
				offset.offset_y = list("south" = 0)
			continue
		if(!offset)
			offset = new(src, key)
			if(where[2])
				vars[where[2]] = offset
		offset.offset_x = list("south" = shift[1])
		offset.offset_y = list("south" = shift[2])
		LAZYOR(rogue_offset_keys, key)

/obj/item/bodypart/proc/rogue_offset_fits(zone)
	switch(zone)
		if("arm")
			return istype(src, /obj/item/bodypart/arm)
		if("leg")
			return istype(src, /obj/item/bodypart/leg)
	return body_zone == zone

/obj/item/bodypart/arm
	/// The hand has its own state per sex (<limb_id>_<hand>_<m|f>): TG names the hand without it.
	var/rogue_sexed_hand = FALSE

/obj/item/bodypart/arm/get_limb_icon(dropped)
	. = ..()
	if(!rogue_sexed_hand || !aux_zone)
		return
	var/state = "[limb_id]_[aux_zone]"
	for(var/image/part as anything in .)
		if(part.icon_state == state)
			part.icon_state = "[state]_[limb_gender]"

/// Ratwood's ears and tusks on the head, its sprite accessories: ADJ and FRONT layers, moved with the face as Ratwood
/// moves them (OFFSET_FACE), hidden under what covers them.
/datum/bodypart_overlay/simple/rogue_feature
	icon = ROGUE_BODIES_ICON
	layers = list("ADJ" = BODY_ADJ_LAYER, "FRONT" = BODY_FRONT_LAYER)
	offset_location = UPPER_BODY
	/// Takes the colour of the skin under it, as Ratwood's ears do (KEY_SKIN_COLOR).
	var/skin_coloured = FALSE
	/// Worn flags that hide it.
	var/hidden_by = HIDEEARS

/datum/bodypart_overlay/simple/rogue_feature/get_image(obj/item/bodypart/limb, layer_index, layer_real)
	. = ..()
	var/obj/item/bodypart/head/head = limb
	if(istype(head))
		head.worn_face_offset?.apply_offset(.)

/datum/bodypart_overlay/simple/rogue_feature/color_image(image/overlay, obj/item/bodypart/limb, layer_index)
	overlay.color = skin_coloured ? limb.draw_color : draw_color

/datum/bodypart_overlay/simple/rogue_feature/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner, mob/living/carbon/owner)
	. = ..()
	var/mob/living/carbon/human/wearer = owner
	if(. && istype(wearer) && (wearer.obscured_slots & hidden_by))
		return FALSE

/datum/bodypart_overlay/simple/rogue_feature/halforc_ears
	icon_state = "rogue_ears_halforc"
	skin_coloured = TRUE

/datum/bodypart_overlay/simple/rogue_feature/halforc_tusks
	icon_state = "rogue_tusks_halforc"
	layers = list("FRONT" = BODY_FRONT_LAYER)
	draw_color = "#F4F4BE"
	hidden_by = HIDESNOUT

/datum/bodypart_overlay/simple/rogue_feature/elf_ears
	icon_state = "rogue_ears_elf"
	skin_coloured = TRUE

/datum/bodypart_overlay/simple/rogue_feature/goblin_ears
	icon_state = "rogue_ears_goblin"
	skin_coloured = TRUE

// The orc: Ratwood's muscular body (mt_muscular/ft_muscular, the woman wears the man's, use_m), half-orc ears and tusks.

/obj/item/bodypart/head/rogue_orc
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_orc_head_m"
	limb_id = "rogue_orc"
	is_dimorphic = TRUE

/obj/item/bodypart/head/rogue_orc/Initialize(mapload)
	. = ..()
	add_bodypart_overlay(new /datum/bodypart_overlay/simple/rogue_feature/halforc_ears, update = FALSE)
	add_bodypart_overlay(new /datum/bodypart_overlay/simple/rogue_feature/halforc_tusks, update = FALSE)

/obj/item/bodypart/chest/rogue_orc
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_orc_chest_m"
	limb_id = "rogue_orc"
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/rogue_orc
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_orc_l_arm_m"
	limb_id = "rogue_orc"
	is_dimorphic = TRUE
	rogue_sexed_hand = TRUE

/obj/item/bodypart/arm/right/rogue_orc
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_orc_r_arm_m"
	limb_id = "rogue_orc"
	is_dimorphic = TRUE
	rogue_sexed_hand = TRUE

/obj/item/bodypart/leg/left/rogue_orc
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_orc_l_leg_m"
	limb_id = "rogue_orc"
	is_dimorphic = TRUE

/obj/item/bodypart/leg/right/rogue_orc
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_orc_r_leg_m"
	limb_id = "rogue_orc"
	is_dimorphic = TRUE

// The dark elf: Ratwood's elf body (mem/fm) and elf ears.

/obj/item/bodypart/head/rogue_drow
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_drow_head_m"
	limb_id = "rogue_drow"
	is_dimorphic = TRUE

/obj/item/bodypart/head/rogue_drow/Initialize(mapload)
	. = ..()
	add_bodypart_overlay(new /datum/bodypart_overlay/simple/rogue_feature/elf_ears, update = FALSE)

/obj/item/bodypart/chest/rogue_drow
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_drow_chest_m"
	limb_id = "rogue_drow"
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/rogue_drow
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_drow_l_arm_m"
	limb_id = "rogue_drow"
	is_dimorphic = TRUE
	rogue_sexed_hand = TRUE

/obj/item/bodypart/arm/right/rogue_drow
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_drow_r_arm_m"
	limb_id = "rogue_drow"
	is_dimorphic = TRUE
	rogue_sexed_hand = TRUE

/obj/item/bodypart/leg/left/rogue_drow
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_drow_l_leg_m"
	limb_id = "rogue_drow"
	is_dimorphic = TRUE

/obj/item/bodypart/leg/right/rogue_drow
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_drow_r_leg_m"
	limb_id = "rogue_drow"
	is_dimorphic = TRUE

// The playable goblin: Ratwood's small body (anthro_small_male, the woman's fd) and goblin ears.

/obj/item/bodypart/head/rogue_goblinp
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_goblinp_head_m"
	limb_id = "rogue_goblinp"
	is_dimorphic = TRUE

/obj/item/bodypart/head/rogue_goblinp/Initialize(mapload)
	. = ..()
	add_bodypart_overlay(new /datum/bodypart_overlay/simple/rogue_feature/goblin_ears, update = FALSE)

/obj/item/bodypart/chest/rogue_goblinp
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_goblinp_chest_m"
	limb_id = "rogue_goblinp"
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/rogue_goblinp
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_goblinp_l_arm_m"
	limb_id = "rogue_goblinp"
	is_dimorphic = TRUE
	rogue_sexed_hand = TRUE

/obj/item/bodypart/arm/right/rogue_goblinp
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_goblinp_r_arm_m"
	limb_id = "rogue_goblinp"
	is_dimorphic = TRUE
	rogue_sexed_hand = TRUE

/obj/item/bodypart/leg/left/rogue_goblinp
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_goblinp_l_leg_m"
	limb_id = "rogue_goblinp"
	is_dimorphic = TRUE

/obj/item/bodypart/leg/right/rogue_goblinp
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_greyscale = ROGUE_BODIES_ICON
	icon_state = "rogue_goblinp_r_leg_m"
	limb_id = "rogue_goblinp"
	is_dimorphic = TRUE

// The goblin: the chest draws the whole body of the goblin's kind (headless once the head is off, as Ratwood's _decap),
// the other parts draw nothing; the severed head is Ratwood's head sprite. Only the head comes off, as at Ratwood
// (dismemberable = 0 on the other parts). No wound overlays, as Ratwood's goblin has none.

/obj/item/bodypart/head/rogue_goblin
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_state = "rogue_goblin_head"
	limb_id = "rogue_goblin"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	head_flags = NONE
	dmg_overlay_type = null

/obj/item/bodypart/head/rogue_goblin/get_limb_icon(dropped)
	. = ..()
	if(dropped)
		. += image(ROGUE_BODIES_ICON, "[rogue_kind]_severed", dir = SOUTH)

/obj/item/bodypart/head/rogue_goblin/generate_icon_key()
	. = ..()
	. += rogue_kind

/obj/item/bodypart/chest/rogue_goblin
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_state = "rogue_goblin_chest"
	limb_id = "rogue_goblin"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	bodypart_flags = BODYPART_UNREMOVABLE

/obj/item/bodypart/chest/rogue_goblin/get_limb_icon(dropped)
	. = ..()
	var/plain = "[limb_id]_[body_zone]"
	var/state = rogue_body_state()
	for(var/image/part as anything in .)
		if(part.icon_state == plain)
			part.icon_state = state

/obj/item/bodypart/chest/rogue_goblin/generate_icon_key()
	. = ..()
	. += rogue_body_state()

/obj/item/bodypart/chest/rogue_goblin/proc/rogue_body_state()
	return "[rogue_kind][owner && !owner.get_bodypart(BODY_ZONE_HEAD) ? "_decap" : ""]_chest"

/obj/item/bodypart/arm/left/rogue_goblin
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_state = "rogue_goblin_l_arm"
	limb_id = "rogue_goblin"
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	bodypart_flags = BODYPART_UNREMOVABLE

/obj/item/bodypart/arm/right/rogue_goblin
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_state = "rogue_goblin_r_arm"
	limb_id = "rogue_goblin"
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	bodypart_flags = BODYPART_UNREMOVABLE

/obj/item/bodypart/leg/left/rogue_goblin
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_state = "rogue_goblin_l_leg"
	limb_id = "rogue_goblin"
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	bodypart_flags = BODYPART_UNREMOVABLE

/obj/item/bodypart/leg/right/rogue_goblin
	icon = ROGUE_BODIES_ICON
	icon_static = ROGUE_BODIES_ICON
	icon_state = "rogue_goblin_r_leg"
	limb_id = "rogue_goblin"
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	bodypart_flags = BODYPART_UNREMOVABLE

/obj/item
	/// How a goblin wears this armor or helmet: its state in ROGUE_BODIES_ICON (Ratwood draws the goblin's suit and head
	/// from goblins.dmi by item_state; the porter writes it for the goblin gear).
	var/rogue_goblin_state
