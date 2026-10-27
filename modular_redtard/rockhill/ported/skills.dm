/datum/attribute/skill/combat/knives
	name = "Knife-fighting"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with knives, and your chance to bypass dodge by 10%. At Apprentice or above, you will not fumble while taking out knives from a bandolier."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_SPEED
	default_attributes = list(
		ROGUE_STAT_SPEED = -5,
		ROGUE_STAT_PERCEPTION = -6,
		)
	dreams = list(
		"...a barkeep whistles as he cleans glasses and a drunkard snores, passed out on the counter. The rest of the tavern focuses on you with bated breath as your dagger darts between your fingers in an impressive display of legerdemain...",
		"...a flash of steel through the sky, and another, and another. Blades pass between your juggling hands as if you were pulling on singular, thick rope...",
		"...you tuck the blade away in your cloak, and offer yourself up for inspection. While small, the invisible blade cannot be parried...",
		)

/datum/attribute/skill/combat/swords
	name = "Sword-fighting"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with swords, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -5,
		ROGUE_STAT_SPEED = -6,
		)
	dreams = list(
		"...your heavy blade swings in a wide arc, cleaving through the air with a roar. Each landed strike hits with bone shattering force. Your opponent's shield crumples under the weight, and your blade finds its mark - crushing through armor, flesh, and will alike...",
		"...a shining length of ivory steel. A token. A symbol. More than just a weapon. Blood runs thick in the wash-bin. Sparks fly from the grindstone. You maintain the blade and it maintains your honour...",
		"...the rapier dances in your hand, a whisper of steel cutting through the air. Every thrust is precise, every parry and riposte flowing in perfect rhythm, simply awaiting the moment to seal your their fate with a single, fatal strike...",
		)

/datum/attribute/skill/combat/polearms
	name = "Polearms"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with polearms, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -5,
		ROGUE_STAT_WILLPOWER = -7,
		)
	dreams = list(
		"...the pale volf snaps its jaws, but to no avail. Your weapon has the superior reach and you jab at it with precision until it bleeds and retreats back into the woods...",
		"...armed with your trusty staff, you hike through the muck and mire with ease. It serves not only as a weapon but a tool, its sturdy length offering support as you press onward, unfazed by the thick, unrelenting muck...",
		"...the billhook hums through the air, its hooked blade striking with chilling precision. It rends through chain and leather. With each twist, your strikes become inevitable, seamless. A relentless dance of destruction, merciless and fluid...",
		)

/datum/attribute/skill/combat/staves
	name = "Staves"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with staves, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_SPEED
	default_attributes = list(
		ROGUE_STAT_SPEED = -5,
		ROGUE_STAT_STRENGTH = -6,
		)
	dreams = list(
		"...your reflection in the stream ripples as you train. Each motion a part of an ancient pattern, half-forgotten. Each strike, each parry, each feint, makes the water's surface split like silk. Psydonia listens...",
		"...you walk the forgotten road, your staff tapping against stone. When the brigands step forth, grinning, you do not break stride. The staff spins, a flicker of old instinct, and one falls. The others hesitate, seeing not an old, weary traveler, but a lesson long unlearned...",
		"...a dying monk presses a bloodied quarterstaff into your grasp. 'The world is not stone,' he rasps, 'but water.' You strike, and the staff seems to flow, finding paths you did not see before...",
		"...amidst flickering torchlight, you spar with a silent figure. Their staff moves like a serpent, coiling, striking, vanishing - before it all goes dark. You wake, trying to recall the shape of their final blow...",
		"...cattle thieves descend upon the homestead. You have no sword, only a sturdy branch. One by one they fall, the staff cracking through bone and flesh alike. Violence, you realize, is a language spoken in every tongue...",
		)

/datum/attribute/skill/combat/arcyne
	name = "Arcyne Armament"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with conjured or arcyne-bound weapons, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_HARD
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -6,
		)
	dreams = list(
		"...you form your conduits into the shape of blades, your blood flows with the feelings of iron, and you have created over a thousand blades, knowing the weight and edge of everyone of them. You have not practiced their forms, yet they flows like water in your hand...",
		"...no weapon is a stranger to your hand, a slash with a khopesh, a thrust with a spear, a figure eight with a greatsword, the squires in the yard flow from one strike to another, you, from one weapon to another...7",
		)

/datum/attribute/skill/combat/maces
	name = "Maces"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with maces, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -5,
		ROGUE_STAT_WILLPOWER = -7,
		)
	dreams = list(
		"...darkness surrounds you. You smash, again and again against the walls, the ominous thuds ringing through your skull with each strike. The wall trembles and with a final earth-shaking smash, light breaks through and you emerge into freedom...",
		"...'I am ineffable. I am unpierceable.' The wicked white guardian says. And so, you shatter its skull in a single blow with your mace, for it was not unbludgeonable...",
		"...the air trembles with each of your mighty blows, each strike echoing like the final toll of a bell. This is your symphony. Revel in its brutal beauty, its crushing simplicity...",
		"...'This blade is a masterwork of Malum's craftsmanship,' the elf declared. Moments later his head was abruptly transformed into pavement decor under the crushing weight of your brutish tool...",
		)

/datum/attribute/skill/combat/axes
	name = "Axes"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with axes, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -5,
		ROGUE_STAT_WILLPOWER = -7,
		)
	dreams = list(
		"...bones are like trees. The bigger they are, the harder they fall. With a monstrous swing, the skeleton is decapitated and you have saved the town from its evil...",
		"...stuck in the flesh, you rip away at your weapon. It comes loose. Blood splatters across your armor and cloak and the side of your face. Hunting is no easy job, but the old man's teachings are effective...",
		"...your axe descends, and another tree falls. Wet sap runs down your face as you hack and chop relentlessly turning the forest into a thicket, then the thicket until it is an open plains. It's only when you pause and look down that you see the shattered bones, the torn flesh and the mangled faces. The town square has turned crimson, drenched in the aftermath of your fury...",
		"...the heft of iron pulls upon your arm. It knows where it wishes to be - all you have to do is guide its fall. Knowing this, your axe feels lighter than you remember...",
		"...despite the insurmountable challenge, you fear nothing, for the axe is thy companion eternal. Problem solving is quite simple, really...",
		)

/datum/attribute/skill/combat/whipsflails
	name = "Whips & Flails"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with whips or flails, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_HARD
	governing_attribute = ROGUE_STAT_SPEED
	default_attributes = list(
		ROGUE_STAT_SPEED = -7,
		ROGUE_STAT_PERCEPTION = -8,
		)
	dreams = list(
		"...the sing-song of your flail cleaves through the air and rouses something primal, but the down swing of your hand quickly puts it to sleep...",
		"...with a whistle and a snap and a crack, another bruise is left on flesh. With a sharp pull, you strike down again. They will be tamed...",
		)

/datum/attribute/skill/combat/bows
	name = "Archery"
	desc = "Alongside perception, increases the speed you draw back a bow and have it ready to shoot. Does not influence damage or chance to hit."
	category = ROGUE_SKILL_CATEGORY_RANGED
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		ROGUE_STAT_STRENGTH = -7,
		)
	dreams = list(
		"...the cold wind on the balcony bristles against your left so you adjust your aim towards it. Your fingers relax and your bow exhales a quiet sigh. Moments later, your mark drops to the cobblestone streets below. Dead...",
		"...your fingers sting as you let loose another arrow and it glances off the pale knight's breastplate. You aim at their visor and pray to whatever gods you hold dear that this one will make it through...",
		"...it takes half a minute for an experienced arbalist to cock and load a crossbow. You could kill five men with three arrows in half that time...",
		)

/datum/attribute/skill/combat/crossbows
	name = "Crossbows"
	desc = "Alongside perception, increases the speed you ready a crossbow and have it ready to shoot. Does not influence damage or chance to hit."
	category = ROGUE_SKILL_CATEGORY_RANGED
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		ROGUE_STAT_INTELLIGENCE = -6,
		)
	dreams = list(
		"...you put your foot down and pull on the string. You wind the crossbow back with all your might. It feels like the thing is mocking you, impossible to pull taut. Only when a seasoned arbalist reminds you to pull from your back, and not your knees, do you make progress...",
		"...the crossbow is a deadly marvel of engineering, waiting for your guidance. You steady your breath, finger poised on the trigger. The world narrows as you take aim, the perfect shot soon to come...",
		)

/datum/attribute/skill/combat/wrestling
	name = "Wrestling"
	desc = "Alongside strength, improves your chance of grabbing, and avoiding a grab from an opponent."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -5,
		ROGUE_STAT_WILLPOWER = -6,
		)
	dreams = list(
		"...you grab him by the shirt and twist your hand with a mighty shove, working your opponent to the ground. The dirt fills your lungs but you feel his resistance give way as he coughs, a smile of approval crossing his face...",
		"...the dirt gets in your lungs and you can feel your legs quiver. You can't stand. You hear the clanking of plate, and see mighty boots stop in front of you. With a yank at their leg, your would-be killer is brought tumbling to the ground...",
		)

/datum/attribute/skill/combat/unarmed
	name = "Unarmed"
	desc = "Increases your chance to bypass your opponent's parry by 20% with unarmed or unarmed weapons such as katars, and your chance to bypass dodge by 10%. Unarmed attacks are swift-balanced, making them harder to parry and dodge when you are faster than your opponent. Wearing knuckles or bracers enables unarmed parrying."
	category = ROGUE_SKILL_CATEGORY_MELEE
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -4,
		ROGUE_STAT_WILLPOWER = -5,
		)
	dreams = list(
		"...the wet and harsh sound of skin against bone and clattering teeth reaches your ears before your mind processes what just happened. You got knocked out with a mighty blow to the jaw...",
		"...your nails are claws, your hands are weapons. A silent watcher in pale plate armor nods with approval at your ferocity...",
		)

/datum/attribute/skill/combat/shields
	name = "Shields"
	desc = "Increases your chance to bypass your opponent's parry by 20% with shields, and your chance to bypass dodge by 10%."
	category = ROGUE_SKILL_CATEGORY_BLOCKING
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_WILLPOWER
	default_attributes = list(
		ROGUE_STAT_WILLPOWER = -4,
		ROGUE_STAT_STRENGTH = -6,
		)
	dreams = list(
		"...a terrible lizard unleashes a torrent of fire upon you. Yet, you stand firm, a living bastion, unyielding and stalwart...",
		"...the half-moon crest upon your shield shines even in the bright of Astrata's day. You catch a gleam on it, and reflexively pull it upwards. An arrow bounces off...",
		)

/datum/attribute/skill/combat/slings
	name = "Slings"
	desc = "Alongside perception, increases the speed you ready a sling and have it ready to shoot. Does not influence damage or chance to hit."
	category = ROGUE_SKILL_CATEGORY_RANGED
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		ROGUE_STAT_STRENGTH = -7,
		)
	dreams = list(
		"...you recall an old maxim you read in a dusty tome within the archives: if you can throw, you can sling...",
		"...the perched archers ruthlessly repel the peasant rebellion. Hope for fairness is almost forlorn, until with a soft crack, a hailing of iron bullets clatter against the foe's helmets...",
		"...your arm tires from the toils of practice. Swinging rapidly has left your arm numb. With weary eyes, you glance aside to witness a hunter practice their craft with a brief overhand toss. Absorbing the technique, you mimic it, and effortlessly cast a powerful stone square onto the target...",
		)

/datum/attribute/skill/combat/firearms
	name = "Firearms"
	desc = "Alongside perception, increases the speed you ready a firearm and have it prepared to shoot. Does not influence damage or chance to hit. Additionally, it reduces the chances for failure of the weapon."
	category = ROGUE_SKILL_CATEGORY_RANGED
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		ROGUE_STAT_INTELLIGENCE = -6,
		)
	dreams = list(
		"...he tells you to stand straight, the stock to your shoulder. When it kicks, by the Ten, it hurts like hell. But the target? Well, the target is no more...",
		"...measuring the powder isn't an exact science, the grizzled mercenary explains. It's by eye and ear, once you've the understanding. His nub of an arm argues otherwise...",
		)

/datum/attribute/skill/craft/crafting
	name = "Crafting"
	desc = "Determines whether you can craft various items not under any other crafting skills."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -4,
		)
	dreams = list(
		"...you feel grass under your feet as you peer onto a meadow, you prepare a campfire and a tent and drift off into deep slumber...",
		"...you dig through the mud for worms with a spade you made from wood and stone gathered by the lakeside. Your fishing rod stands eager to bring you a meal, just like your grandfather taught you...",
		)

/datum/attribute/skill/craft/weaponsmithing
	name = "Weaponsmithing"
	desc = "Determines whether you can smith various weapons. Required to repair weapons successfully on tables."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_HARD
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		/datum/attribute/skill/craft/blacksmithing = -5,
		)
	dreams = list(
		"...tempered in gold and void, sharpened only by the sun and moon, your creation is finally complete. This one... This one will pierce the heavens...",
		"...sweat drips down your brow and your arms ache with every strike, but at last, the blade is forged. A masterpiece of steel and gold, adorned with rontz gems...",
		"...an old hunter stands in front of your counter and demands two dozen arrows. He hands you a bundle of sticks with a smile on his face...",
		)

/datum/attribute/skill/craft/armorsmithing
	name = "Armorsmithing"
	desc = "Determines whether you can smith various armor. Required to repair armor successfully on tables."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_HARD
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		/datum/attribute/skill/craft/blacksmithing = -5,
		)
	dreams = list(
		"...you stand amidst the deadite horde, their tooth and claw unable to dent your armor. Your creation. Your masterpiece...",
		"...the veteran's armor, battered beyond recognition, mirrors the scars upon his body. Yet, without your craft, he'd have fallen long ago. With skilled hands and a half a day's work, the armor is reborn - stronger than the day it was forged...",
		)

/datum/attribute/skill/craft/blacksmithing
	name = "Blacksmithing"
	desc = "Determines whether you can smith various non-weapons and armor items. Required to repair them successfully on table."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -5,
		ROGUE_STAT_INTELLIGENCE = -6,
		)
	dreams = list(
		"...you bow your head to the old master who scolds you for your wastefulness having left the forges unattended through the night...",
		"...you hammer away at a strange blue metal. It tempts you, begging to be formed into a crown of secrets...",
		"...the furnaces are lit and the forges roar. Today is a good day, and the lord of flame has blessed your smithy, the greatest in all the lands...",
		)

/datum/attribute/skill/craft/smelting
	name = "Smelting"
	desc = "Increases the quality of the ingots you smelt. Improves their sell price, but has no effect on the actual functionality of the items created."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_WILLPOWER
	default_attributes = list(
		/datum/attribute/skill/craft/blacksmithing = -5,
		)
	dreams = list(
		"...the slag falls away in glittering shards, leaving a bar of shining silver. It gleams with purpose, ready to be shaped...",
		"...you toil endlessly under the heat of the furnace; its fire roars with each sacrifice you offer, gifting you malleable metal in return...",
		)

/datum/attribute/skill/craft/carpentry
	name = "Carpentry"
	desc = "Determines whether you can craft various wooden items, structures and repair them, including wooden limbs."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -4,
		ROGUE_STAT_INTELLIGENCE = -5,
		)
	dreams = list(
		"...with a precise stroke, you bring down the hammer, nailing another peg into place. Your art turns mere wood into shelter and comfort...",
		"...with every beam you set, the house takes shape. The smell of fresh wood and sawdust fills the air as walls rise, and the roof begins to form. A shelter born from your hands...",
		"...you take a seat and there is no noise. None at all. The nightmare of its horrid creak is dispelled, and your thoughts turn to its make...",
		)

/datum/attribute/skill/craft/masonry
	name = "Masonry"
	desc = "Determines whether you can craft various stone items, gems and repair them."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -4,
		ROGUE_STAT_WILLPOWER = -5,
		)
	dreams = list(
		"...a fortress. Impenetrable. Everlasting. Brick by brick. Layer by layer. Stone upon stone. This is your magnum opus. This is the way of creation...",
		"...'3, 4 and 5 lead to the corner of 90.' your master, a wizened old elf adrift in the void, shows you how their mason's square indicates straight and strange corners alike...",
		)

/datum/attribute/skill/craft/engineering
	name = "Engineering"
	desc = "Determines whether you can craft or repair various mechanical structures including lever, trapdoors, and bronze items such as bronze limbs, grappler etc."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_VERY_HARD
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -7,
		)
	dreams = list(
		"...strange devices are familiar faces to you. The inner workings of your machines are of cogs. Cogs are their hearts, their mind and their will...",
		"...three levers lay before you. One will drop you into acid, another will release toxic gas but only one will free you. The moonlight shines on one of them, and you reach out...",
		"...with steady hands you shape a new limb, each joint and cog designed to restore what was lost. Your work is a quiet promise; they will walk again...",
		)

/datum/attribute/skill/craft/cooking
	name = "Cooking"
	desc = "Increases cooking & ingredients preparation speed. -25% if none, 0% if Novice, +50% per level after. At Journeyman you can ferment crops in a barrel."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -4,
		)
	dreams = list(
		"...over a crackling campfire, a slab of fresh meat sizzles as it cooks, its scent filling the air. The simplest meals are often the most difficult to perfect...",
		"...your knife bears down onto a wheel of cheese, and you cut away at the imperfections that lie on its skin. Next would be the eggs and the dough, and they'll roll together into a wonderful meal...",
		"...a one-eyed chef begins mashing apples in front of you before filling some pie dough. He can barely stop himself from salivating as he teaches you his secret ingredient...",
		)

/datum/attribute/skill/craft/sewing
	name = "Sewing"
	desc = "Determines whether you can craft various sewing-related items and repair them."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		ROGUE_STAT_INTELLIGENCE = -6,
		)
	dreams = list(
		"...as the years go by, the mantra becomes increasingly oppressive. Stitch, sew, cut ties, stitch, sew, thread the needle twice...",
		"...you turn over the fabric, and within the two layers of the gown, you hide a secret stitched into the gown, your initials, hidden within. A forbidden mark in some cultures... you never liked the bride much...",
		)

/datum/attribute/skill/craft/tanning
	name = "Skincrafting"
	desc = "Determines whether you can craft or repair various leather items. Reduces the work time on the tanning rack and improves minimum yield per hide by 1 per skill level. Also increases chance of getting an essence of wilderness from tanning hide."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		ROGUE_STAT_STRENGTH = -6,
		)
	dreams = list(
		"...your knife scrapes away at skin, flesh and fat, cleaning up the piece of hide so that it may be made into a wonderful cloak for the lord...",
		"...the hunter, their voice as rough as bark and their skin weathered like grain lets out a hearty laugh as he shows you his stitching...",
		)

/datum/attribute/skill/craft/ceramics
	name = "Pottery"
	desc = "Handles crafting and making of clay into vases and other fine-craft works."
	category = ROGUE_SKILL_CATEGORY_TRADE
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -4,
		ROGUE_STAT_PERCEPTION = -5,
		)
	dreams = list(
		"...the wheel spins, and spins.. yet you watch as a work of art grows from its center...",
		"...a slab of clay is molded into a beautiful statue. A testiment to Malum's blessings, and Xylix's insperation. A pure work of beauty...",
		)

/datum/attribute/skill/craft/alchemy
	name = "Alchemy"
	desc = "Determines what kind of potions you can brew and the types of transmutation and alchemy recipes you have access to"
	category = ROGUE_SKILL_CATEGORY_RESEARCH
	difficulty = ROGUE_SKILL_DIFFICULTY_VERY_HARD
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -7,
		)
	dreams = list(
		"...the smell of sulfur singes your nostrils... you taste iron... the smoke clears as you stare down at the reflection in your cauldron... the Queen stares back at you... she looks like she's crying...",
		)

/datum/attribute/skill/labor/farming
	name = "Farming"
	desc = "Allows you to identify seeds and increases workspeed and success chances on farming-related tasks."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -4,
		)
	dreams = list(
		"...the smell of dung was once revolting but it now smells like opportunity. The soil is hungry, so you get your hands dirty...",
		"...you scrape and plow until your muscles ache. The day was long, and soon the apples you plucked today would be rolled into a delicious pie...",
		"...you kneel in the soil, watering the seeds you've sown. The rows stretch out before you, green and thriving. You are filled with satisfaction, knowing your labor will soon bloom into abundance...",
		)

/datum/attribute/skill/labor/mining
	name = "Mining"
	desc = "Increases mining speed."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -4,
		ROGUE_STAT_WILLPOWER = -5,
		)
	dreams = list(
		"...rock crumbles and the wall before you gives way, your pickaxe has become battered and broken from the long day. You've mined into a strangely well lit cavern...",
		"...the red, gleaming light seeps from the ancient stone, next to its guardian - a bearded hermit of short stature, who riddles you on the strongest of steels...",
		"...the dwarven master riddles you, 'The strongest metal is the goal; I am harvested from mountains to shoal, yet I am not a metal,' the ancient miner chokes on the ill-air of the underworld, before continuing...",
		"...the gemstone gleams in his grasp, as the old dwarf chokes out, 'I must be forged in fourths. What am I?'...",
		"...and then the answer to his riddle comes to you, as if it was there all along. A lump of coal. With a satisfied smile, the dwarf hands you the heart of the mountain...",
		)

/datum/attribute/skill/labor/fishing
	name = "Fishing"
	desc = "Increases fishing speed down to a minimum of 2 seconds. Increases the chance of catching a fish. Novice is needed to not suffer a hefty penalty."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -4,
		)
	dreams = list(
		"...you struggle to unknot the fishing line for what feels like hours, your clumsy digits pulling away at it while on a small boat in a chasmic void. A gigantic, calloused, pale hand takes it from you and untangles it immediately in its grasp...",
		"...the old merchant nods his head, and gives you a small sack of baits: worms, grubs and even slices of cheese - each said to bring you another of Abyssor's bounties...",
		)

/datum/attribute/skill/labor/butchering
	name = "Butchering"
	desc = "Increases butchering speed. Increases yields from butchering a bodypart. If higher than your Skincrafting skill, will be used to determine the speed, yield and chance of getting an essence of wilderness when tanning hide."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -4,
		ROGUE_STAT_PERCEPTION = -5,
		)
	dreams = list(
		"...someone you recognize as a father twists the neck of the family rooster. He keeps you captivated as he guts it, speaking of gore and frugality...",
		"...your hands are bloodied and as you wipe them on your butcher's apron, a bell rings. A hooded customer enters your butcher's shop, and asks what meats you have for sale with a bemused look at your bloodied attire...",
		"...you pull the knife through fat, sinew and bone, the carcass giving way under your touch. The butcher's art is the transformation of life into sustenance...",
		)

/datum/attribute/skill/labor/lumberjacking
	name = "Lumberjacking"
	desc = "Increases lumberjacking speed. At Novice or higher, guarantee at least two small log from a tree. Higher skills increases minimum yield and chance of getting an essence of wilderness."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -4,
		ROGUE_STAT_WILLPOWER = -5,
		)
	dreams = list(
		"...splinters fly off as a tree falls down on the ground, sending a thundering boom throughout the forest...",
		"...you pull on a saw, and the bearded lumberjack across from you pulls back on it. The great oak yawns as it threatens to topple over...",
		)

/datum/attribute/skill/magic/holy
	name = "Miracles"
	desc = "Increases the effectiveness of the miracles granted by your patron."
	category = ROGUE_SKILL_CATEGORY_MAGIC
	difficulty = ROGUE_SKILL_DIFFICULTY_VERY_HARD
	governing_attribute = ROGUE_STAT_FORTUNE
	default_attributes = list(
		ROGUE_STAT_FORTUNE = -8,
		)

/datum/attribute/skill/magic/blood
	name = "Blood Sorcery"
	desc = "Currently does not affect anything."
	category = ROGUE_SKILL_CATEGORY_MAGIC
	difficulty = ROGUE_SKILL_DIFFICULTY_VERY_HARD
	governing_attribute = ROGUE_STAT_CONSTITUTION
	default_attributes = list(
		ROGUE_STAT_CONSTITUTION = -8,
		)

/datum/attribute/skill/magic/arcane
	name = "Arcane Magic"
	desc = "Decreases casting time by 5% per level."
	category = ROGUE_SKILL_CATEGORY_MAGIC
	difficulty = ROGUE_SKILL_DIFFICULTY_VERY_HARD
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -8,
		)

/datum/attribute/skill/magic/druidic
	name = "Druidic Trickery"
	desc = "Governs mastery over Dendor's nature rites. Unlocks higher tiers of animal transformation. Permits use of fey circles at Expert rank. Gates access to the Sanctified Tree's rituals by rank — from Novice through Master. Gained by completing tree bounties, sanctifying trees, and harvesting crops as a Dendor patron."
	category = ROGUE_SKILL_CATEGORY_MAGIC
	difficulty = ROGUE_SKILL_DIFFICULTY_VERY_HARD
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -8,
		ROGUE_STAT_FORTUNE = -9,
		)

/datum/attribute/skill/misc/athletics
	name = "Athletics"
	desc = "Increases your maximum stamina by 5 per point. Decreases chance of consuming nutrition when exerted by 16% per level."
	category = ROGUE_SKILL_CATEGORY_GENERAL
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_WILLPOWER
	default_attributes = list(
		ROGUE_STAT_WILLPOWER = -4,
		)
	dreams = list(
		"...your lungs burn and you can no longer feel your breath as the pale volf's howling grows distant. You should have collapsed three times over, but the urge to survive pushes you past your bodily limits...",
		"...the incline before you is steep, and the barrel weighs heavy in your hands but you press on. This is no longer a hill. This is your mountain and with every strained breath, you inch closer to its summit, determined to conquer it...",
		)

/datum/attribute/skill/misc/climbing
	name = "Climbing"
	desc = "Increases your climbing speed. A minimum level of 3 is required to climb most stone walls and 4 for mossy walls."
	category = ROGUE_SKILL_CATEGORY_GENERAL
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_STRENGTH
	default_attributes = list(
		ROGUE_STAT_STRENGTH = -5,
		ROGUE_STAT_WILLPOWER = -6,
		)
	dreams = list(
		"...your elbows are scraped and your hands, calloused but you have a firm hold on the rock wall. With a deep breath and a sudden lunge, you reach upward, searching for another handhold. Your foot slips and gravity pulls at you, your heart racing as you plummet into the void...",
		"...the meadows are shining green and the sun is behind a covering of clouds. Your childhood friend taunts you, his white toothed grin matching his pale eyes before dashing up a tree. You clamber after him and make your way upwards...",
		)

/datum/attribute/skill/misc/reading
	name = "Literacy"
	desc = "Increases your chance to read a spellbook successfully by 2% per level. Also raises your ability to write and comprehend skillbooks. Minimum of 1 is required to be literate and read various things."
	category = ROGUE_SKILL_CATEGORY_GENERAL
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -8,
		)
	dreams = list(
		"...amidst the void, strange symbols and glyphs make their way into your mind. They re-arrange themselves unceasingly, indecipherable truths speaking in silent voices. The clouds part, and they fall still within the moonlight. The meaning of the gift is revealed...",
		"...you cut into your meal, juices leaking from the edges of the book. Your mind expands throughout your meal, and you are about halfway through the meal when an old, bearded chef asks you how you like his specialty...",
		)

/datum/attribute/skill/misc/swimming
	name = "Swimming"
	desc = "Reduces stamina spent swimming slightly per level."
	category = ROGUE_SKILL_CATEGORY_GENERAL
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_WILLPOWER
	default_attributes = list(
		ROGUE_STAT_WILLPOWER = -5,
		ROGUE_STAT_STRENGTH = -6,
		)
	dreams = list(
		"...there is no light in the suffocating dark. You choose a direction and your arms and legs tear at the thick, oily waters in a desperate attempt to reach the surface. Your heart pounds, and your body yearns for another breath...",
		"...a wave rocks to the side of the boat, and you tumble into the yawning abyss. Lightning splits the sky as the old captain hurls a buoy into the churning sea. Salt water burns your lungs as you thrash and claw, struggling towards your lifeline...",
		"...the current  the beach draws you out further into the ocean, relentless and fast. Your muscles burn as you struggle, every stroke a battle. 'Across, not against!' a voice from your past chides, guiding you as you break free of the riptide's grasp...",
		)

/datum/attribute/skill/misc/stealing
	name = "Pickpocketing"
	desc = "Increases your chance to steal successfully without being caught."
	category = ROGUE_SKILL_CATEGORY_SKULDUGGERY
	difficulty = ROGUE_SKILL_DIFFICULTY_HARD
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -6,
		)
	dreams = list(
		"...one moment, you stand in line at the smithy, waiting behind the captain of the guard. The next, you're at the merchant's stall, shadowing a travelling noble. Moments later, cries of 'Thief!' echo throughout town, while you count out hundreds of mammon...",
		"...a piss-stinking, beggar with wooden-arms and a lice-ridden beard calls out to you, a rotten-toothed smile on his face. 'Spare a zenny for the wretched?' he asks. As you step away from the wretch, you feel strangely light at your waist. A glance down reveals your now empty pouch -- and two wooden arms abandoned on the ground where he had been sitting...",
		)

/datum/attribute/skill/misc/sneaking
	name = "Sneaking"
	desc = "Increases your chance of sneaking successfully and not be detected, and reduces your chances of leaving behind tracks."
	category = ROGUE_SKILL_CATEGORY_SKULDUGGERY
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_SPEED
	default_attributes = list(
		ROGUE_STAT_SPEED = -5,
		)
	dreams = list(
		"...the four connected houses, orthogonally aligned, have a small dip at the center of their slanted rooftops. Your crow's nest. Your safe haven. The only light that can reach you here is what Noc takes from Astrata, and this night is particularly veiled. It's concealing and comforting, safe from the town guard, as you curl up to rest...",
		"...the pale volf gets on its hindlegs, and howls unto the moon. It seeks prey, and you happen to be unfortunate enough to be in its forest. This is the third time it has circled you, as you press yourself tighter into the hollow tree, completely still...",
		)

/datum/attribute/skill/misc/lockpicking
	name = "Lockpicking"
	desc = "Speeds up lockpicking and increases success chance."
	category = ROGUE_SKILL_CATEGORY_SKULDUGGERY
	difficulty = ROGUE_SKILL_DIFFICULTY_HARD
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -7,
		ROGUE_STAT_INTELLIGENCE = -7,
		)
	dreams = list(
		"...your pick feels like an extension of your fingers as you nudge the final pin into place. The chest creaks open, revealing a glint of gold that was never meant to see the light of day...",
		"...the street and the merchant's shop stands silent in the moonlight as you kneel before the lock. Each quiet click draws you closer to riches--or discovery. With a soft snap, the door opens, allowing you to slip inside...",
		"...the old woman fumbles at her empty pockets, her face etched with worry. With a deft hand and a keen ear the lock yields and you push the door open, returning her to the warmth of her home...",
		)

/datum/attribute/skill/misc/riding
	name = "Riding"
	desc = "Increases the speed you ride a mount at, and the speed at which you can mount and dismount."
	category = ROGUE_SKILL_CATEGORY_GENERAL
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_WILLPOWER
	default_attributes = list(
		ROGUE_STAT_WILLPOWER = -6,
		)
	dreams = list(
		"...the bog becomes more tolerable when it is not your foot that has to tread upon it. It took some coin, but your travels are much smoother atop your trustworthy steed...",
		"...the landsknecht thrusts their pole-arm at your steed and it bucks wildly. Lurching forwards, you interpose your shield to the weapon and feel your balance shift. Flexing every muscle in your core and legs, you barely manage to remain mounted...",
		"...the tourney's onlookers cheer as you trot out onto the grounds, mounted atop a noble steed. A 'fogbeast', they call it - taller and thicker than the common saiga, draped in a caparison of your own design. Your opponent stares you down from across the circuit; a knight in blackened plate, who's steed is nothing more than bone-and-sinew...",
		"...the forest behind you collapses into a raging inferno, just as your steed leaps forth. With choked lungs and burning eyes, you cling tightly to the reins and mutter a prayer; yet against all the odds, the saiga sticks the landing. Welting eyes unpucker, graced with the dawn's cool breeze and the sight of your steed's continued galloping...",
		)

/datum/attribute/skill/misc/music
	name = "Music"
	desc = "Increases the effects of your music on reducing stresses per level. At Level 4 or above, allows you to play a custom song."
	category = ROGUE_SKILL_CATEGORY_GENERAL
	difficulty = ROGUE_SKILL_DIFFICULTY_HARD
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -7,
		ROGUE_STAT_PERCEPTION = -8,
		)
	dreams = list(
		"...offstage, anxiety grips you, sweat beading on your brow. But onstage, you are as still as a winter night, your voice steady and clear. Curiosity pulls your audience in as you begin to sing...",
		"...you raise your hands to the strings and draw the crowds attention unto yourself. The music comes easily out of you, and your lyre is like a second voice...",
		"...your audience moves under the music like grass against the wind. With a voice bold and boisterous, you sing of the comet's first coming, each note soaring proudly into the air...",
		"...the heat of the bonfire causes sweat to drip down your face. The crowd moves with fervor, their chants rising in rhythm with each beat. You can no longer tell if they follow your tempo or whether your hands obey the beating of their hearts. Tonight, the drum and their spirits thunder as one...",
		)

/datum/attribute/skill/misc/medicine
	name = "Medicine"
	desc = "Increases the speed and success chance of surgeries and suturing wounds."
	category = ROGUE_SKILL_CATEGORY_MEDICAL
	difficulty = ROGUE_SKILL_DIFFICULTY_EASY
	governing_attribute = ROGUE_STAT_INTELLIGENCE
	default_attributes = list(
		ROGUE_STAT_INTELLIGENCE = -6,
		)
	dreams = list(
		"...the beak-masked doctor leans over the elven corpse, tugging and slicing at a mass of strange, dark flesh. 'The appendix,' he mutters as he holds it aloft. 'Longer in this species of kin than others, adapted for their plant-rich diets.' He gestures for you to observe more closely, his tone as clinical as his blade...",
		"...you stand among seven other students the air thick with anticipation. Before you, two doctors clad in obscuring robes loom. Their masks set them apart: one an owl, wise and flat; the other a crow, inquisitive and sharp. The crow's voice cuts through the silence, instructing on the purpose of each tool laid before you...",
		"...a maskless void drags a veiled corpse into the center of the theater. The crow hands them a single coin, a silent exchange, and the faceless one departs. The lesson commences, and the owl pulls apart the layers of the torso like a macabre curtain; skin, fat and muscle giving way to revealing the liver, heart, stomach and other actors...",
		"...a student to your left pales, her queasiness overwhelming before she faints. You steel yourself, and look at the voidlike ribcage in the torso before you. Well-preserved chunks of flesh lie beside it, waiting for you to restore them to their rightful places...",
		)

/datum/attribute/skill/misc/tracking
	name = "Tracking"
	desc = "Increases your chance to find humanoid tracks. Increases the information you gain from them, alongside your perception stats. \n At Expert level or above, you can mark the target of a track to find them. \n At Master level or above, you can find invisible creatures. \n \ You can track by right-clicking on your eye icon."
	category = ROGUE_SKILL_CATEGORY_GENERAL
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		)
	dreams = list(
		"... your feet sink into the mud, forcing you to stop and re-evaluate. The storm is close, but not close enough, so you retrace your steps. Left, right, left, until you can manage to step on solid ground once more, taking a new route...",
		"... you kneel, taking a deep look at the floor, studying the slightly sunk shapes in the dirt. Paw-tracks, one after the other, heading up a hill. With a smile, you carry on...",
		"... the blood may have gotten lost in the rain, but the wounded man's boots are as fresh as jackberries, perfectly marked in the sand. You raise your bow, nock an arrow, and carefully trace them towards a cave...",
		)

/datum/attribute/skill/misc/hunting
	name = "Hunting"
	desc = "Your skill at finding animal trails and following them to their prey."
	category = ROGUE_SKILL_CATEGORY_DOMESTIC
	difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	governing_attribute = ROGUE_STAT_PERCEPTION
	default_attributes = list(
		ROGUE_STAT_PERCEPTION = -5,
		ROGUE_STAT_STRENGTH = -6,
		)
