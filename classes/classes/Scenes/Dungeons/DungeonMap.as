package classes.Scenes.Dungeons {
	import classes.*;
	import classes.GlobalFlags.*;
	import classes.Scenes.Dungeons.*;
	
	public class DungeonMap extends BaseContent
	{
		
		public function DungeonMap() {}
		
		//How to work with the refactored map:
		//-1 is wide empty space 1x3.
		//-2 is narrow empty space 1x1.
		//-3 is vertical passage. (|)
		//-4 is horizontal passage.  (-)
		//-5 is locked passage. Only used for boolean checks. (L)
		//The numbered rooms correspond to the room ID.
		
		// -- Factory --
		public const MAP_FACTORY_F1:Array = [ //Room 00-05 + 06
			"Factory, Floor 1",
			[-1, -2, 04, -2, -1],
			[-1, -2, -3, -2, -1],
			[05, -4, 02, -4, 03],
			[-1, -2, l1, -2, -1],
			[09, -4, 00, -4, 01],
			[-1, -2, -3, -2, -1]
		];
		public const MAP_FACTORY_F2:Array = [ //Room 06-08
			"Factory, Floor 2",
			[06, -4, 07],
			[l2, -2, -2],
			[08, -2, -1]
		];
		
		// -- Deep Cave --
		public const MAP_DEEPCAVE:Array = [ //Room 10-16
			"Zetaz's Lair",
			[-1, -2, 16, -4, 15],
			[-1, -2, l3, -2, -3],
			[13, -4, 12, -4, 14],
			[-1, -2, -3, -2, -1],
			[-1, -2, 11, -2, -1],
			[-1, -2, -3, -2, -1],
			[-1, -2, 10, -2, -1],
			[-1, -2, -3, -2, -1]
		];
		
		// -- Lethice's Stronghold --
		public const MAP_STRONGHOLD_P1:Array = [
			"Basilisk Cave"
		];
		public const MAP_STRONGHOLD_P2:Array = [
			"Lethice's Stronghold"
		];
		
		// -- Desert Cave --
		public const MAP_DESERTCAVE:Array = [
			"Cave of the Sand Witches",
			[-1, -2, -1, -2, 38, -2, -1, -2, -1],
			[-1, -2, -1, -2, -3, -2, -1, -2, -1],
			[29, -2, 26, -2, 37, -2, 32, -4, 33],
			[-3, -2, -3, -2, -3, -2, -3, -2, -2],
			[28, -4, 25, -4, 24, -4, 31, -4, 34],
			[-3, -2, -3, -2, -3, -2, -2, -2, -3],
			[30, -2, 27, -2, 23, -2, 36, -4, 35],
			[-1, -2, -1, -2, -3, -2, -1, -2, -1]
		];
		
		// -- Phoenix Tower --
		public const MAP_PHOENIXTOWER_B1:Array = [
			"Tower of the Phoenix, Basement",
			[-1, -2, 20],
			[-1, -2, -1],
			[-1, -2, 18]
		];
		public const MAP_PHOENIXTOWER_F1:Array = [
			"Tower of the Phoenix, Floor 1",
			[-1, -2, 19],
			[-1, -2, -3],
			[-1, -2, 17],
			[-1, -2, -3]
		];
		public const MAP_PHOENIXTOWER_F2:Array = [
			"Tower of the Phoenix, Floor 2",
			[-1, -2, 21],
			[-1, -2, -1],
			[-1, -2, -1]
		];
		public const MAP_PHOENIXTOWER_F3:Array = [
			"Tower of the Phoenix, Floor 3",
			[-1, -2, 22],
			[-1, -2, -1],
			[-1, -2, -1]
		];
		
		// -- Anzu's Palace --
		public const MAP_ANZUPALACE_B1:Array = [
			"Anzu's Palace, Basement",
			[-1, -2, -1, -2, -1],
			[-1, -2, -1, -2, -1],
			[54, -4, 53, -2, -1]
		];
		public const MAP_ANZUPALACE_F1:Array = [
			"Anzu's Palace, Floor 1",
			[42, -2, -1, -2, 44],
			[-3, -2, -1, -2, -3],
			[41, -4, 40, -4, 43],
			[-1, -2, -3, -2, -1],
			[-1, -2, 39, -2, -1],
			[-1, -2, -3, -2, -1]
		];
		public const MAP_ANZUPALACE_F2:Array = [
			"Anzu's Palace, Floor 2",
			[-1, -2, 48, -2, -1],
			[-1, -2, -3, -2, -1],
			[46, -4, 45, -4, 47]
		];
		public const MAP_ANZUPALACE_F3:Array = [
			"Anzu's Palace, Floor 3",
			[-1, -2, -1, -2, -1],
			[-1, -2, -1, -2, -1],
			[50, -4, 49, -4, 51]
		];
		public const MAP_ANZUPALACE_F4:Array = [
			"Anzu's Palace, Roof",
			[-1, -2, -1, -2, -1],
			[-1, -2, -1, -2, -1],
			[-1, -2, 52, -2, -1]
		];
		
		public function get l1():int { //Door that requires iron key.
			//return (player.hasKeyItem("Iron Key") >= 0 ? -3 : -5);
			return -3;
		}
		public function get l2():int { //Door that requires supervisors key.
			//return (player.hasKeyItem("Supervisor's Key") >= 0 ? -3 : -5);
			return -3;
		}	
		public function get l3():int { //Door in Zetaz's lair.
			//return (flags[kFLAGS.ZETAZ_DOOR_UNLOCKED] > 0 ? -3 : -5);
			return -3;
		}	
		public function get l4():int { //Door in desert cave.
			//return (flags[kFLAGS.SANDWITCH_THRONE_UNLOCKED] > 0 ? -3 : -5);
			return -3;
		}
		public function findLockedDoorLethiceThrone():int {
			//return (kGAMECLASS.d3.unlockedThroneRoom() ? -3 : -5);
			return -3;
		}
		
		public function chooseRoomToDisplay():void {
			if (kGAMECLASS.dungeonLoc >= 0 && kGAMECLASS.dungeonLoc < 10) { //Factory
				if (kGAMECLASS.dungeonLoc < 6 || kGAMECLASS.dungeonLoc == 9)
					buildMapDisplay(MAP_FACTORY_F1);
				else 
					buildMapDisplay(MAP_FACTORY_F2);
			}
			else if (kGAMECLASS.dungeonLoc >= 10 && kGAMECLASS.dungeonLoc < 17) { //Zetaz's Lair
				buildMapDisplay(MAP_DEEPCAVE);
			}
			else if (kGAMECLASS.dungeonLoc >= 17 && kGAMECLASS.dungeonLoc < 23) { //Tower of the Phoenix
				switch(kGAMECLASS.dungeonLoc) {
					case 18:
					case 20:
						buildMapDisplay(MAP_PHOENIXTOWER_B1);
						break;
					case 17:
					case 19:
						buildMapDisplay(MAP_PHOENIXTOWER_F1);
						break;
					case 21:
						buildMapDisplay(MAP_PHOENIXTOWER_F2);
						break;
					case 22:
						buildMapDisplay(MAP_PHOENIXTOWER_F3);
						break;
					default:
						buildMapDisplay(MAP_PHOENIXTOWER_F1);
				}
			}
			else if (kGAMECLASS.dungeonLoc >= 23 && kGAMECLASS.dungeonLoc < 39) { //Desert Cave
				buildMapDisplay(MAP_DESERTCAVE);
			}
			else if (kGAMECLASS.dungeonLoc >= 39 && kGAMECLASS.dungeonLoc < 55) { //Anzu's Palace
				if (kGAMECLASS.dungeonLoc >= 39 && kGAMECLASS.dungeonLoc <= 44) buildMapDisplay(MAP_ANZUPALACE_F1);
				if (kGAMECLASS.dungeonLoc >= 45 && kGAMECLASS.dungeonLoc <= 48) buildMapDisplay(MAP_ANZUPALACE_F2);
				if (kGAMECLASS.dungeonLoc >= 49 && kGAMECLASS.dungeonLoc <= 51) buildMapDisplay(MAP_ANZUPALACE_F3);
				if (kGAMECLASS.dungeonLoc == 52) buildMapDisplay(MAP_ANZUPALACE_F4);
				if (kGAMECLASS.dungeonLoc == 53 || kGAMECLASS.dungeonLoc == 54) buildMapDisplay(MAP_ANZUPALACE_B1);
			}
		}
		
		public function chooseRoomToDisplayD3():void {
			//Basilisk Cave
			if (getGame().dungeons._currentRoom == "entrance") {
				rawOutputText("Basilisk Cave");
				rawOutputText("\n     [ ]—   ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]    ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]—[ ]");
				rawOutputText("\n      |     ");
				rawOutputText("\n—[P]—[ ]    ");
			}
			else if (getGame().dungeons._currentRoom == "tunnel1") {
				rawOutputText("Basilisk Cave");
				rawOutputText("\n     [ ]—   ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]    ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]—[ ]");
				rawOutputText("\n      |     ");
				rawOutputText("\n—[ ]—[P]    ");
			}
			else if (getGame().dungeons._currentRoom == "antechamber") {
				rawOutputText("Basilisk Cave");
				rawOutputText("\n     [ ]—   ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]    ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [P]—[ ]");
				rawOutputText("\n      |     ");
				rawOutputText("\n—[ ]—[ ]    ");
			}
			else if (getGame().dungeons._currentRoom == "roomofmirrors") {
				rawOutputText("Basilisk Cave");
				rawOutputText("\n     [ ]—   ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]    ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]—[P]");
				rawOutputText("\n      |     ");
				rawOutputText("\n—[ ]—[ ]    ");
			}
			else if (getGame().dungeons._currentRoom == "magpiehalls" || getGame().dungeons._currentRoom == "magpiehalln") {
				rawOutputText("Basilisk Cave");
				rawOutputText("\n     [ ]—   ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [P]    ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]—[ ]");
				rawOutputText("\n      |     ");
				rawOutputText("\n—[ ]—[ ]    ");
			}
			else if (getGame().dungeons._currentRoom == "tunnel2") {
				rawOutputText("Basilisk Cave");
				rawOutputText("\n     [P]—   ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]    ");
				rawOutputText("\n      |     ");
				rawOutputText("\n     [ ]—[ ]");
				rawOutputText("\n      |     ");
				rawOutputText("\n—[ ]—[ ]    ");
			}
			//Lethice's Keep
			if (getGame().dungeons._currentRoom == "edgeofkeep") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[P]     ");
			}
			else if (getGame().dungeons._currentRoom == "northentry") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [P] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}			
			else if (getGame().dungeons._currentRoom == "southcourtyard") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[P]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}			
			else if (getGame().dungeons._currentRoom == "southwestcourtyard") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[P]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "southwestwalk") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [P]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "westwalk") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [P]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "northwestwalk") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[P]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "northwestcourtyard") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [P]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "northcourtyard") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[P]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "northeastcourtyard") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[P] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "northeastwalk") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [P]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "eastwalk") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[P] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "southeastwalk") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [P] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "southeastcourtyard") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[P]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "courtyardsquare") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[P]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "greatlift") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [ ]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [P] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
			else if (getGame().dungeons._currentRoom == "throneroom") {
				rawOutputText("Lethice's Keep");
				rawOutputText("\n     [P]     ");
				findLockedDoorLethiceThrone();
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]     [ ]—");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]—[ ]—[ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n [ ]     [ ] ");
				rawOutputText("\n  |       |  ");
				rawOutputText("\n—[ ]—[ ]—[ ]—");
				rawOutputText("\n      |   |  ");
				rawOutputText("\n     [ ] [ ] ");
				rawOutputText("\n      |      ");
				rawOutputText("\n    —[ ]     ");
			}
		}
		
		public function buildMapDisplay(map:Array):void {
			outputText(map[0] + "\n\n");
			for (var i:int = 1; i < map.length; i++) {
				for (var j:int = 0; j < map[i].length; j++) {
					//Negative numbers are special.
					if (map[i][j] < 0) {
						switch(map[i][j]) {
							case -1:
								rawOutputText("   ");
								break;
							case -2:
								rawOutputText(" ");
								break;
							case -3:
								rawOutputText(" | ");
								break;
							case -4:
								rawOutputText("—");
								break;
							case -5:
								rawOutputText("L");
								break;
						}
					}
					else {
						if (kGAMECLASS.dungeonLoc == map[i][j])
							rawOutputText("[<u>P</u>]");
						else
							rawOutputText("[<u> </u>]");
					}
				}
				rawOutputText("\n");
			}
		}
		
		public function displayMap():void {
			clearOutput();
			outputText("<b><font face=\"_typewriter\">");
			if (inRoomedDungeon) chooseRoomToDisplayD3();
			else chooseRoomToDisplay();
			outputText("</font></b>");
			outputText("\n\n<b><u>Legend</u></b>");
			outputText("\n<font face=\"_typewriter\"><b>P</b></font> — Player Location");
			outputText("\n<font face=\"_typewriter\"><b>L</b></font> — Locked Door");
			outputText("\n<font face=\"_typewriter\"><b>S</b></font> — Stairs");
			menu();
			addButton(0, "Close Map", playerMenu);
		}
		
	}

}