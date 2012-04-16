--
-- To run:
--  Copy a recipe from the output of the Thistle Mode
--  Update expected_gardens equal to the number you have opened and pinned
--    Gardens must all have their buttons visible, can overlap as long as the
--    row with "asc" is visible regardlesss of which window was clicked last
--  Update "last sun" to be what it is now (0 if night,
--    99 if daylight and open lid, 33 if daylight and closed lid)
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

per_click_delay = 0;

local expected_gardens = 33;
local last_sun = 0;

instructions = {
0,0,0,1,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,1,0,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,2,0,
0,0,0,0,0,
0,0,2,0,0,
0,0,0,0,0,
0,0,0,3,0,
0,0,0,0,0,
0,0,1,0,0,
0,0,1,0,0,
0,0,1,0,0,
0,0,0,0,0,
0,0,0,3,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,2,0,0,
0,0,1,0,0,
0,0,0,0,0,
0,0,1,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,1,0,0,
0,0,1,1,0,
0,0,0,0,0,
0,0,1,1,0,
0,0,0,0,0,
0,0,1,1,0,
0,0,0,0,0,
0,0,3,3,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,1,0,0,
0,0,1,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,0,0,
};


local window_locs = {};

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

function waitForChange()
	local c=0;
	while srReadPixel(setWaitSpot_x, setWaitSpot_y) == setWaitSpot_px do
		lsSleep(1);
		c = c+1;
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
	end
	-- lsPrintln('Waited ' .. c .. 'ms for pixel to change.');
end



function clickAll(image_name, up)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find specified buttons...");
		lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...");
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " clicks).");
		lsSleep(100);
	end
end



function clickAllComplex(image_names, message)
	if not message then
		message = "";
	end
	-- Find buttons and click them!
	srReadScreen();
	local dpos = {};
	for i=1, #image_names do
		local pos = srFindImageInRange(image_names[i],
			window_locs[#window_locs][0], window_locs[#window_locs][1],
			410, 312);
		if not pos then
			error ('Failed to find ' .. image_names[i]);
		end
		dpos[i] = {};
		dpos[i][0] = pos[0] - window_locs[#window_locs][0];
		dpos[i][1] = pos[1] - window_locs[#window_locs][1];
	end
	statusScreen(message .. " Clicking " .. #window_locs .. " button(s)...");
	local first = 1;
	for i=#window_locs, 1, -1 do
		if not first then
			-- focus
			setWaitSpot(window_locs[i+1][0], window_locs[i+1][1]);
			srClickMouseNoMove(window_locs[i][0], window_locs[i][1]);
			waitForChange();
		end
		-- click all buttons
		for j=1, #image_names do
			srClickMouseNoMove(window_locs[i][0] + dpos[j][0] + 5, window_locs[i][1] + dpos[j][1] + 5);
		end
		first = nil;
	end
	lsSleep(100);
	statusScreen(message .. " Refocusing...");
	-- refocus
	for i=2, #window_locs do
		setWaitSpot(window_locs[i][0], window_locs[i][1]);
		srClickMouseNoMove(window_locs[i][0], window_locs[i][1] + 310);
		waitForChange();
	end
	lsSleep(100);
end

button_names = {"ThistleNit.png", "ThistlePot.png", "ThistleH2O.png", "ThistleOxy.png", "ThistleSun.png"};

local z = 2;

-- Initialize last_mon
local mon_w = 10;
local mon_h = 152;
local last_mon = {};
for x=1, mon_w do
	last_mon[x] = {};
	for y=1, mon_h do
		last_mon[x][y] = 0;
	end
end

function waitForMonChange(message)
	if not first_nit then
		first_nit = srFindImage("ThistleNit.png");
	end
	if not first_nit then
		error "Could not find first Nit";
	end
	mon_x = first_nit[0] - 25;
	mon_y = first_nit[1] + 13;
		
	local different = nil;
	local skip_next = nil;
	local first_loop = 1;
	while not different do
		srReadScreen();
		for x=1, mon_w do
			for y=1, mon_h do
				newvalue = srReadPixelFromBuffer(mon_x + x, mon_y + y);
				if not (newvalue == last_mon[x][y]) then
					different = 1;
				end
				last_mon[x][y] = newvalue;
			end
		end
		if not different then
			first_loop = nil;
		end
		
		if different then
			-- Make sure the screen was done refreshing and update again
			lsSleep(60);
			srReadScreen();
			for x=1, mon_w do
				for y=1, mon_h do
					last_mon[x][y] = srReadPixelFromBuffer(mon_x + x, mon_y + y);
				end
			end
		end
		
		if (different and skip_next) then
			skip_next = nil;
			different = nil;
		end 
		
		lsPrintWrapped(10, 5, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, message);
		lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, "Waiting for change...");
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end

		if lsButtonText(40, lsScreenY - 60, z, 200, 0xFFFFFFff, "Force tick") then
			different = 1;
		end

		if lsButtonText(40, lsScreenY - 90, z, 200, 0xFFFFFFff, "Skip tick") then
			skip_next = 1;
		end

		if lsButtonText(40, lsScreenY - 120, z, 200, 0xFFFFFFff, "Finish up") then
			finish_up = 1;
		end
		
		-- display mon pixels
		for x=1, mon_w do
			for y=1, mon_h do
				local size = 2;
				lsDisplaySystemSprite(1, 10+x*size, 90+y*size, 0, size, size, last_mon[x][y]);
			end
		end
		lsDoFrame();
		lsSleep(100);
	end
	statusScreen("Changed, waiting a moment for other beds to catch up...");
	if not first_loop then -- Don't wait, we might be behind already!
		lsSleep(1500); -- Wait a moment after image changes before doing the next tick
	end
end

function test()

	local loop=0;
	while 1 do
		waitForMonChange("tick " .. loop);
		
		statusScreen('Changed!');
		lsSleep(1000);
		loop = loop + 1;
	end

	error 'done';
end

function refillWater()
	statusScreen("Refilling water...");
	lsSleep(200);
	srReadScreen();
	FindWater = srFindImage("iconWaterJugSmall.png", 1);

	if FindWater then
	srClickMouseNoMove(FindWater[0]+3,FindWater[1]-5);
	lsSleep(1500);


		srReadScreen();
		FindMaxButton = srFindImage("Maxbutton.png", 1);


		if FindMaxButton then
		srClickMouseNoMove(FindMaxButton[0]+3,FindMaxButton[1]+3);
		end

	end
end

function doit()
	num_loops = promptNumber("How many passes ?", 1);
	askForWindow("Pin any number of thistle gardens, edit thistle_new with recipe.");
	
	if not ( #instructions == 41*5) then
		error 'Invalid instruction length';
	end

	srReadScreen();	
	window_locs = findAllImages("ThisIs.png");
	if not (#window_locs == expected_gardens) then
		error ("Did not find expected number of thistle gardens (found " .. #window_locs .. " expected " .. expected_gardens .. ")");
	end
	
--	wl2 = {};
--	wl2[1] = window_locs[31];
--	wl2[2] = window_locs[32];
--	window_locs = wl2;
--	if not (#window_locs == 2) then
--		error 'fail';
--	end
	
	
	-- test();
	
	for loops=1, num_loops do
		
		-- clickAll("ThisIs.png", 1);
		-- lsSleep(100);
		
		srReadScreen();
		
		-- clickAllComplex({"Harvest.png"}, 1);
		-- error 'done';


		-- clickAllComplex({"ThistleAbort.png"}, 1);
		-- error 'done';


		-- statusScreen("(" .. loops .. "/" .. num_loops .. ") Doing initial 2s wait...");
		-- lsSleep(2000);
		--waitForMonChange("Getting initial image...");
		for i=0, 39 do
			local to_click = {};
			if (i == 0) then
				to_click[1] = "ThistlePlantACrop.png";
			end
			for j=0, 3 do
				for k=1, instructions[i*5 + j + 1] do
					to_click[#to_click+1] = button_names[j+1];
				end
			end
			if not (instructions[i*5 + 5] == last_sun) then
				last_sun = instructions[i*5 + 5];
				to_click[#to_click+1] = button_names[5];
			end
			if #to_click > 0 then
				clickAllComplex(to_click, ("(" .. loops .. "/" .. num_loops .. ") " .. i .. ":"));
			end
			waitForMonChange("(" .. loops .. "/" .. num_loops .. ") Tick " .. i .. " done.");
			if (i == 0) then -- first one immediately finds a change
				waitForMonChange("(" .. loops .. "/" .. num_loops .. ") Tick " .. i .. " done.");
			end
			if finish_up then
				num_loops = loops;
			end			
		end

		lsSleep(3000);
		clickAllComplex({"Harvest.png"});
		lsSleep(500);
		
		refillWater();
		
		if finish_up then
			break;
		end
	end
	lsPlaySound("Complete.wav");
end
