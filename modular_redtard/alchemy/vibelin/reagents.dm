// Written by modular_redtard/tools/port_vibelin_alchemy.py from Vibelin (Vanderlin); do not edit by hand.
// Values of vars only: the bases and every proc are the module's alchemy code (see BASES in the script).
// Reagent data (name, description, colour, taste, smell); behaviour, temp and thresholds are VA1a's.

/datum/reagent/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	color = "#c8a5dc"
	taste_description = "rush"

/datum/reagent/berrypoison
	name = "Berry Poison"
	color = "#47b2e0"
	taste_description = "bitterness"
	scent_description = "charcoal"

/datum/reagent/berrypoison/shroom
	name = "Mushroom Poison"
	color = "#5647e0"
	taste_description = "acidity"
	scent_description = "acrid earthiness"

/datum/reagent/blood/putrid
	name = "Putrid Blood"
	color = "#94463b"
	taste_description = "rot"
	taste_mult = 1.8

/datum/reagent/blood/tiefling
	name = "Tiefling Blood"
	color = "#c80000"
	taste_description = "iron"
	taste_mult = 1.3

/datum/reagent/buff/constitution
	name = "Constitution"
	color = "#130604"
	taste_description = "acidic bile"
	scent_description = "petrichor"

/datum/reagent/buff/constitution/concentrated
	name = "Concentrated Constitution"
	color = "#0a0302"
	taste_description = "bile thick enough to stand a spoon in"
	scent_description = "deep earth and old stone"

/datum/reagent/buff/endurance
	name = "Endurance"
	color = "#ffff00"
	taste_description = "gote urine"
	scent_description = "urine"

/datum/reagent/buff/endurance/concentrated
	name = "Concentrated Endurance"
	color = "#507000"
	taste_description = "sweat and salt and iron will"
	scent_description = "exertion and dry heat"

/datum/reagent/buff/fortune
	name = "Fortune"
	color = "#ffff00"
	taste_description = "sweet urine"
	scent_description = "urine"

/datum/reagent/buff/fortune/concentrated
	name = "Concentrated Fortune"
	color = "#d4af37"
	taste_description = "sweetness that defies explanation"
	scent_description = "warm coin and morning air"

/datum/reagent/buff/intelligence
	name = "Intelligence"
	color = "#438127"
	taste_description = "bog water"
	scent_description = "moss"

/datum/reagent/buff/intelligence/concentrated
	name = "Concentrated Intelligence"
	color = "#2a5a1a"
	taste_description = "cold water from a very deep well"
	scent_description = "old parchment and ink"

/datum/reagent/buff/perception
	name = "Perception"
	color = "#ffff00"
	taste_description = "cat urine"
	scent_description = "urine"

/datum/reagent/buff/perception/concentrated
	name = "Concentrated Perception"
	color = "#c8c800"
	taste_description = "eye-watering acuity"
	scent_description = "ozone and pine"

/datum/reagent/buff/speed
	name = "Speed"
	color = "#ffff00"
	taste_description = "raw egg yolk"
	scent_description = "sweat"

/datum/reagent/buff/speed/concentrated
	name = "Concentrated Speed"
	color = "#c8c840"
	taste_description = "pure lightning on the tongue"
	scent_description = "electric heat"

/datum/reagent/buff/strength
	name = "Strength"
	color = "#ff9000"
	taste_description = "raw meat"
	scent_description = "sour vomit"

/datum/reagent/buff/strength/concentrated
	name = "Concentrated Strength"
	color = "#c86800"
	taste_description = "raw meat so dense it almost chokes you"
	scent_description = "blood and hot iron"

/datum/reagent/caveweep
	name = "Psydonian Tears"
	description = "Tears from a caveweep. It has its uses in modern alchemy."
	color = "#334274"
	taste_description = "everything"

/datum/reagent/consumable/nutriment/bone_marrow
	name = "Bone Marrow"
	description = "Marrow straight from the source."
	color = "#664330"
	taste_description = "generic food"
	taste_mult = 4

/datum/reagent/cryzaline_suspension
	name = "Crysaline Suspension"
	description = "A supercooled alchemical suspension that rapidly crystallizes moisture on contact. Each exposure deepens the frost, layering rime upon the body until it violently ruptures."
	color = "#88BFFF"
	taste_description = "biting cold"

/datum/reagent/devour
	name = "DEVOUR"
	color = "#61e639"

/datum/reagent/drug/gravitum_elixir
	name = "Gravitum Elixir"
	description = "A heavy alchemical distillate that saturates the body with excess essence of Earth. The imbiber swells in size and mass, movements becoming slower but more forceful. Prolonged exposure causes uncontrolled growth, sluggish reflexes, and structural stress as the body struggles to support its own weight."
	color = "#5FA8FF"
	taste_description = "bitterness"

/datum/reagent/drug/phlogiston_elasticum
	name = "Phlogiston Elasticum"
	description = "An unstable alchemical suspension infused with volatile air-aspected essence. It fills the body with kinetic potential, causing the imbiber to rebound and spring with unnatural force. Excess causes chaotic motion, uncontrolled spasms, and degradation of the mind and body."
	color = "#7FE0FF"
	taste_description = "bitterness"

/datum/reagent/drug/subtilum_tincture
	name = "Subtilum Tincture"
	description = "A rare alchemical tincture that refines and compresses the body’s physical essence. The imbiber shrinks in size, becoming light and agile but physically fragile. Excess causes severe instability, dizziness, and progressive loss of bodily cohesion."
	color = "#BFEFFF"
	taste_description = "bitterness"

/datum/reagent/medicine/antidote
	name = "Poison Antidote"
	description = "Heals damage induced by toxins and poisons."
	color = "#00ff00"
	taste_description = "sickly sweet"
	scent_description = "rotten cheese"

/datum/reagent/medicine/ashbinders_salve
	name = "Ashbinder's Salve"
	description = "A charcoal-grey paste made from rendered ash and cooled flame extracts. Specializes in treating burns with remarkable efficacy, though it does nothing for blunt wounds or bleeding."
	color = "#555555"
	taste_description = "ash and oil"
	scent_description = "cooling embers"

/datum/reagent/medicine/ashwarden_brew
	name = "Ashwarden Brew"
	description = "A foul-smelling dark brew used by those who venture near volcanic vents. It coats the lungs and airways in a protective lattice, specifically reversing fire and chemical burn damage."
	color = "#3D1C02"
	taste_description = "volcanic sulfur and char"
	scent_description = "sulphurous fumes"

/datum/reagent/medicine/bloodelder_wine
	name = "Bloodelder Wine"
	description = "A deep crimson wine fermented from bloodelder berries over many months. Steadily restores blood volume at an exceptional rate, but has a mildly intoxicating effect that clouds perception."
	color = "#8B0000"
	taste_description = "dark berries and iron"
	scent_description = "fermented fruit and copper"

/datum/reagent/medicine/bloodpot
	name = "Blood Potion"
	description = "Gradually regenerates Vitae."
	color = "#c80000"
	taste_description = "sickly iron"
	scent_description = "sickly iron"

/datum/reagent/medicine/coldvein_compress
	name = "Coldvein Compress"
	description = "A supercooled liquid suspension that numbs and anesthetizes damaged tissue on contact. Dramatically reduces pain and slows the progression of burn injury when applied directly."
	color = "#ADD8E6"
	taste_description = "biting cold and numbness"
	scent_description = "winter air"

/datum/reagent/medicine/crystalline_lymph
	name = "Crystalline Lymph"
	description = "A shimmering fluid distilled from the crystallized runoff of magical formations. It stabilizes the critically wounded, preventing death from progressing while the body catches up a stopgap, not a cure."
	color = "#B0E0E6"
	taste_description = "still water and static"
	scent_description = "ionized air"

/datum/reagent/medicine/diseasecure
	name = "Disease Cure"
	description = "Quickly heals damage induced by toxins and poisons."
	color = "#004200"
	taste_description = "dirt"
	scent_description = "saiga droppings"

/datum/reagent/medicine/endorphin
	name = "Endorphin"
	description = "Endorphins are chemically similar to morphine, but naturally synthesized by the human body. They are typically produced as a bodily response to pain, but can also be produced under favorable circumstances. Overdosing will cause drowsyness and jitteriness."
	color = "#ff799679"
	taste_description = "euphoria"

/datum/reagent/medicine/fever_oil
	name = "Fever Oil"
	description = "A hot amber oil that creates a controlled fever response in the imbiber. The elevated temperature rapidly purges disease and clears infection, though the process is uncomfortable."
	color = "#FF4500"
	taste_description = "scorching pepper and oil"
	scent_description = "burning spice"

/datum/reagent/medicine/gender_potion
	name = "Gender Potion"
	description = "Change the user's gender."
	color = "#FF33FF"
	taste_description = "raw sweetness"
	scent_description = "flower nectar"

/datum/reagent/medicine/healthpot
	name = "Health Potion"
	description = "Gradually regenerates all types of damage."
	color = "#ff0000"
	taste_description = "lifeblood"
	scent_description = "metal"

/datum/reagent/medicine/ichor_of_mending
	name = "Ichor of Mending"
	description = "A viscous golden fluid drawn from the rendered fat of blessed beasts. It seals wounds from the inside, knitting torn flesh together at an unnatural pace but offers nothing against fire or disease."
	color = "#D4AF37"
	taste_description = "animal fat and sweetness"
	scent_description = "rendered tallow"

/datum/reagent/medicine/manapot
	name = "Mana Potion"
	description = "Gradually regenerates energy."
	color = "#000042"
	taste_description = "sweet mana"
	scent_description = "dry air"

/datum/reagent/medicine/manapot/weak
	name = "Weak Mana Potion"
	description = "Gradually regenerates energy."
	color = "#000042"
	taste_description = "sweet mana"
	scent_description = "dry air"

/datum/reagent/medicine/marrowbrew
	name = "Marrowbrew"
	description = "Boiled marrow of large beasts, reduced and clarified. Slowly heals all damage types from the inside out, not remarkable at any one thing, but comprehensive."
	color = "#FFFACD"
	taste_description = "rich fat and meat"
	scent_description = "bone broth"

/datum/reagent/medicine/mindclear_tonic
	name = "Mindclear Tonic"
	description = "A sharp-smelling blue tonic derived from aquifer mosses and dissolved crystal powder. It rapidly reverses brain damage and clears narcotic haze, but does nothing for the body."
	color = "#00CED1"
	taste_description = "cold mint and ozone"
	scent_description = "crisp water and crystal"

/datum/reagent/medicine/mirewort_compress
	name = "Mirewort Compress"
	description = "A pungent brown compress liquid extracted from swamp mirewort. Notorious for smelling of stagnant water, it excels at cleansing infected wounds when applied directly to flesh."
	color = "#556B2F"
	taste_description = "swamp water and rot"
	scent_description = "stagnant bog"

/datum/reagent/medicine/nervebind_extract
	name = "Nervebind Extract"
	description = "Derived from a rare deep-root fungus that colonizes nervous tissue. Potently numbs pain and prevents trauma shock, at the cost of making the imbiber slightly sluggish."
	color = "#9370DB"
	taste_description = "numbing bitterness"
	scent_description = "damp fungus"

/datum/reagent/medicine/pale_serum
	name = "Pale Serum"
	description = "A milky-white concoction refined through careful reduction of bone marrow and purified water. Uniquely restores organ function and brain matter, but offers little for surface wounds."
	color = "#F5F5F0"
	taste_description = "mineral and chalk"
	scent_description = "clean sterility"

/datum/reagent/medicine/rosawater
	name = "Rosa Water"
	description = "Steeped rose petals with mild regeneration."
	color = "#f398b6"
	taste_description = "floral"
	scent_description = "rosa"

/datum/reagent/medicine/soporpot
	name = "Soporific Poison"
	description = "Weakens those it enters."
	color = "#fcefa8"
	taste_description = "drowsyness"

/datum/reagent/medicine/soulweave_distillate
	name = "Soulweave Distillate"
	description = "A luminescent distillate refined from life-essence concentrate and essence of cycle. Said to weave the threads of a damaged soul back together it reverses organ and brain damage simultaneously while stabilizing the critically injured."
	color = "#E0BBE4"
	taste_description = "floral bitterness and light"
	scent_description = "sunrise petals"

/datum/reagent/medicine/spiritwood_elixir
	name = "Spiritwood Elixir"
	description = "Brewed from the heartwood of a spiritwood tree, fallen naturally. The elixir shares a brief connection with the life-force of the tree, dramatically accelerating wound closure while the link holds."
	color = "#8FBC8F"
	taste_description = "bark and sap"
	scent_description = "ancient forest"

/datum/reagent/medicine/stampot
	name = "Stamina Potion"
	description = "Gradually regenerates stamina."
	color = "#129c00"
	taste_description = "sweet tea"
	scent_description = "grass"

/datum/reagent/medicine/stonevein_broth
	name = "Stonevein Broth"
	description = "A dense mineral broth reduced from ore-laced spring water. Strengthens the body's resistance to physical trauma by thickening the skin and dense-packing superficial tissue."
	color = "#A0A0A0"
	taste_description = "mineral brine"
	scent_description = "wet stone"

/datum/reagent/medicine/strongbloodpot
	name = "Strong Blood Potion"
	description = "Regenerates Vitae."
	color = "#800000"
	taste_description = "decay and sickly iron"
	scent_description = "decay and sickly iron"

/datum/reagent/medicine/stronghealth
	name = "Strong Health Potion"
	description = "Quickly regenerates all types of damage."
	color = "#820000be"
	taste_description = "rich lifeblood"
	scent_description = "metal"

/datum/reagent/medicine/strongmana
	name = "Strong Mana Potion"
	description = "Rapidly regenerates energy."
	color = "#0000ff"
	taste_description = "raw power"
	scent_description = "dry air"

/datum/reagent/medicine/strongstam
	name = "Strong Stamina Potion"
	description = "Rapidly regenerates stamina."
	color = "#13df00"
	taste_description = "sparkly static"
	scent_description = "grass"

/datum/reagent/medicine/sunpetal_decoction
	name = "Sunpetal Decoction"
	description = "A warm golden brew from sun-dried petals of the highbloom flower. It soothes toxins and infections with gentle persistence, useful for recovery, poor for emergencies."
	color = "#FFD700"
	taste_description = "floral sweetness"
	scent_description = "dried summer flowers"

/datum/reagent/medicine/thornmorrow_tincture
	name = "Thornmorrow Tincture"
	description = "Extracted from thornmorrow briar, a plant that repairs itself. Extremely slow to act, but uniquely persistent it remains in the bloodstream long after most medicines have faded, offering gradual healing over a prolonged period."
	color = "#228B22"
	taste_description = "thorny bitterness"
	scent_description = "briars and undergrowth"

/datum/reagent/medicine/tombsilt_tincture
	name = "Tombsilt Tincture"
	description = "Ground grave-dust suspended in spirit vinegar. Morbid in origin, remarkable in function: it arrests necrotic and toxin damage with cold precision, but does nothing for physical injury."
	color = "#8B7355"
	taste_description = "dry dust and sharp vinegar"
	scent_description = "old earth and spirits"

/datum/reagent/medicine/vitalroot_draught
	name = "Vitalroot Draught"
	description = "Brewed from roots that grow only near ley-line confluences. It floods the blood with restorative energy, rapidly closing oxygen deprivation and restoring breath to the suffocating it cannot address wounds or toxins."
	color = "#4CAF50"
	taste_description = "bitter roots"
	scent_description = "deep earth and mineral water"

/datum/reagent/medicine/witchknit_paste
	name = "Witchknit Paste"
	description = "A thick paste mixed by tradition-bound hedgewives. Applied externally, it rapidly closes lacerations and sets broken flesh, named for the legend that it was first made from witch-hair and spider gland."
	color = "#C0C0C0"
	taste_description = "bitter chalk and herbs"
	scent_description = "dust and old herbs"

/datum/reagent/medicine/woundwrack_oil
	name = "Woundwrack Oil"
	description = "An oily amber extract from the woundwrack tree's bark. Applied to open wounds, it dramatically accelerates natural clotting and closes lacerations, but does nothing when absorbed internally."
	color = "#C8860A"
	taste_description = "tree bark and pine"
	scent_description = "resinous amber"

/datum/reagent/meth_precursor
	name = "Methamphetamine Precursor"
	description = "A volatile chemical intermediate. Smells awful. Probably shouldn't drink it."
	color = "#C8E8FA"
	taste_description = "burning chemicals"

/datum/reagent/organpoison
	name = "Organ Poison"
	color = "#2c1818"
	taste_description = "sour meat"
	scent_description = "metal"

/datum/reagent/organpoison/human
	name = "Humen Organ Poison"

/datum/reagent/organpoison/kobold
	name = "Kobold Organ Poison"

/datum/reagent/poison/ashfall_dust
	name = "Ashfall Dust"
	description = "Powdered remains of a creature scorched by magical fire. Suspended in air or splashed across flesh, the fine particles ignite on contact with warmth, inflicting persistent burn injury. Its touch lingers."
	color = "#696969"
	taste_description = "choking ash"
	scent_description = "burning hair and char"

/datum/reagent/poison/blinding_spore
	name = "Blinding Spore"
	description = "Powder from the eyeblight mushroom. Contact with skin or mucous membranes induces temporary blindness and severe eye irritation. Not lethal, but profoundly incapacitating in a fight."
	color = "#F5DEB3"
	taste_description = "choking dust"
	scent_description = "dry fungal spores"

/datum/reagent/poison/blistergall
	name = "Blistergall"
	description = "A caustic secretion harvested from acid-slugs that nest near hot springs. On contact with flesh it erupts into suppurating blisters, causing severe burn damage. Internal ingestion causes intense toxic damage."
	color = "#ADFF2F"
	taste_description = "burning acid"
	scent_description = "acidic rot"

/datum/reagent/poison/bloodstone_essence
	name = "Bloodstone Essence"
	description = "A vile blood poison born of bloodstones, whilst rendered inert during the forging process this essence corrupts and kills those who touch raw bloodstone. It is unknown how those who forge bloodsteel weapons live long enough to do so."
	color = "#8B0000"
	taste_description = "bittersweet blood"
	scent_description = "cloying blood and sweetness"

/datum/reagent/poison/dreaddeath
	name = "Dread Death"
	description = "A terribly potent poison."
	color = "#0e0004"
	taste_description = "the end"
	scent_description = "nothing"

/datum/reagent/poison/drowsbane
	name = "Drowsbane"
	color = "#810e0e"
	taste_description = "each tastebud individually burning to a crisp"
	scent_description = "brimstone"

/datum/reagent/poison/gloomvenom
	name = "Gloomvenom"
	description = "Distilled from the glands of gloom-spiders that dwell in lightless caverns. Unlike common venoms it acts on the mind rather than the body, inducing escalating confusion and disorientation before finally causing paralytic toxin buildup."
	color = "#4A235A"
	taste_description = "musty sweetness"
	scent_description = "damp caves"

/datum/reagent/poison/heatcramp_oil
	name = "Heatcramp Oil"
	description = "Rendered fat, mixed with capsaicin extract. Induces severe involuntary muscle spasms and cramps on absorption, making coordinated movement extremely difficult without dealing significant direct damage."
	color = "#FF6347"
	taste_description = "unbearable burning"
	scent_description = "cooking flesh and pepper"

/datum/reagent/poison/hexblood_poison
	name = "Hexblood Poison"
	description = "Brewed from cursed blood and wychwood ash. It seeps into wounds on contact, rapidly delivering trauma as it inflames tissue and causes internal hemorrhage. Popular with assassins."
	color = "#8B0000"
	taste_description = "iron and char"
	scent_description = "burnt copper"

/datum/reagent/poison/ironblight
	name = "Ironblight"
	description = "A black liquid that corrodes metal and is devastating against armored targets. Against living flesh it deals modest brute damage, but against those wearing metal armor its vapors eat through joints and fastenings particularly useful against knights."
	color = "#1C1C1C"
	taste_description = "sharp metal"
	scent_description = "acid and rust"

/datum/reagent/poison/mirelung_brew
	name = "Mirelung Brew"
	description = "A vile lung-coating poison used by swamp brigands. It causes the victim to experience respiratory failure over time, as their airways flood with a thick, viscous film mimicking drowning."
	color = "#3B5323"
	taste_description = "swamp water and bile"
	scent_description = "stagnant water"

/datum/reagent/poison/mirrorwaste
	name = "Mirrorwaste"
	description = "A reflective silvery fluid left over from failed scrying rituals. It does nothing to normal flesh. But against creatures sustained by magic or undeath, it disrupts their essential coherence, dealing significant damage."
	color = "#C0C0C0"
	taste_description = "metallic nothing"
	scent_description = "still air"

/datum/reagent/poison/quietdeath
	name = "Quietdeath"
	description = "A slow, tasteless, colorless poison beloved of conspirators and the patient. It provides no warning to the victim, metabolizing silently over hours before delivering a sudden catastrophic organ shutdown."
	color = "#FFFAFA"
	taste_description = "nothing"
	scent_description = "nothing"

/datum/reagent/poison/rotwater
	name = "Rotwater"
	description = "Contaminated water drawn from a corpse-pit. Drinking it introduces rapidly multiplying bacteria into the bloodstream. It poisons slowly at first, then accelerates the infection compounds upon itself over time."
	color = "#5D4037"
	taste_description = "fetid water"
	scent_description = "rot and swamp"

/datum/reagent/poison/soulbane_ichor
	name = "Soulbane Ichor"
	description = "Black fluid extracted from the remains of a creature that died twice. It is profoundly hostile to the living, dealing damage across all categories simultaneously while interfering with natural healing. Extremely dangerous."
	color = "#0D0D0D"
	taste_description = "oblivion"
	scent_description = "nothing and death"

/datum/reagent/sal_petris
	name = "Sal Petris"
	description = "An alchemical salt that arrests flesh into lifeless stone. In sufficient quantity, the imbiber stiffens and calcifies, their body held rigid as marble for a time."
	color = "#929292"
	taste_description = "rocks"

/datum/reagent/sate
	name = "SATE"
	color = "#e46363"

/datum/reagent/skill_elixir/alchemists_clarity
	name = "Alchemist's Clarity"
	description = "A self-referential paradox: an elixir that sharpens the mind for making elixirs. Tastes like it knows something you don't."
	color = "#604080"
	taste_description = "sulfur, copper, and faint sweetness"
	scent_description = "reagent fumes and hot glass"

/datum/reagent/skill_elixir/arcane_solvent
	name = "Arcane Solvent"
	description = "A faintly luminous blue liquid that smells of ozone and dried herbs. Mages report that it makes the abstract feel immediately legible."
	color = "#2030c0"
	taste_description = "charged air and something metallic"
	scent_description = "ozone and mana-bloom"

/datum/reagent/skill_elixir/athletes_brine
	name = "Athlete's Brine"
	description = "A salty, mineral-rich drink that sustains the body through extended physical effort."
	color = "#20a060"
	taste_description = "salt, electrolytes, and something grassy"
	scent_description = "sea air and effort"

/datum/reagent/skill_elixir/beastwhisper
	name = "Beastwhisper"
	description = "A strange, sweet-smelling tonic brewed from flowers and fish scales. Creatures seem calmer around those who drink it."
	color = "#70a080"
	taste_description = "river water and wildflower"
	scent_description = "something animals find calming"

/datum/reagent/skill_elixir/blade_arts
	name = "Blade-Arts Tincture"
	description = "A biting, iron-rich tincture said to have been drunk by duelists before contests of blades."
	color = "#8a1a1a"
	taste_description = "blood and cold steel"
	scent_description = "iron and oiled leather"

/datum/reagent/skill_elixir/brewers_wort
	name = "Brewer's Wort"
	description = "A murky, yeasty liquid that smells of fermentation and old barrels. Fermenters swear by it."
	color = "#906020"
	taste_description = "yeast, barley, and something acidic"
	scent_description = "fermenting grain and oak"

/datum/reagent/skill_elixir/builders_draught
	name = "Builder's Draught"
	description = "A gritty, chalky drink mixed with sawdust that puts fire in the arms and steadiness in the hands."
	color = "#8a6030"
	taste_description = "chalk, sawdust, and something earthy"
	scent_description = "fresh-cut wood and stone"

/datum/reagent/skill_elixir/cooks_brine
	name = "Cook's Brine"
	description = "A complex, briny tonic that sharpens the palate and quickens culinary instinct."
	color = "#c8a060"
	taste_description = "salt, acid, and something savory"
	scent_description = "a working kitchen"

/datum/reagent/skill_elixir/craftsmans_wit
	name = "Craftsman's Wit"
	description = "A sharp, acrid liquid that clears the mind for mechanical and constructive thought."
	color = "#3a3a4a"
	taste_description = "carbon and mineral oil"
	scent_description = "machine grease and sawdust"

/datum/reagent/skill_elixir/farmers_almanac
	name = "Farmer's Almanac Tonic"
	description = "A surprisingly complex herbal blend that sharpens practical knowledge and pattern recognition."
	color = "#608040"
	taste_description = "soil and chamomile and something almost sweet"
	scent_description = "turned earth and dried herbs"

/datum/reagent/skill_elixir/heavy_arms
	name = "Heavy-Arms Draught"
	description = "A thick, gritty draught smelling of soil and animal fat. Favoured by soldiers and brawlers."
	color = "#5a3010"
	taste_description = "rendered marrow and grit"
	scent_description = "sweat, earth, and old blood"

/datum/reagent/skill_elixir/locksmiths_oil
	name = "Locksmith's Oil"
	description = "A shimmering, slippery liquid that steadies the hands and narrows the focus."
	color = "#c0c0b0"
	taste_description = "metallic and slick"
	scent_description = "machine oil and brass"

/datum/reagent/skill_elixir/marksmans_eye
	name = "Marksman's Eye Drop"
	description = "A sharp, resinous tonic said to steady the hand and sharpen the eye to a needle's point."
	color = "#a0a030"
	taste_description = "pine resin and something bright"
	scent_description = "woodsmoke and dry air"

/datum/reagent/skill_elixir/miners_heart
	name = "Miner's Heart"
	description = "A thick, charcoal-dark brew that bolsters the body for sustained physical labour."
	color = "#303030"
	taste_description = "charcoal, iron, and bitter mineral water"
	scent_description = "deep stone and coal dust"

/datum/reagent/skill_elixir/miracle_water
	name = "Miracle Water"
	description = "Blessed water charged with divine intent. Those of faith find their connection to their patron deepened by it."
	color = "#f0f0e0"
	taste_description = "purity and something warm"
	scent_description = "incense and clean air"

/datum/reagent/skill_elixir/prep_hands_tonic
	name = "Prep Hand's Tonic"
	description = "A sharp, herbal tonic that quickens the hands at the cutting board."
	color = "#90b060"
	taste_description = "sharp herbs and vinegar"
	scent_description = "a freshly-wiped chopping board"

/datum/reagent/skill_elixir/scholars_ink
	name = "Scholar's Ink"
	description = "A dark, faintly astringent drink that clears the mind for learning, memory, and complex thought."
	color = "#101840"
	taste_description = "bitter oak gall and something almost sweet"
	scent_description = "old books and fresh ink"

/datum/reagent/skill_elixir/seamstress_thimble_drop
	name = "Seamstress's Thimble-Drop"
	description = "A delicate, waxy liquid that steadies the fingers for fine needlework."
	color = "#e0c8d0"
	taste_description = "beeswax and something faintly floral"
	scent_description = "clean linen and lavender"

/datum/reagent/skill_elixir/shadow_tonic
	name = "Shadow Tonic"
	description = "A thin, colourless tonic that dulls the sound of footsteps and sharpens peripheral vision."
	color = "#202020"
	taste_description = "nothing, almost exactly"
	scent_description = "barely anything at all"

/datum/reagent/skill_elixir/shield_bearer
	name = "Shield-Bearer's Draught"
	description = "A heavy, mineral-rich drink that settles the stance and firms the grip."
	color = "#505060"
	taste_description = "chalk and iron filings"
	scent_description = "stone dust and sweat"

/datum/reagent/skill_elixir/skinners_elixir
	name = "Skinner's Elixir"
	description = "An oily, pungent brew said to make a tanner's hands supple and their eye sharp."
	color = "#8b6914"
	taste_description = "rendered fat and salt"
	scent_description = "raw hide and wood ash"

/datum/reagent/skill_elixir/smelters_patience
	name = "Smelter's Patience"
	description = "A thick, warm draught that hardens the body against sustained heat and labour."
	color = "#b04800"
	taste_description = "charcoal and something sweet"
	scent_description = "hot metal and coal smoke"

/datum/reagent/skill_elixir/smiths_blood
	name = "Smith's Blood"
	description = "A dark, iron-tasting draught that puts fire in the arm and certainty in the hammer."
	color = "#5a1010"
	taste_description = "iron, copper, and old fire"
	scent_description = "forge smoke and blood"

/datum/reagent/skill_elixir/trappers_sense
	name = "Trapper's Sense"
	description = "A bitter, woodsy tincture that sharpens awareness and steadies the hands for delicate work."
	color = "#506030"
	taste_description = "bark and bitter herbs"
	scent_description = "wet leaves and earth"

/datum/reagent/skill_elixir/vital_ichor
	name = "Vital Ichor"
	description = "A crimson, viscous liquid that pulses faintly. Blood sorcerers report a deepened sensitivity to the flows of vitae when they consume it."
	color = "#800020"
	taste_description = "copper and living heat"
	scent_description = "iron and something ancient"

/datum/reagent/skill_elixir/whip_hand
	name = "Whip-Hand Oil"
	description = "A light, sharp-smelling oil that steadies the wrist and quickens the eye."
	color = "#704020"
	taste_description = "pepper and hot leather"
	scent_description = "tanned hide and sweat"

/datum/reagent/skill_elixir/wild_draught
	name = "Wild Draught"
	description = "A mossy, root-bitter tincture that sharpens attunement to natural patterns and subtle movements."
	color = "#306020"
	taste_description = "forest floor and morning dew"
	scent_description = "moss, bark, and turned earth"

/datum/reagent/soap
	name = "Soap"
	description = "A combination of ash and animal fats used for cleaning."
	color = "#cbb165"
	taste_description = "soapy grease"
	taste_mult = 2

/datum/reagent/stampoison
	name = "Stamina Poison"
	color = "#083b1c"
	taste_description = "lint"
	scent_description = "dust"

/datum/reagent/strongpoison
	name = "Doom Poison"
	color = "#1a1616"
	taste_description = "burning"
	scent_description = "charcoal"

/datum/reagent/strongstampoison
	name = "Strong Stamina Poison"
	color = "#041d0e"
	taste_description = "frozen air"
	scent_description = "freezing dust"

/datum/reagent/thorn_essence
	name = "Thorn Essence"
	description = "A component used in further refinement, sourced from thorns."
	color = "#26490e"
	taste_description = "the bog"

/datum/reagent/toxin
	name = "Toxin"
	description = "A toxic chemical."
	color = "#CF3600"
	taste_description = "bitterness"
	taste_mult = 1.2

/datum/reagent/toxin/fyritiusnectar
	name = "fyritius nectar"
	description = "oh no"
	color = "#ffc400"
	taste_description = "bitterness"
	taste_mult = 1.2

/datum/reagent/toxin/killersice
	name = "Killer's Ice"
	color = "#c8c9e9"
	taste_description = "cold needles"
	scent_description = "freezing dust"

/datum/reagent/toxin/killersice
	name = "killersice"
	description = "killersice"
	color = "#FFFFFF"
	taste_description = "bitterness"
	taste_mult = 1.2

/datum/reagent/toxin/manabloom_juice
	name = "Manabloom Juice"
	description = "A potent mana regeneration extract, it however has the issue of stopping your body's ability to naturally disperse mana."
	color = "#6eb9e4"
	taste_description = "flowers"
	taste_mult = 1.2

/datum/reagent/toxin/spidervenom_inert
	name = "Inert Aragn Essence"
	description = "Without the spider, the venom has weakened. It must be strengthened with a binding catalyst first."
	color = "#003d99"
	taste_description = "blueberry"
	taste_mult = 1.2

/datum/reagent/toxin/spidervenom_paralytic
	name = "Aragn Essence"
	description = "A strong neurotoxin that makes muscles stiffen up and spasm."
	color = "#99005e"
	taste_description = "raspberry"
	taste_mult = 1.2

/datum/reagent/tree_sap
	name = "Tree Sap"
	description = "A thick substance left behind by dendor's blessed creations."
	color = "#b85900"
	taste_description = "sap"

/datum/reagent/undeadash
	name = "Spectral Powder"
	color = "#330066"
	taste_description = "tombstones"
	scent_description = "dust"
