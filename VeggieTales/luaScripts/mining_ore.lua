-- mining_ore.lua v1.4 -- by Cegaiel
-- Credits to Tallow for his Simon macro, which was used as a template to build on.
-- 
-- Brute force method, you manually click/set every stones' location and it will work every possible 3 node/stone combinations.
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Ore Mining v1.4 (by Cegaiel) --
  Brute Force method. Will try every possible 3 node/stone combination.
  Make sure chat is MINIMIZED! Press Shift over ATITD window.
]]);

timesworked = 0;
dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;
dropdown_ore_values = {"Aluminum (9)", "Antimony (14)", "Copper (8)", "Gold (12)", "Iron (7)", "Lead (9)", "Lithium (10)", "Magnesium (9)", "Platinum (12)", "Silver (10)", "Strontium (10)", "Tin (9)", "Tungsten (12)", "Zinc (10)"};
dropdown_ore_cur_value = 1;

function doit()
  askForWindow(askText);
  promptDelays();
  getMineLoc();
  getPoints();
  clickSequence();
end

function getMineLoc()
  mineList = {};
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end

  local is_done = false;
  mx = 0;
  my = 0;
  z = 0;
  while not is_done do
    mx, my = srMousePos();
    local is_shifted = lsShiftHeld();

    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end

    if is_shifted and not was_shifted then
      mineList[#mineList + 1] = {mx, my};
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff,
	    "Set Mine Location");
    local y = 60;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Lock ATITD screen (Alt+L) .");
    y = y+20;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Suggest F5 view, zoomed almost all the way out.");
    y = y+40;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Hover and " .. key .. " over the MINE.");
	y = y + 70;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "For Maximum Performance (least lag) Uncheck:");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Options, Interface, Other: 'Use Flyaway Messages'");
    local start = math.max(1, #mineList - 20);
    local index = 0;
    for i=start,#mineList do
	mineX = mineList[i][1];
	mineY = mineList[i][2];
    end

  if #mineList >= 1 then
      is_done = 1;
  end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
  lsDoFrame();
  lsSleep(50);
  end
end

function fetchTotalCombos()
  TotalCombos = 0;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
			TotalCombos = TotalCombos + 1;
			end
		end
	end
end

function getPoints()
  clickList = {};
  if (dropdown_ore_cur_value == 1) then
  ore = "Aluminum";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 2) then
  ore = "Antimony";
  stonecount = 14;
  elseif (dropdown_ore_cur_value == 3) then
  ore = "Copper";
  stonecount = 8;
  elseif (dropdown_ore_cur_value == 4) then
  ore = "Gold";
  stonecount = 12;
  elseif (dropdown_ore_cur_value == 5) then
  ore = "Iron";
  stonecount = 7;
  elseif (dropdown_ore_cur_value == 6) then
  ore = "Lead";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 7) then
  ore = "Lithium";
  stonecount = 10;
  elseif (dropdown_ore_cur_value == 8) then
  ore = "Magnesium";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 9) then
  ore = "Platinum";
  stonecount = 12;
  elseif (dropdown_ore_cur_value == 10) then
  ore = "Silver";
  stonecount = 10;
  elseif (dropdown_ore_cur_value == 11) then
  ore = "Strontium";
  stonecount = 10;
  elseif (dropdown_ore_cur_value == 12) then
  ore = "Tin";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 13) then
  ore = "Tungsten";
  stonecount = 12;
  end

  local nodeleft = stonecount;
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  end

  local is_done = false;
  local nx = 0;
  local ny = 0;
  local z = 0;
  while not is_done do
    nx, ny = srMousePos();
    local is_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  is_shifted = lsShiftHeld();
  elseif (dropdown_cur_value == 2) then
  is_shifted = lsControlHeld();
  elseif (dropdown_cur_value == 3) then
  is_shifted = lsAltHeld();
  elseif (dropdown_cur_value == 4) then
  is_shifted = lsMouseIsDown(2);
  end

    if is_shifted and not was_shifted then
      nodeError = 0;
      clickList[#clickList + 1] = {nx, ny};
      nodeleft = nodeleft - 1;
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff,
	    "Set Node Locations (" .. #clickList .. "/" .. stonecount .. ")");
    local y = 60;

    if nodeError == 1 then
    clickList = {};
    lsPrint(5, y, z, 0.7, 0.7, 0xff4040ff, "Not enough nodes! Minimum is 7.");
    y = y + 30
    end

    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Hover and " .. key .. " over each node.");
    y = y + 15;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Make sure chat is MINIMIZED!");
    y = y + 30;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Mine Type:  " .. ore);
    y = y + 30;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Mine Worked:  " .. timesworked .. " times");
    y = y + 40;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Select " .. nodeleft .. " more nodes to activate auto-mine!");
    y = y + 40;
    local start = math.max(1, #clickList - 20);
    local index = 0;
    for i=start,#clickList do
      local xOff = (index % 3) * 100;
      local yOff = (index - index%3)/2 * 15;
      lsPrint(20 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              i .. ": (" .. clickList[i][1] .. ", " .. clickList[i][2] .. ")");
      index = index + 1;
    end


  -- Old way (v1.0-1.1), now it doesn't need you to click the button to continue.
  --Now it automatically detects if you've clicked the correct amount of nodes.
  --if #clickList >= 7 then
    --if lsButtonText(10, lsScreenY - 30, z, 100, 0x80ff80ff, "Work") then
      --is_done = 1;
   --end

    if #clickList >= stonecount then
      is_done = 1;
    end

    if #clickList > 0 then
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xff8080ff, "Reset") then
        reset();
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
  lsDoFrame();
  lsSleep(50);
  end
end


function fetchTotalCombos()
  TotalCombos = 0;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
			TotalCombos = TotalCombos + 1;
			end
		end
	end
end


function clickSequence()
  fetchTotalCombos();
  sleepWithStatus(100, "Working...");
  local worked = 1;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
	-- 1st Node
	checkBreak();
      checkAbort();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(clickDelay);
	srKeyEvent('A'); 

		-- 2nd Node
		checkBreak();
	       checkAbort();
		srSetMousePos(clickList[j][1], clickList[j][2]);
		lsSleep(clickDelay);
		srKeyEvent('A'); 

			-- 3rd Node
			checkBreak();
			checkAbort();
			srSetMousePos(clickList[k][1], clickList[k][2]);
			lsSleep(clickDelay);
			srKeyEvent('S'); 
		       local y = 10;
		       lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		       y = y +50
			lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k);
			y = y + 40;
			lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Node Delay: " .. clickDelay .. " ms");
			y = y + 16;
			lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Popup Delay: " .. popDelay .. " ms");
			y = y + 40;
			lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Hold Shift to Abort and Return to Menu!");
			y = y + 40;
			lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Don't touch mouse until finished!");
			lsDoFrame();
			worked = worked + 1
			lsSleep(popDelay);
			findClosePopUp();

	end

		end

			end

  --Send 'W' key over Mine to Work it (Get new nodes)
  srSetMousePos(mineX, mineY);
  lsSleep(clickDelay);
  srKeyEvent('W'); 
  sleepWithStatus(1000, "Working mine (Fetching new nodes)");
  timesworked = timesworked + 1;
  reset();
 end

function reset()
  getPoints();
  clickSequence();
end

function checkAbort()
  if lsShiftHeld() then
    sleepWithStatus(750, "Aborting ..."); 
    reset();
  end
end

function findClosePopUp()
  lsSleep(popDelay);
    while 1 do
      checkBreak();
      srReadScreen();
      OK = srFindImage("OK.png");
	  if OK then  
	    srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
	    lsSleep(clickDelay);
	  else
	    break;
	  end
    end
end

function promptDelays()
  local is_done = false;
  local count = 1;
  while not is_done do
	checkBreak();
	local y = 10;
	lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff,
            "Key or Mouse to Select Nodes:");
	y = y + 35;
	lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
	dropdown_cur_value = lsDropdown("ArrangerDropDown", 5, y, 0, 200, dropdown_cur_value, dropdown_values);
	lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
	y = y + 20;
	lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "How many Nodes?");
	y = y + 50;
	lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
	dropdown_ore_cur_value = lsDropdown("ArrangerDropDown2", 5, y, 0, 200, dropdown_ore_cur_value, dropdown_ore_values);
	lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
	y = y + 10;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Node Delay (ms):");
      is_done, clickDelay = lsEditBox("delay", 170, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, 150);
      clickDelay = tonumber(clickDelay);
      if not clickDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        clickDelay = 150;
      end
	y = y + 40;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Popup Delay (ms):");
      is_done, popDelay = lsEditBox("delay2", 170, y, 0, 50, 30, 1.0, 1.0,
                                      0x000000ff, 500);
      popDelay = tonumber(popDelay);
      if not popDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        popDelay = 500;
      end
	y = y + 40;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Node Delay: Delay between selecting each node.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Decrease value to run faster (try increments of 25)");
	y = y + 22;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Popup Delay: Finalize, wait to see if popup appears.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Raise increments of 100 if you are laggy.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "ie Clicking next nodes before previous ones break.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Popup Delay 1000 or 1500 might work better.");

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end
  lsDoFrame();
  lsSleep(50);
  end
  return count;
end