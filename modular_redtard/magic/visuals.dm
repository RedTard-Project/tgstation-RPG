/// Vibelin's cast visuals (datums/mana/attunement.dm, spells/_casting/casting.dm, temporary_visuals/spell_impact.dm): while a
/// spell charges a rune in its colour turns under the caster and motes rise from it; a spell that goes off leaves a wave
/// rising off the caster; a spell bolt flashes where it strikes (projectile.dm). The times are those of the animations in
/// spell_cast.dmi (Vibelin icons/effects/spell_cast.dmi).

/mob/living
	/// The rune under the caster while a spell charges (Vibelin /mob/var/spell_rune).
	var/obj/effect/rogue_spell_rune/rogue_spell_rune

/// Vibelin start_spell_visual_effects(): the rune and its motes.
/mob/living/proc/rogue_start_spell_visuals(spell_color)
	if(QDELETED(src))
		return
	rogue_cancel_spell_visuals()
	rogue_spell_rune = new(null, src, spell_color)
	vis_contents |= rogue_spell_rune
	rogue_spell_particles(spell_color, rogue_spell_rune)

/// Vibelin start_spell_particles(): motes rise from the rune for as long as it lasts.
/mob/living/proc/rogue_spell_particles(spell_color, obj/effect/rogue_spell_rune/rune)
	if(QDELETED(src) || QDELETED(rune) || rogue_spell_rune != rune)
		return
	var/obj/effect/temp_visual/rogue_spell_cast/rogue_spell_particles/particles = new(null, src, rune)
	particles.color = spell_color
	vis_contents |= particles
	addtimer(CALLBACK(src, PROC_REF(rogue_spell_particles), spell_color, rune), 3.6 SECONDS)

/// Vibelin finish_spell_visual_effects(): the rune goes and a wave rises.
/mob/living/proc/rogue_finish_spell_visuals(spell_color)
	if(QDELETED(src))
		return
	rogue_cancel_spell_visuals()
	var/obj/effect/temp_visual/rogue_spell_cast/rogue_spell_wave/wave = new(null, src)
	wave.color = spell_color
	vis_contents |= wave

/// Vibelin cancel_spell_visual_effects().
/mob/living/proc/rogue_cancel_spell_visuals()
	if(rogue_spell_rune)
		QDEL_NULL(rogue_spell_rune)

/datum/action/cooldown/spell/rogue/proc/finish_spell_visuals()
	if(isliving(owner))
		var/mob/living/caster = owner
		caster.rogue_finish_spell_visuals(spell_color || ROGUE_SPELL_DEFAULT_COLOR)

/datum/action/cooldown/spell/rogue/proc/cancel_spell_visuals()
	if(isliving(owner))
		var/mob/living/caster = owner
		caster.rogue_cancel_spell_visuals()

/// Vibelin /obj/effect/spell_rune.
/obj/effect/rogue_spell_rune
	icon = ROGUE_SPELL_CAST_ICON
	icon_state = "rune"
	vis_flags = VIS_INHERIT_PLANE
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SET_BASE_PIXEL(-8, -8)
	var/datum/weakref/holder_ref

/obj/effect/rogue_spell_rune/Initialize(mapload, mob/living/holder, spell_color)
	. = ..()
	color = spell_color
	holder_ref = WEAKREF(holder)
	add_overlay(emissive_appearance(icon, icon_state, holder || src, alpha = alpha))

/obj/effect/rogue_spell_rune/Destroy(force)
	var/mob/living/holder = holder_ref?.resolve()
	if(holder)
		holder.vis_contents -= src
		if(holder.rogue_spell_rune == src)
			holder.rogue_spell_rune = null
	holder_ref = null
	return ..()

/// What rides a mob's vis_contents for a while (Vibelin wave_up, particle_up).
/obj/effect/temp_visual/rogue_spell_cast
	icon = ROGUE_SPELL_CAST_ICON
	vis_flags = VIS_INHERIT_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	randomdir = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/datum/weakref/holder_ref

/obj/effect/temp_visual/rogue_spell_cast/Initialize(mapload, mob/living/holder)
	. = ..()
	holder_ref = WEAKREF(holder)
	add_overlay(emissive_appearance(icon, icon_state, holder || src, alpha = alpha))

/obj/effect/temp_visual/rogue_spell_cast/Destroy()
	var/mob/living/holder = holder_ref?.resolve()
	if(holder)
		holder.vis_contents -= src
	holder_ref = null
	return ..()

/// Vibelin /obj/effect/temp_visual/wave_up.
/obj/effect/temp_visual/rogue_spell_cast/rogue_spell_wave
	icon_state = "wave_up"
	duration = 1.8 SECONDS
	SET_BASE_PIXEL(-8, -8)

/// Vibelin /obj/effect/temp_visual/particle_up: goes with its rune.
/obj/effect/temp_visual/rogue_spell_cast/rogue_spell_particles
	icon_state = "particle_up"
	duration = 3.8 SECONDS
	SET_BASE_PIXEL(0, -8)

/obj/effect/temp_visual/rogue_spell_cast/rogue_spell_particles/Initialize(mapload, mob/living/holder, obj/effect/rogue_spell_rune/rune)
	. = ..()
	if(rune)
		RegisterSignal(rune, COMSIG_QDELETING, PROC_REF(on_rune_gone))

/obj/effect/temp_visual/rogue_spell_cast/rogue_spell_particles/proc/on_rune_gone(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// Vibelin /obj/effect/temp_visual/spell_impact: a flash and a light where a spell bolt strikes, brighter by intensity.
/obj/effect/temp_visual/rogue_spell_impact
	icon = ROGUE_SPELL_CAST_ICON
	icon_state = "particle_up"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 1 SECONDS
	randomdir = FALSE
	light_range = 3
	light_color = COLOR_WHITE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/rogue_spell_impact/Initialize(mapload, impact_color = COLOR_WHITE, intensity = ROGUE_SPELL_IMPACT_LOW)
	. = ..()
	color = impact_color
	switch(intensity)
		if(ROGUE_SPELL_IMPACT_MEDIUM)
			set_light(l_range = 5, l_color = impact_color)
		if(ROGUE_SPELL_IMPACT_HIGH)
			set_light(l_range = 7, l_color = impact_color)
		else
			set_light(l_range = 3, l_color = impact_color)
