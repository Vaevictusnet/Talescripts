
loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

-- Initial values
compound_type = 6;
attrib_reqs = {
	{5,-1},
	{8,1},
	{7,1}
};

max_essences = 5;

compound_reqs = {
--	{"Test",1,15},
	{"Geb",2,4},
	{"Maat",2,7},
	{"Set",3,7},
	{"Osiris",2,10},
	{"Thoth",3,10},
	{"Ra",2,13}
};

mods = {
	[3]={"3",[-1]="-3"},
	[4]={"++",[-1]="--"},
	[6]={"6",[-1]="-6"},
	[7]={"+++",[-1]="---"},
	[9]={"9",[-1]="-9"},
	[10]={"++++",[-1]="----"},
	[12]={"12",[-1]="-12"},
	[13]={"+++++",[-1]="-----"},
	[15]={"15",[-1]="-15"},
};

attribs = {
	"Ar","As","Bi","Sa","So","Sp","Sw","To"
};

herb_list = {
"Allbright","Aloe","Altar's Blessing","Anansi","Apiphenalm","Apothecary's Scythe","Asafoetida","Artemisia","Asane","Ashoka","Azure Tristeria","Banto","Bay Tree",
"Bee Balm","Beetle Leaf","Beggar's Button","Bhilawa","Bilimbi","Bitter Florian","Black Pepper Plant","Blessed Mariae","Bleubillae","Blood Balm","Blood Blossom",
"Blooded Harebell","Blood Root","Bloodwort","Blueberry Tea Tree","Bluebottle Clover","Blue Damia","Blue Tarafern","Blushing Blossom","Brassy Caltrops",
"Brown Muskerro","Buckler-Leaf","Bull's Blood","Burnt Tarragon","Butterroot","Butterfly Damia","Calabash","Camelmint","Caraway","Cardamom","Cassia","Chaffa",
"Chatinabrae","Chives","Chukkah","Cicada Bean","Cinnamon","Cinquefoil","Cirallis","Clingroot","Common Basil","Common Rosemary","Common Sage","Corsacia","Covage",
"Crampbark","Cranesbill","Creeping Black Nightshade","Creeping Thyme","Crimson Clover","Crimson Lettuce","Crimson Nightshade","Crimson Pipeweed","Crimson WindLeaf",
"Crumpled Leaf Basil","Curly Sage","Cyan Cressida","DaggerLeaf","Dalchini","Dameshood","Dank Mullien","Dark Ochoa","Dark Radish","Deadly Catsclaw","Deadwood Tree",
"Death's Piping","Dewplant","Digweed","Discorea","Drapeau D'or","Dusty Blue Sage","Dwarf Hogweed","Dwarf Wild Lettuce","Earth Apple","Elegia","Enchanter's Plant",
"Finlow","Fire Allspice","Fire Lily","FivesLeaf","Flaming Skirret","Flander's Blossom","Fleabane","Fool's Agar","Fumitory","Garcinia","Garlic Chives",
"Ginger Root","Ginger Tarragon","Ginseng Root","Glechoma","Gnemnon","Gokhru","Golden Dubloons","Golden Gladalia","Golden Sellia","Golden Sun","Golden Sweetgrass",
"Golden Thyme","Gynura","Harebell","Harrow","Hazlewort","Headache Tree","Heartsease","Hogweed","Homesteader Palm","Honey Mint","Houseleek","Hyssop","Ice Blossom",
"Ice Mint","Ilex","Indigo Damia","Ipomoea","Jagged Dewcup","Jaivanti","Jaiyanti","Joy of the Mountain","Jugwort","Katako Root","Khokali","King's Coin","Lamae",
"Larkspur","Lavender Navarre","Lavender Scented Thyme","Lemon Basil","Lemondrop","Lemon Grass","Lilia","Liquorice","Lungclot","Lythrum","Mahonia","Malice Weed",
"Mandrake Root","Maragosa","Mariae","Meadowsweet","Medicago","Mindanao","Miniature Bamboo","Miniature Lamae","Mirabellis Fern","Moon Aloe","Morpha","Motherwort",
"Mountain Mint","Myristica","Myrrh","Naranga","Nubian Liquorice","Octec's Grace","Opal Harebell","Orange Niali","Orange Sweetgrass","Orris","Pale Dhamasa",
"Pale Ochoa","Pale Russet","Pale Skirret","Panoe","Paradise Lily","Patchouli","Peppermint","Pippali","Pitcher Plant","Primula","Prisniparni","Pulmonaria Opal",
"Purple Tintiri","Quamash","Red Pepper Plant","Revivia","Rhubarb","Royal Rosemary","Rubia","Rubydora","Sacred Palm","Sagar Ghota","Sandalwood","Sandy Dustweed",
"Satsatchi","Scaley Hardwood","Schisandra","Shrubby Basil","Shrub Sage","Shyama","Shyamalata","Sickly Root","Silvertongue Damia","Skirret","Sky Gladalia",
"Soapwort","Sorrel","Spinach","Spinnea","Squill","Steel Bladegrass","Stickler Hedge","Strawberry Tea","Strychnos","Sugar Cane","Sweetflower","Sweetgrass",
"Sweet Groundmaple","Sweetsop","Tagetese","Tamarask","Tangerine Dream","Thunder Plant","Thyme","Tiny Clover","Trilobe","Tristeria","True Tarragon","Tsangto",
"Tsatso","Turtle's Shell","Umber Basil","Upright Ochoa","Vanilla Tea Tree","Verdant Squill","Verdant Two-Lobe","Wasabi","Weeping Patala","Whitebelly",
"White Pepper Plant","Wild Garlic","Wild Lettuce","Wild Onion","Wild Yam","Wood Sage","Xanat","Xanosi","Yava","Yellow Gentian","Yellow Tristeria","Yigory",
"Zanthoxylum",
}
herbs = {};
for i=1,#herb_list do
	herbs[herb_list[i]] = 1;
end

resin_list = {
"Anaxi","Arconis","Ash Palm","Beetlenut","Bloodbark","Bottle Tree","Bramble Hedge","BroadLeaf Palm","ButterLeaf Tree","Cerulean Blue","Chakkanut Tree","Chicory",
"Cinnar","Coconut Palm","Cricklewood","Delta Palm","Elephantia","Feather Tree","Fern Palm","Folded Birch","Giant Cricklewood","Hawthorn","Hokkaido","Kaeshra",
"Locust Palm","Miniature Fern Palm","Mini Palmetto","Monkey Palm","Oil Palm","Oleaceae","Orrorin","Passam","Phoenix Palm","Pratyeka Tree","Ranyahn","Razor Palm",
"Red Maple","Royal Palm","Savaka","Spiked Fishtree","Spindle Tree","Stout Palm","Tapacae Miralis","Tiny Oil Palm","Towering Palm","Trilobellia","Umbrella Palm",
"Windriver Palm"
}
resins = {};
for i=1,#resin_list do
	resins[resin_list[i]] = 1;
end

chem_data = {
{"Anansi","39"," 7 Grain 3 Vegetable","6","0","0","0","-3","-2","-1","0","0"},
{"Anaxi","22"," 2 Grain, 8 Worm","6","0","-3","-1","0","3","0","-2","0"},
{"Arconis","34"," 9 Grain, 1 Mineral","6","0","-3","-1","0","2","0","0","1"},
{"Ash Palm","45"," 5 Grain, 5 Vegetable","6","0","0","0","3","-1","-2","-3","1"},
{"Bee Balm","48"," 7 Vegetable 3 Worm","6","0","-3","0","-1","3","2","0","1"},
{"Beetle Leaf","43"," 6 Vegetable 1 Wood 3 Worm","6","0","-1","1","0","2","-2","0","0"},
{"Beetlenut","70"," 10 Mineral","6","-2","0","-3","0","0","1","-1","0"},
{"Black Pepper Plant","10"," 10 Wood","6","0","1","-2","2","3","-1","0","0"},
{"Bloodbark","24"," 6 Worm, 4 Grain","6","-2","1","0","0","-1","2","-3","0"},
{"Blue Damia","50"," 8 Vegetable 2 Wood","6","-3","0","0","2","0","0","-1","1"},
{"Blue Tarafern","65"," 5 Mineral 5 Vegetable","6","1","-3","3","0","-1","-2","0","0"},
{"Bluebottle Clover","40"," 6 Vegetable 4 Wood","6","2","-3","1","-2","0","0","-1","0"},
{"Bottle Tree","50"," 5 Grain, 5 Mineral","6","0","0","-2","3","-1","-3","1","0"},
{"Bramble Hedge","42"," 1 Grain, 5 Mineral, 4 Wood","6","0","-3","0","1","2","-2","0","-1"},
{"Broadleaf Palm","30"," 10 Grain","6","0","2","0","-1","-3","-2","0","3"},
{"Brown Muskerro","10"," 10 Wood","6","2","0","-3","0","0","-1","3","-2"},
{"Bucklerleaf","78"," 8 Fish 2 Mineral","6","-2","2","-3","0","0","-1","0","0"},
{"Butterleaf Tree","85"," 8 Grey, 1 Mineral, 1 Vegetable","3","3","0","0","0","0","-1","-3","2"},
{"Cardamom","83"," 7 Grey 2 Mineral 1 Vegetable","3","0","-3","2","-1","0","0","0","-2"},
{"Cerulean Blue","34"," 9 Grain, 1 Mineral","6","0","3","0","1","-2","-3","0","-1"},
{"Chaffa","55"," 9 Vegetable 1 Wood","6","2","-3","0","0","-1","1","-2","0"},
{"Chakkanut Tree","57"," 9 Vegetable, 1 Grain","6","0","0","1","-3","0","2","0","-1"},
{"Chatinabrae","6"," 4 Rock 6 Wood","6","0","-1","3","-3","0","2","0","1"},
{"Chicory","37"," 2 Mineral, 3 Vegetable, 5 Wood","6","0","-1","0","0","-2","2","1","0"},
{"Chives","69"," 9 Mineral 1 Vegetable","6","0","0","0","0","-1","2","0","-2"},
{"Cinnamon","32"," 3 Vegetable 7 Worm","6","-3","-1","0","0","2","-2","3","1"},
{"Cinnar","6"," 4 Rock, 6 Wood","6","-1","0","3","1","-2","-3","0","0"},
{"Cinquefoil","33"," 9 Grain 1 Vegetable","6","-1","2","1","-2","0","-3","0","0"},
{"Coconut Palm","10"," 10 Wood","6","0","-2","-1","1","3","2","0","0"},
{"Common Basil","61"," 1 Mineral 9 Vegetable","6","1","-2","0","2","-1","3","0","0"},
{"Common Rosemary","67"," 7 Mineral 3 Vegetable","6","-3","0","-1","-2","3","0","1","0"},
{"Common Sage","52"," 8 Vegetable 2 Worm","6","2","-3","0","1","0","-1","0","0"},
{"Covage","21"," 1 Grain 9 Worm","6","0","0","-2","0","-1","0","0","2"},
{"Crampbark","36"," 4 Vegetable 6 Worm","6","1","0","2","-3","0","-1","-2","0"},
{"Cricklewood","54"," 2 Grain, 8 Vegetable","6","-3","3","0","-1","2","0","0","-2"},
{"Crimson Lettuce"," 91[3]"," 10 Grey","3","2","0","1","3","-2","0","0","-1"},
{"Crumpled Leaf Basil","1"," 9 Rock 1 Wood","6","-1","0","2","3","0","0","-2","0"},
{"Daggerleaf","31"," 1 Mineral 3 Vegetable 6 Wood","6","-1","0","0","1","0","0","0","0"},
{"Dalchini","71"," 1 Fish 9 Mineral","6","0","0","0","1","-1","0","-2","3"},
{"Dark Ochoa","65"," 5 Mineral 5 Vegetable","6","0","-2","1","0","-3","2","-1","0"},
{"Delta Palm","3"," 7 rock, 3 Wood","6","0","0","1","-2","0","-1","0","0"},
{"Discorea","83"," 7 Grey 2 Mineral 1 Vegetable","","-3","0","2","-1","0","1","0","-2"},
{"Drapeau Dor","33"," 9 Grain 1 Vegetable","3","0","0","0","-3","3","0","0","-1"},
{"Dusty Blue Sage","27"," 7 Grain 3 Worm","6","0","0","-3","0","2","-2","3","-1"},
{"Dwarf Hogweed","73"," 3 Fish 7 Mineral","6","-1","0","0","-3","3","-2","0","0"},
{"Dwarf Wild Lettuce","32"," 3 Vegetable 7 Worm","6","0","2","0","-2","0","-3","3","-1"},
{"Elephantia","46"," 6 Grain, 4 Mineral","6","0","-2","0","0","-3","0","-1","2"},
{"Feather Tree","73"," 3 Fish, 7 Mineral","6","-3","3","-1","0","1","2","-2","0"},
{"Fern Palm","62"," 2 Mineral, 8 Vegetable","6","-3","-2","3","0","-1","0","0","1"},
{"Fleabane","17"," 3 Wood 7 Worm","6","-2","1","0","-1","0","0","0","-3"},
{"Folded Birch","85"," 8 Grey, 1 Mineral, 1 Vegetable","3","0","0","-1","-3","1","-2","0","0"},
{"Fools Agar","52"," 8 Vegetable 2 Worm","6","-3","0","1","0","2","0","-1","-2"},
{"Fumitory","41"," 1 Mineral 5 Vegetable 4 Wood","6","1","3","-3","-1","2","0","0","-2"},
{"Garcinia","45"," 5 Grain 5 Vegetable","6","0","0","-2","0","-1","1","0","-3"},
{"Giant Cricklewood","29"," 9 Grain, 1 Worm","6","0","1","0","0","0","-2","0","-1"},
{"Ginger Root","87"," 9 Grey 1 Vegetable","3","3","0","0","-1","-2","-3","0","0"},
{"Ginseng Root","9"," 1 Rock 9 Wood","6","0","-1","-2","0","2","0","3","-3"},
{"Glechoma","19"," 1 Wood 9 Worm","6","-3","0","-2","0","1","-1","0","3"},
{"Golden Thyme","44"," 6 Vegetable 4 Worm","6","0","0","0","-2","2","-3","-1","3"},
{"Gynura","19"," 1 Wood 9 Worm","6","0","-1","1","-3","3","0","-2","0"},
{"Harebell","39"," 7 Grain 3 Vegetable","6","0","-2","-3","-1","0","0","0","0"},
{"Hawthorn","44"," 6 Vegetable, 4 Worm","6","0","3","-2","-3","2","0","0","-1"},
{"Hazlewort","72"," 2 Fish 8 Mineral","6","-1","-3","3","0","0","-2","1","0"},
{"Hogweed","24"," 1 Vegetable 9 Worm","6","-2","0","-1","0","2","0","3","-3"},
{"Hokkaido","2"," 8 Rock, 2 Wood","6","0","0","-2","3","-3","-1","0","1"},
{"Honey Mint","35"," 5 Vegetable 5 Wood","6","0","0","-2","0","2","-1","1","0"},
{"Houseleek","80"," 10 Fish","6","-1","0","0","0","3","0","-3","-2"},
{"Hyssop","42"," 6 Grain 4 Vegetable","6","3","1","2","0","-1","0","-2","0"},
{"Indigo Damia","52"," 8 Vegetable 2 Worm","6","0","-1","3","-3","0","-2","2","0"},
{"Jagged Dewcup","3"," 7 Rock 3 Wood","6","-1","0","-2","0","0","-3","2","0"},
{"Kaeshra","0"," 10 Rock","6","0","0","0","0","2","-1","3","-2"},
{"Katako Root","39"," 7 Grain 3 Vegetable","6","0","0","0","3","-1","-2","0","0"},
{"Lemondrop","7"," 3 Rock 7 Wood","6","-1","1","-2","-3","0","0","2","3"},
{"Locust Palm","6"," 4 Rock, 6 Wood","6","0","0","-3","-1","0","2","-2","0"},
{"Marble Dust","53"," 1 Grain 8 Vegetable 1 Worm","6","-1","2","-2","3","0","-3","0","1"},
{"Mini Palmetto","46"," 6 Grain, 4 Mineral","6","-2","0","-3","2","1","-1","0","0"},
{"Miniature Fern Palm","50"," 8 Vegetable, 2 Wood","6","2","0","0","0","-2","-1","-3","3"},
{"Monkey Palm","27"," 7 Grain, 3 Worm","6","0","-2","2","-3","0","3","-1","0"},
{"Mountain Mint","42"," 6 Grain 4 Vegetable","6","0","-2","0","0","0","-1","0","-3"},
{"Myristica","18"," 4 Grain 6 Wood","6","0","-2","3","0","0","1","-1","0"},
{"Oil Palm","69"," 9 Mineral, 1 Vegetable","6","-3","1","-2","0","0","0","0","-1"},
{"Oleaceae","9"," 1 Rock, 9 Wood","6","-2","0","0","0","-1","-3","3","0"},
{"Opal Harebell","69"," 9 Mineral 1 Vegetable","6","1","-1","-2","0","2","0","3","0"},
{"Orange Niali","10"," 10 Wood","6","-1","0","1","2","0","0","-2","0"},
{"Orrorin","40"," 5 Vegetable, 5 Worm","6","-2","0","0","-1","0","-3","0","0"},
{"Pale Dhamasa","4"," 6 Rock 4 Wood","6","-3","0","0","0","3","-1","1","-2"},
{"Passam","54"," 2 Grain, 8 Vegetable","6","0","-1","0","-2","1","0","0","0"},
{"Phoenix Palm","8"," 2 Rock 8 Wood","6","3","-1","0","-3","-2","0","1","0"},
{"Powdered Amethyst","56"," 9 Vegetable, 1 Worm","6","-2","-1","0","0","-3","0","2","1"},
{"Powdered Citrine","55"," 9 Vegetable, 1 Wood","6","-2","0","2","0","-1","0","1","0"},
{"Powdered Diamond","25"," 5 Grain, 5 Worm","6","-1","0","0","-2","0","0","-3","0"},
{"Powdered Emerald","9"," 1 Rock, 9 Wood","6","-2","0","-1","-3","0","0","1","0"},
{"Powdered Garnet","44"," 6 Vegetable, 4 Worm","6","-3","3","-2","2","1","-1","0","0"},
{"Powdered Jade","9"," 1 Rock, 9 Wood","6","-3","0","-2","0","-1","1","0","0"},
{"Powdered Opal","67"," 7 Mineral, 3 Vegetable","6","-1","-2","2","0","0","-3","0","0"},
{"Powdered Quartz","49","1 Grain, 7 Vegetable, 2 Worm","6","-1","-3","-2","3","0","0","0","0"},
{"Powdered Ruby","16"," 4 Wood, 6 Worm","6","0","-2","0","-3","2","-1","3","0"},
{"Powdered Sapphire","50"," 5 Grain, 5 Mineral","6","0","-3","0","1","3","-1","0","2"},
{"Powdered Topaz","49"," 1 Grain, 7 Vegetable, 2 Worm","6","2","0","-1","-2","0","1","0","0"},
{"Pratyeka Tree","34"," 4 Vegetable, 2 Wood, 4 Worm","6","0","0","0","-2","-3","2","0","-1"},
{"Ranyahn","16"," 4 Wood, 6 Worm","6","3","-2","-1","0","-3","0","0","2"},
{"Razor Palm","61"," 9 Vegetable, 1 Mineral","6","1","0","0","-3","3","0","0","-1"},
{"Red Maple","2"," 8 Rock, 2 Wood","6","2","-2","-1","0","0","-3","0","0"},
{"Rhubarb","37"," 1 Grain 5 Vegetable 4 Wood","6","-3","2","-1","1","0","0","0","0"},
{"Royal Palm","76"," 6 Fish, 4 Mineral","6","0","0","-2","0","-1","0","0","-3"},
{"Sagar Ghota","89"," 1 Fish 9 Grey","3","1","-1","-3","-2","0","0","0","0"},
{"Salts Of Aluminum","79"," 9 Fish 1 Mineral","6","0","3","-2","1","0","0","0","-1"},
{"Salts Of Antimony","43"," 6 Vegetable 1 Wood 3 Worm","6","0","-1","-2","3","-3","2","0","0"},
{"Salts Of Copper","23"," 3 Grain 7 Worm","6","2","1","0","0","-1","-2","-3","0"},
{"Salts Of Gold","4"," 6 Rock 4 Wood","6","-1","-3","0","-2","0","1","0","2"},
{"Salts Of Iron","71"," 1 Fish 9 Mineral","6","0","0","3","-2","2","-3","0","-1"},
{"Salts Of Lead","27"," 7 Grain 3 Worm","6","-1","0","0","3","0","0","-3","1"},
{"Salts Of Lithium","48"," 7 Vegetable 3 Worm","6","0","0","-3","0","-2","-1","0","2"},
{"Salts Of Magnesium","29"," 9 Grain 1 Worm","6","3","-3","0","-1","0","2","0","0"},
{"Salts Of Platinum","11"," 9 Wood 1 Worm","6","-1","2","0","0","0","3","0","0"},
{"Salts Of Silver","81"," 1 Grain 8 Grey 1 Vegetable","3","-1","0","0","-2","3","1","2","0"},
{"Salts Of Strontium","80"," 10 Fish","6","2","1","-3","3","-2","0","-1","0"},
{"Salts Of Tin","70"," 10 Mineral","6","0","2","0","3","1","-3","0","-1"},
{"Salts Of Titanium","74"," 4 Fish 6 Mineral","6","-1","0","0","0","-2","2","0","-3"},
{"Salts Of Tungsten","10"," 10 Wood","6","3","-3","-1","0","-2","0","0","1"},
{"Salts Of Zinc","65"," 5 Mineral 5 Vegetable","6","-2","2","3","-1","-3","0","0","0"},
{"Savaka","78"," 8 Fish, 2 Mineral","6","-1","1","0","0","0","-3","0","2"},
{"Shyama","79"," 9 Fish 1 Mineral","6","-2","-1","3","0","0","0","0","0"},
{"Spiked Fishtree","3"," 7 Rock, 3 Wood","6","-1","3","0","0","0","0","-3","2"},
{"Spindle Tree","17"," 3 Wood, 7 Worm","6","0","3","1","-3","2","0","-2","-1"},
{"Stout Palm","79"," 9 Fish, 1 Mineral","6","0","0","0","-1","-3","-2","0","0"},
{"Strawberry Tea","27"," 7 Grain 3 Worm","6","0","1","-1","0","3","0","-3","0"},
{"Sweetgrass","2"," 8 Rock 2 Wood","6","-3","0","0","0","0","1","-2","-1"},
{"Tapacae Miralis","30"," 4 Vegetable, 6 Wood","6","1","0","0","-2","3","-1","0","2"},
{"Thyme","45"," 7 Vegetable 3 Wood","6","0","0","2","0","0","-2","-1","0"},
{"Tiny Clover","17"," 3 Wood 7 Worm","6","3","0","-2","-3","0","1","-1","2"},
{"Tiny Oil Palm","34"," 9 Grain, 1 Mineral","6","0","0","-1","-2","0","0","1","3"},
{"Towering Palm","67"," 7 Mineral, 3 Vegetable","6","1","-2","0","2","3","0","-1","0"},
{"Trilobellia","0"," 10 Rock","6","0","1","0","3","0","0","0","-1"},
{"Umbrella Palm","45"," 5 Mineral, 5 Worm","6","0","-1","3","0","0","2","-3","-2"},
{"Verdant Squill","20"," 2 Vegetable 8 Wood","6","0","2","0","0","-3","-2","1","-1"},
{"Wild Lettuce","47"," 1 Grain 7 Vegetable 2 Wood","6","0","-1","3","1","0","0","2","-3"},
{"Windriver Palm","49"," 1 Grain, 7 Vegetable, 2 Worm","6","-1","0","3","0","-3","-2","0","1"}
};

function color(s)
	if herbs[s] then
		return 0x80D080ff;
	elseif resins[s] then
		return 0xD0D080ff;
	else
		return 0x808080ff;
	end
end

solve_result = {};
solve_tooltip = {};
solve_lists = {};
dp = {};
dp_count = 0;

function addResult(s, tip)
	local index = #solve_result+1;
	solve_result[index] = s;
	solve_tooltip[index] = tip;
end

function key_from_vars(vars)
	local r = 0;
	local i;
	for i=1,#vars do
		r = r*100;
		r = r + vars[i]+50;
	end
	return r;
end

-- value is a list of essence indices
function cache(left, index, key, value)
	if not dp[left] then
		dp[left] = {};
	end
	if not dp[left][index] then
		dp[left][index] = {};
	end
	if not dp[left][index][key] then
		dp[left][index][key] = {};
	end
	dp[left][index][key][#dp[left][index][key]+1] = value;
end

function iscached(left, index, key)
	if not dp[left] then
		return nil;
	end
	if not dp[left][index] then
		return nil;
	end
	return dp[left][index][key];
end
-- returns a list of lists
function getcache(left, index, key)
	if not dp[left] then
		return nil;
	end
	if not dp[left][index] then
		return nil;
	end
	if not dp[left][index][key] then
		return nil;
	end
	if dp[left][index][key][1][1] == 0 then
		return nil;
	end
	return dp[left][index][key];
end


function dodp(left, index, vars)
	if (index > #chem_data) then
		return nil;
	end
	if (left == 0) then
		error 'assert';
	end
	local key=key_from_vars(vars);
	if iscached(left, index, key) then
		--lsPrintln("cached: " .. left .. "," .. index .. "," .. vars[1]);
		return getcache(left, index, key);
	end
	--lsPrintln("uncach: " .. left .. "," .. index .. "," .. vars[1]);
	dp_count = dp_count + 1;
	if (dp_count % 5000) == 0 then
		statusScreen("Solving...  Searched " .. dp_count .. "...");
	end
	local i;
	local j;

	-- Try not using this index	
	local ret = dodp(left, index+1, vars);
	if ret then
		for i=1, #ret do
			-- cache results of not using this one into this index
			cache(left, index, key, ret[i]);
		end
	end
	
	-- Try using this index
	local newvars = {};
	for i=1, compound_reqs[compound_type][2] do
		newvars[i] = vars[i] + chem_data[index][4 + attrib_reqs[i][1]];
	end
	if (left == 1) then
		-- check it
		local good = true;
		for i=1, compound_reqs[compound_type][2] do
			local sign = attrib_reqs[i][2];
			if newvars[i]*sign < compound_reqs[compound_type][3] then
				good = nil;
			end
		end
		if good then
			cache(left, index, key, {index});
		end
	else
		-- Check if possible
		local possible=true;
		for i=1, compound_reqs[compound_type][2] do
			local sign = attrib_reqs[i][2];
			if vars[i]*sign + left*3 < compound_reqs[compound_type][3] then
				possible = nil;
			end		 
		end
		if not possible then
			-- not searching below
		else
			local ret = dodp(left-1, index+1, newvars);
			if ret then
				for i=1, #ret do
					local tail = ret[i];
					local newlist = {index};
					for j=1, #tail do
						newlist[j+1] = tail[j];
					end
					cache(left, index, key, newlist);
				end
			end
		end
	end
	
	if not iscached(left, index, key) then
		cache(left, index, key, {0});
		if not iscached(left, index, key) then
			error 'assert 2';
		end
	end

	return getcache(left, index, key);	
end

function solve()
	local i, j;
	solve_result = {};
	solve_tooltip = {};
	solve_lists = {};
	dp = {};
	dp_count = 0;
	local vars = {};
	for i=1, compound_reqs[compound_type][2] do
		vars[#vars+1] = 0;
	end
	local ret = dodp(max_essences, 1, vars);
	if ret then
		solve_lists = ret;
		addResult("Searched: " .. dp_count .. " Found: " .. #ret, nil);
		local s = "";
		for i=1, compound_reqs[compound_type][2] do
			s = s .. attribs[attrib_reqs[i][1]] .. " " .. mods[compound_reqs[compound_type][3]][attrib_reqs[i][2]];
			if not (i == compound_reqs[compound_type][2]) then
				s = s .. " || ";
			end
		end
		if false then
			local head = s;
			for i=1, #ret do
				local s = "";
				local list = ret[i];
				for j=1, #list do
					local index = list[j];
					s = s .. chem_data[index][1];
					if not (j == #list) then
						s = s .. " || ";
					end
				end
				lsPrintln("| " .. head .. " || " .. s .. " |");
				if false then
					local combined = s;
					local tip = "";
					for j=1, #list do
						local index = list[j];
						s = "    " .. chem_data[index][1] .. " (" .. chem_data[index][3] .. ")";
						tip = tip .. s;
						if not (j == #list) then
							tip = tip .. "\n";
						end
						lsPrintln(s);
					end
					--addResult(combined, tip);
				end
			end
		end
	else
		addResult("Searched: " .. dp_count, nil);
		addResult("No solution was found", nil);
	end
end

function doit()
	local selected = {};
	local chem_cache = nil;
	local scale = 25/16.0;
	z = 1;
	tip = "";
	while 1 do
		lsSetCamera(0, 0, lsScreenX*scale, lsScreenY*scale);
		local maxX = lsScreenX*scale;
		local maxY = lsScreenY*scale;
		for i=1,#compound_reqs do
			x = (i-1)*60;
			if compound_type == i then
				lsPrint(x, 5, z, 1, 1, 0xFFFFFFff, compound_reqs[i][1]);
			elseif lsButtonText(x, 5, z, 60, 0xFFFFFFff, compound_reqs[i][1]) then
				compound_type = i
			end
		end
		
		x=10;
		y=32;
		for i=1, compound_reqs[compound_type][2] do
		
			attrib_reqs[i][1] = lsDropdown("ChemDropDown" .. i, x, y, z, 50,
				attrib_reqs[i][1], attribs);
			if lsButtonText(x+50, y, z, 100, 0xFFFFFFff, mods[compound_reqs[compound_type][3]][attrib_reqs[i][2]]) then
				attrib_reqs[i][2] = -attrib_reqs[i][2];
			end

			y=y+26;
		end
		
		y = y+5;
		
		if lsButtonText(0, y, z, 100, 0xFFFFFFff, "Solve") then
			statusScreen("Solving... (this may take a while)");
			statusScreen("Solving... (this may take a while)");
			solve();
			statusScreen("Done solving, generating ingredient browser...");
			statusScreen("Done solving, generating ingredient browser...");
			selected = {};
			chem_cache = nil;
		end
		y=y+30;

		if false then
			if lsButtonText(0, y, z, 400, 0xFFFFFFff, "Generate all to console") then
				statusScreen("Working... (this will take ages");
				for a11=1, 8 do
					attrib_reqs[1][1]=a11;
					for a12=-1,1,2 do
						attrib_reqs[1][2]=a12;
						for a21=attrib_reqs[1][1]+1, 8 do
							attrib_reqs[2][1]=a21;
							for a22=-1,1,2 do
								attrib_reqs[2][2]=a22;
								local s = "";
								for i=1, compound_reqs[compound_type][2] do
									s = s .. attribs[attrib_reqs[i][1]] .. " " .. mods[compound_reqs[compound_type][3]][attrib_reqs[i][2]];
									if not (i == compound_reqs[compound_type][2]) then
										s = s .. ", ";
									end
								end
								statusScreen("Solving " .. s);
								solve();
							end
						end
					end
				end
			end
		end
		
		y=y+45;

		
		local max_solutions = #solve_result;
		if max_solutions > 30 then
			max_solutions = 30;
		end
		
		for i=1, max_solutions do
			if solve_tooltip[i] then
				if lsButtonText(10, y, z, maxX - 12, 0xFFFFFFff, solve_result[i]) then
					tip = solve_tooltip[i];
				end
			else
				lsPrint(10, y, z, 1, 1, 0xFFFFFFff, solve_result[i]);
			end
			y=y+26;
		end

		if tip then
			lsPrintWrapped(150, 32, z+1, maxX - 150, 0.7, 0.7, 0xFFFFFFff, tip);
		end
		
		-- heirarchical display
		for i=#selected, 1, -1 do
			if lsButtonText(165, 32+(i-1)*26, z, maxX - 165, color(chem_data[selected[i]][1]), chem_data[selected[i]][1] .. " (" .. chem_data[selected[i]][3] .. ")") then
				-- remove it
				for j=i, #selected-1 do
					selected[j] = selected[j+1];
				end
				selected[#selected] = nil;
				chem_cache = nil;
			end
		end
		
		local build_cache = false;
		if not chem_cache then
			build_cache = true;
			chem_cache = {};
		end
		lsScrollAreaBegin("ChemDataScrollArea", 5, y, z-1, 318, maxY - y);
		y = 0;
		-- reduce recipes to those that are valid
		local ingredient_recipe_count = {};
		if build_cache then
			for j=1, #solve_lists do
				-- check if recipe matches current list
				local this_valid = true;
				for ii=1, #selected do
					local found=false;
					for k=1, max_essences do
						if selected[ii] == solve_lists[j][k] then
							found = true;
						end
					end
					if not found then
						this_valid = false;
					end
				end
				if this_valid then
					for k=1, max_essences do
						local idx = solve_lists[j][k];
						if ingredient_recipe_count[idx] then
							ingredient_recipe_count[idx] = ingredient_recipe_count[idx] + 1;
						else
							ingredient_recipe_count[idx] = 1;
						end
					end
				end
			end
			for j=1, #selected do
				ingredient_recipe_count[selected[j]] = nil;
			end
		end
		clear_cache = false;
		for i=1, #chem_data do
			if build_cache then
				local skip=false;
				recipe_count = ingredient_recipe_count[i];
				
				if (#solve_lists > 0) and (recipe_count == #solve_lists) then
					selected[#selected+1] = i;
					clear_cache = true;
					recipe_count = nil
				end
				chem_cache[i] = recipe_count;
			else
				recipe_count = chem_cache[i];
			end
			if recipe_count then
				if lsButtonText(0, y, z, 300, color(chem_data[i][1]), chem_data[i][1] .. " (" .. recipe_count .. ")") then
					selected[#selected+1] = i;
					clear_cache = true;
				end
				y = y + 26;
			end
		end
		if clear_cache then
			chem_cache = nil;
		end
		
		lsScrollAreaEnd(y);
		
		if (maxX < 465) or (maxY < 400) then
			lsPrint(10, maxY-30, z+3, 0.7, 0.7, 0x801010ff, "You may need to resize this window to see everything.");
		end
		if lsButtonText(maxX - 72, maxY - 26*3, z, 70, 0xFFFFFFff, "Font +") then
			scale = scale * 4/5;
		end
		if lsButtonText(maxX - 72, maxY - 26*2, z, 70, 0xFFFFFFff, "Font -") then
			scale = scale * 5/4;
		end
		if lsButtonText(maxX - 142, maxY - 26, z, 140, 0xFFFFFFff, "Menu (slow)") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(25);
	end
end