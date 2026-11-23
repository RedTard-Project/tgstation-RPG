/// Vibelin's chemical effects (mob/living/chem_effects.dm): what a reagent, a food or a status does to the body is kept as a
/// power per effect (ROGUE_CE_* of combat/_medical_defines.dm) and per source, so that two sources of one effect add up and
/// each goes away on its own. The physiology reads them: painkillers (combat/pain.dm), pulse and stabilisers, blood
/// restoration and oxygenation (combat/heart.dm, combat/blood.dm), toxins and antibiotics (the injuries). This is the only set
/// of chemical effects of the module: alchemy and food write through these procs.
///
/// A source is a string (Vibelin passes "[type]"); a datum is kept by its ref string so that no effect holds a reference.

/mob/living
	/// effect -> list(source -> power); null while the body has none.
	var/list/rogue_chem_effects

/// The key a source is kept under: a string as it is, a datum by its ref, nothing as "generic".
/proc/rogue_chem_source_key(source)
	if(isnull(source))
		return "generic"
	if(isdatum(source))
		return REF(source)
	return "[source]"

/// Sets the power of an effect from a source (Vibelin add_chem_effect()); a power of 0 takes that source away.
/mob/living/proc/rogue_add_chem_effect(effect, power, source)
	if(!effect)
		return
	var/key = rogue_chem_source_key(source)
	if(!power)
		rogue_remove_chem_effect(effect, key)
		return
	LAZYINITLIST(rogue_chem_effects)
	var/list/sources = rogue_chem_effects[effect]
	if(!sources)
		sources = list()
		rogue_chem_effects[effect] = sources
	sources[key] = power

/// Takes away an effect from a source, or from every source when none is named (Vibelin remove_chem_effect()).
/mob/living/proc/rogue_remove_chem_effect(effect, source)
	var/list/sources = LAZYACCESS(rogue_chem_effects, effect)
	if(!sources)
		return
	if(isnull(source))
		sources.Cut()
	else
		sources -= rogue_chem_source_key(source)
	if(!length(sources))
		rogue_chem_effects -= effect
	if(!length(rogue_chem_effects))
		rogue_chem_effects = null

/// The power of an effect, all sources together (Vibelin get_chem_effect()); 0 when the body has none of it.
/mob/living/proc/rogue_get_chem_effect(effect)
	. = 0
	var/list/sources = LAZYACCESS(rogue_chem_effects, effect)
	for(var/key in sources)
		. += sources[key]
