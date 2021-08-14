ROLES = {}

module AlleyCat

  NAME = "Alley Cat"

  TRAITS = ["Lycanthrope", "Rogue", "Wild"]

  AGI = 8
  CON = 7
  MAG = 7
  MRL = 6
  PER = 8
  STR = 5

  STARTING_GP = 2
  STARTING_XP = 8
  STARTING_LUCK = 4
  STARTING_ITEMS = ["Begging Bowl", "Safety Collar"]
  STARTING_SKILLS = ["Claws", "Lycanthropy"]
end

ROLES["Alley Cat"] = AlleyCat

module AngelOfDeath

  NAME = "Angel of Death"

  TRAITS = ["Human", "Rogue", "Scholar"]

  AGI = 8
  CON = 6
  MAG = 7
  MRL = 7
  PER = 8
  STR = 6

  STARTING_GP = 8
  STARTING_XP = 6
  STARTING_LUCK = 2
  STARTING_ITEMS = ["Stilleto", "Vial of Poison"]
  STARTING_SKILLS = ["Sneak Attack"]
end

ROLES["Angel of Death"] = AngelOfDeath

module BanishedSorcerer

  NAME = "Banished Sorcerer"

  TRAITS = ["Reptilian", "Scholar", "Wizard"]

  AGI = 7
  CON = 6
  MAG = 9
  MRL = 6
  PER = 8
  STR = 6

  STARTING_GP = 8
  STARTING_XP = 10
  STARTING_LUCK = 4
  STARTING_ITEMS = ["Blinding Powder", "Filching Familiar"]
  STARTING_SKILLS = ["Meditation"]
end

ROLES["Banished Sorcerer"] = BanishedSorcerer

module BloodsportBrawler

  NAME = "Bloodsport Brawler"

  TRAITS = ["Human", "Fighter", "Performer"]

  AGI = 8
  CON = 9
  MAG = 5
  MRL = 8
  PER = 6
  STR = 9

  STARTING_GP = 2
  STARTING_XP = 4
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Spiked Gauntlet", "Warpaint"]
  STARTING_SKILLS = ["Foe Killer"]
end

ROLES["Bloodsport Brawler"] = BloodsportBrawler

module BogConjurer

  NAME = "Bog Conjurer"

  TRAITS = ["Human", "Warlock", "Wild"]

  AGI = 7
  CON = 8
  MAG = 9
  MRL = 6
  PER = 7
  STR = 8

  STARTING_GP = 2
  STARTING_XP = 10
  STARTING_LUCK = 4
  STARTING_ITEMS = ["Spirit Guide", "Totem Stick"]
  STARTING_SKILLS = ["Sixth Sense"]
end

ROLES["Bog Conjurer"] = BogConjurer

module CarnivalDrifter

  NAME = "Carnival Drifter"

  TRAITS = ["Human", "Performer", "Rogue"]

  AGI = 8
  CON = 6
  MAG = 8
  MRL = 6
  PER = 7
  STR = 6

  STARTING_GP = 4
  STARTING_XP = 10
  STARTING_LUCK = 3
  STARTING_ITEMS = ["Barbed Whip", "Fortune Cards"]
  STARTING_SKILLS = ["Performance"]
end

ROLES["Carnival Drifter"] = CarnivalDrifter

module CharlatanMagician

  NAME = "Charlatan Magician"

  TRAITS = ["Human", "Performer", "Wizard"]

  AGI = 8
  CON = 6
  MAG = 8
  MRL = 6
  PER = 7
  STR = 6

  STARTING_GP = 6
  STARTING_XP = 2
  STARTING_LUCK = 4
  STARTING_ITEMS = ["Hand Puppet", "Throwing Knives"]
  STARTING_SKILLS = ["Illusory Double", "Performance"]
end

ROLES["Charlatan Magician"] = CharlatanMagician

module CloakedKiller

  NAME = "Cloaked Killer"

  TRAITS = ["Reptilian", "Hunter", "Scholar"]

  AGI = 8
  CON = 7
  MAG = 7
  MRL = 5
  PER = 8
  STR = 7

  STARTING_GP = 4
  STARTING_XP = 2
  STARTING_LUCK = 3
  STARTING_ITEMS = ["Dart Pistol", "Hunter's Helm"]
  STARTING_SKILLS = ["Claws", "Lurker"]
end

ROLES["Cloaked Killer"] = CloakedKiller

module CorpseBurner

  NAME = "Corpse Burner"

  TRAITS = ["Human", "Puritan", "Rogue"]

  AGI = 7
  CON = 8
  MAG = 5
  MRL = 8
  PER = 7
  STR = 8

  STARTING_GP = 6
  STARTING_XP = 10
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Death Mask", "Grave Shovel"]
  STARTING_SKILLS = ["Burly"]
end

ROLES["Corpse Burner"] = CorpseBurner

module DishonoredKnight

  NAME = "Dishonored Knight"

  TRAITS = ["Human", "Fighter", "Militant"]

  AGI = 7
  CON = 8
  MAG = 6
  MRL = 9
  PER = 6
  STR = 9

  STARTING_GP = 8
  STARTING_XP = 4
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Breastplate", "Poleaxe"]
  STARTING_SKILLS = ["Provoke"]
end

ROLES["Dishonored Knight"] = DishonoredKnight

module FishyConfectioner

  NAME = "Fishy Confectioner"

  TRAITS = ["Fishoid", "Merchant", "Wild"]

  AGI = 7
  CON = 7
  MAG = 7
  MRL = 6
  PER = 7
  STR = 7

  STARTING_GP = 8
  STARTING_XP = 6
  STARTING_LUCK = 3
  STARTING_ITEMS = ["Scrogeye Aspic", "Scrogspike", "Scrog of Burden"]
  STARTING_SKILLS = ["Black Market"]
end

ROLES["Fishy Confectioner"] = FishyConfectioner

module HermitAscetic

  NAME = "Hermit Ascetic"

  TRAITS = ["Human", "Warlock", "Wizard"]

  AGI = 7
  CON = 8
  MAG = 9
  MRL = 6
  PER = 7
  STR = 7

  STARTING_GP = 1
  STARTING_XP = 3
  STARTING_LUCK = 4
  STARTING_ITEMS = ["Bone Totem", "Wizard Pipe"]
  STARTING_SKILLS = ["Repulsion", "Transcendence"]
end

ROLES["Hermit Ascetic"] = HermitAscetic

module HighwayRobber

  NAME = "Highway Robber"

  TRAITS = ["Human", "Rogue", "Hunter"]

  AGI = 8
  CON = 7
  MAG = 7
  MRL = 6
  PER = 8
  STR = 6

  STARTING_GP = 4
  STARTING_XP = 5
  STARTING_LUCK = 3
  STARTING_ITEMS = ["Blunderbuss", "Smoke Bomb"]
  STARTING_SKILLS = ["Looter"]
end

ROLES["Highway Robber"] = HighwayRobber

module Hinterlander

  NAME = "Hinterlander"

  TRAITS = ["Human", "Hunter", "Wild"]

  AGI = 8
  CON = 8
  MAG = 7
  MRL = 6
  PER = 9
  STR = 7

  STARTING_GP = 2
  STARTING_XP = 4
  STARTING_LUCK = 3
  STARTING_ITEMS = ["Hunting Bow", "Trail Ration"]
  STARTING_SKILLS = ["Fieldcraft"]
end

ROLES["Hinterlander"] = Hinterlander

module InfamousButcher

  NAME = "Infamous Butcher"

  TRAITS = ["Human", "Merchant", "Rogue"]

  AGI = 8
  CON = 8
  MAG = 5
  MRL = 6
  PER = 6
  STR = 8

  STARTING_GP = 4
  STARTING_XP = 8
  STARTING_LUCK = 2
  STARTING_ITEMS = ["Mystery Meat", "Nasty Cleaver"]
  STARTING_SKILLS = ["Gourmet"]
end

ROLES["Infamous Butcher"] = InfamousButcher

module JackSlasher

  NAME = "Jack Slasher"

  TRAITS = ["Human", "Hunter", "Wild"]

  AGI = 8
  CON = 7
  MAG = 7
  MRL = 5
  PER = 6
  STR = 7

  STARTING_GP = 2
  STARTING_XP = 10
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Pumpkin Hat", "Skinning Knife"]
  STARTING_SKILLS = ["Bloodlust"]
end

ROLES["Jack Slasher"] = JackSlasher

module MercenaryAlchemist

  NAME = "Mercenary Alchemist"

  TRAITS = ["Human", "Militant", "Scholar"]

  AGI = 7
  CON = 7
  MAG = 8
  MRL = 7
  PER = 8
  STR = 6

  STARTING_GP = 8
  STARTING_XP = 6
  STARTING_LUCK = 4
  STARTING_ITEMS = ["Flash Bomb", "Light Pistol"]
  STARTING_SKILLS = ["Alchemy"]
end

ROLES["Mercenary Alchemist"] = MercenaryAlchemist

module NaughtyNaturalist

  NAME = "Naughty Naturalist"

  TRAITS = ["Human", "Scholar", "Wild"]

  AGI = 7
  CON = 7
  MAG = 7
  MRL = 7
  PER = 8
  STR = 6

  STARTING_GP = 8
  STARTING_XP = 6
  STARTING_LUCK = 2
  STARTING_ITEMS = ["Dart Rifle", "Tranquilizer Darts"]
  STARTING_SKILLS = ["Find Weakness"]
end

ROLES["Naughty Naturalist"] = NaughtyNaturalist

module RiverPirate

  NAME = "River Pirate"

  TRAITS = ["Human", "Merchant", "Rogue"]

  AGI = 8
  CON = 8
  MAG = 6
  MRL = 6
  PER = 8
  STR = 8

  STARTING_GP = 6
  STARTING_XP = 2
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Lucky Tattoo", "Throwing Axe"]
  STARTING_SKILLS = ["River Rat"]
end

ROLES["River Pirate"] = RiverPirate

module Sharpshooter

  NAME = "Sharpshooter"

  TRAITS = ["Human", "Hunter", "Militant"]

  AGI = 7
  CON = 7
  MAG = 6
  MRL = 7
  PER = 8
  STR = 7

  STARTING_GP = 4
  STARTING_XP = 3
  STARTING_LUCK = 2
  STARTING_ITEMS = ["Arquebus", "Spyglass"]
  STARTING_SKILLS = ["Dead Eye Shot"]
end

ROLES["Sharpshooter"] = Sharpshooter

module SoldierOfFortune

  NAME = "Soldier of Fortune"

  TRAITS = ["Human", "Fighter", "Militant"]

  AGI = 7
  CON = 9
  MAG = 5
  MRL = 8
  PER = 7
  STR = 8

  STARTING_GP = 4
  STARTING_XP = 6
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Bastard Sword", "Shoddy Shield"]
  STARTING_SKILLS = ["Martial Discipline"]
end

ROLES["Soldier of Fortune"] = SoldierOfFortune

module SolitarySwordsman

  NAME = "Solitary Swordsman"

  TRAITS = ["Human", "Fighter", "Rogue"]

  AGI = 8
  CON = 7
  MAG = 6
  MRL = 7
  PER = 7
  STR = 8

  STARTING_GP = 2
  STARTING_XP = 6
  STARTING_LUCK = 3
  STARTING_ITEMS = ["Fancy Sabre", "Dueling Dagger"]
  STARTING_SKILLS = ["Counter"]
end

ROLES["Solitary Swordsman"] = SolitarySwordsman

module VerminHunter

  NAME = "Vermin Hunter"

  TRAITS = ["Human", "Hunter", "Rogue"]

  AGI = 8
  CON = 6
  MAG = 7
  MRL = 6
  PER = 8
  STR = 6

  STARTING_GP = 4
  STARTING_XP = 8
  STARTING_LUCK = 3
  STARTING_ITEMS = ["Gas Bomb", "Ratspike"]
  STARTING_SKILLS = ["Combat Reflexes"]
end

ROLES["Vermin Hunter"] = VerminHunter

module VoidWitch

  NAME = "Void Witch"

  TRAITS = ["Human", "Warlock", "Wizard"]

  AGI = 8
  CON = 5
  MAG = 9
  MRL = 6
  PER = 8
  STR = 5

  STARTING_GP = 4
  STARTING_XP = 8
  STARTING_LUCK = 6
  STARTING_ITEMS = ["Sacrificial Dagger", "Scroll of Ancient Gibberish"]
  STARTING_SKILLS = ["Voidwalker"]
end

ROLES["Void Witch"] = VoidWitch

module Wastelander

  NAME = "Wastelander"

  TRAITS = ["Human", "Fighter", "Wild"]

  AGI = 7
  CON = 9
  MAG = 5
  MRL = 6
  PER = 8
  STR = 9

  STARTING_GP = 2
  STARTING_XP = 6
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Hunting Hook", "Spiked Maul"]
  STARTING_SKILLS = ["Immunity"]
end

ROLES["Wastelander"] = Wastelander

module WitchSmeller

  NAME = "Witch Smeller"

  TRAITS = ["Human", "Hunter", "Puritan"]

  AGI = 8
  CON = 7
  MAG = 7
  MRL = 9
  PER = 8
  STR = 6

  STARTING_GP = 6
  STARTING_XP = 2
  STARTING_LUCK = 1
  STARTING_ITEMS = ["Weighted Pistol", "Witch Smeller's Nose"]
  STARTING_SKILLS = ["Intimidate"]
end

ROLES["Witch Smeller"] = WitchSmeller
