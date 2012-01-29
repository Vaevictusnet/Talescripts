-- Edit these first 2 to adjust how much is planted in a pass
-- May need to adjust walk_time in flax_common.inc if you move too slowly to keep up
-- grids tested: 2x2, 3x3, 5x5, 6x6 (probably need 3+ dex and 600ms walk time)
grid_w = 5;
grid_h = 5;

loadfile("luaScripts/flax_common.inc")();
loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

-- Just testing spiral algorithm, ignore this...
function spiraltest()
	-- for spiral
	local dxi=1;
	local dt_max=grid_w;
	local dt=grid_w;
	local dx={1, 0, -1, 0};
	local dy={0, -1, 0, 1};
	local num_at_this_length = 3;
	
	-- Plant and pin
	for y=1, grid_h do
		for x=1, grid_w do
			lsPrintln('doing ' .. x .. ',' .. y);

			-- move to next position
			if not ((x == grid_w) and (y == grid_h)) then
				lsPrintln('walking dx=' .. dx[dxi] .. ' dy=' .. dy[dxi]);
				dt = dt - 1;
				if dt == 1 then
					dxi = dxi + 1;
					num_at_this_length = num_at_this_length - 1;
					if num_at_this_length == 0 then
						dt_max = dt_max - 1;
						num_at_this_length = 2;
					end
					if dxi == 5 then
						dxi = 1;
					end
					dt = dt_max;
				end
			else
				lsPrintln('skipping walking, on last leg');
			end
		end
	end
end

function doit()
	-- num_loops = promptNumber("How many " .. grid_w .. "x" .. grid_h .. " passes ?", 5);
	promptFlaxNumbers(1);

	askForWindow("Script by Jimbly with tweaks from Cegaiel and KasumiGhia\n\nMake sure the plant flax window is pinned and you are in F8F8 cam zoomed in.  You may need to F12 at low resolutions or hide your chat window (if it starts planting and fails to move downward, it probably clicked on your chat window).  Will plant grid NE of current location.\n \n'Plant all crops where you stand' must be ON.  'Right click pins/unpins a menu' must be ON.  'Right click opens a Menu as Pinned' must be OFF.  Enable Hotkeys on flax must be OFF.");
	
	initGlobals();
	
	local went_to_seeds = 0; -- Don't loop if we lost one, it'll mess us up!
	srReadScreen();
	local xyPlantFlax = srFindImage(imgFlax1);
	if not xyPlantFlax then
		error 'Could not find plant window';
	end
	xyPlantFlax[0] = xyPlantFlax[0] + 5;
	local xyCenter = getCenterPos();
	local xyFlaxMenu = {};
	xyFlaxMenu[0] = xyCenter[0] - 43*pixel_scale;
	xyFlaxMenu[1] = xyCenter[1] + 0;
	
	for loop_count=1, num_loops do
		
		-- for spiral
		local dxi=1;
		local dt_max=grid_w;
		local dt=grid_w;
		local dx={1, 0, -1, 0};
		local dy={0, -1, 0, 1};
		local num_at_this_length = 3;
		local x_pos = 0;
		local y_pos = 0;
		
		-- Plant and pin
		for y=1, grid_h do
			for x=1, grid_w do
				lsPrintln('doing ' .. x .. ',' .. y .. ' of ' .. grid_w .. ',' .. grid_h);
	
				statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Planting " .. x .. ", " .. y);
	
				-- Plant
				lsPrintln('planting ' .. xyPlantFlax[0] .. ',' .. xyPlantFlax[1]);
				setWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1]);
				srClickMouseNoMove(xyPlantFlax[0], xyPlantFlax[1], 0);
				srSetMousePos(xyFlaxMenu[0], xyFlaxMenu[1]);
				waitForChange();
				-- lsSleep(delay_time);
				
				-- Bring up menu
				lsPrintln('menu ' .. xyFlaxMenu[0] .. ',' .. xyFlaxMenu[1]);
				setWaitSpot(xyFlaxMenu[0]+5, xyFlaxMenu[1]);
				srClickMouse(xyFlaxMenu[0], xyFlaxMenu[1], 0);
				waitForChange();
				-- lsSleep(delay_time);
				
				-- Check for window size
				checkWindowSize(xyFlaxMenu[0], xyFlaxMenu[1]);
				
				-- Pin
				lsPrintln('pin ' .. (xyFlaxMenu[0]+5) .. ',' .. xyFlaxMenu[1]);
				srClickMouseNoMove(xyFlaxMenu[0]+5, xyFlaxMenu[1]+0, 1);
				-- lsSleep(delay_time);
				
				-- Move window
				local pp = pinnedPos(x, y);
				lsPrintln('move ' .. (xyFlaxMenu[0]+5) .. ',' .. xyFlaxMenu[1] .. ' to ' .. pp[0] .. ',' .. pp[1]);
				drag(xyFlaxMenu[0] + 5, xyFlaxMenu[1],
					pp[0], pp[1], 0);
				-- lsSleep(delay_time);

				-- move to next position
				if not ((x == grid_w) and (y == grid_h)) then
					lsPrintln('walking dx=' .. dx[dxi] .. ' dy=' .. dy[dxi]);
					x_pos = x_pos + dx[dxi];
					y_pos = y_pos + dy[dxi];
					srClickMouseNoMove(xyCenter[0] + walk_px_x*dx[dxi], xyCenter[1] + walk_px_y*dy[dxi], 0);
					lsSleep(walk_time);
					dt = dt - 1;
					if dt == 1 then
						dxi = dxi + 1;
						num_at_this_length = num_at_this_length - 1;
						if num_at_this_length == 0 then
							dt_max = dt_max - 1;
							num_at_this_length = 2;
						end
						if dxi == 5 then
							dxi = 1;
						end
						dt = dt_max;
					end
				else
					lsPrintln('skipping walking, on last leg');
				end
			end
			checkBreak();
		end

		statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Refocusing windows...");
		
		-- Bring windows to front
		refocusWindows();
		
		local did_harvest=false;
		local water_step = 0;
		while not did_harvest do
			-- Monitor for Weed This/etc
			water_step = water_step + 1;
			for y=1, grid_h do
				for x=1, grid_w do 
					statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Weeding/Harvest step " .. water_step);
					local pp = pinnedPos(x, y);
					local rp = refreshPosDown(x, y);
					local seeds_retry=3;
					while 1 do
						srClickMouseNoMove(rp[0], rp[1], 0);
						lsSleep(screen_refresh_time);
						srReadScreen();
						local weed = srFindImageInRange(imgWeed, pp[0], pp[1] - 50, 120, 100);
						if weed then
							srClickMouseNoMove(weed[0] + 5, weed[1], 0);
							break;
						end
						local weed = srFindImageInRange(imgWeedAndWater, pp[0], pp[1] - 50, 120, 100);
						if weed then
							srClickMouseNoMove(weed[0] + 5, weed[1], 0);
							break;
						end
						local harvest = srFindImageInRange(imgHarvest, pp[0], pp[1] - 50, 110, 100);
						if harvest then
							srClickMouseNoMove(harvest[0] + 5, harvest[1], 0);
							srClickMouseNoMove(pp[0], pp[1], 1); -- unpin
							did_harvest = true;
							break;
						end
						local seeds = srFindImageInRange(imgSeeds, pp[0], pp[1] - 50, 120, 100);
						if seeds then
							seeds_retry = seeds_retry - 1;
							if (seeds_retry == 0) then
								if nil then -- Don't do this, it causes us to walk out of range of the rest!
									lsPrintln('Went to seed, grabbing the seeds and ignoring.');
									srClickMouseNoMove(seeds[0] + 5, seeds[1], 0);
								end
								srSetMousePos(pp[0]+5, pp[1]+37);
								lsSleep(100);
								srClickMouseNoMove(pp[0]+5, pp[1]+37, 0); -- Utility
								lsSleep(100);
								srReadScreen();
								local rip = srFindImage("FlaxRipOut.png");
								if rip then
									srClickMouseNoMove(rip[0] + 5, rip[1] + 2, 0); -- Rip out
								else
									error 'Flax went to seed, but failed to find rip out option';
								end
								lsSleep(100);
							
								srClickMouseNoMove(pp[0]-3, pp[1], 1); -- unpin
								went_to_seeds = 1;
								did_harvest = true;
								break;
							end
						end
						checkBreak();
					end
				end
			end
				
			-- Bring windows to front
			if not did_harvest then
				statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Refocusing windows...");
				
				refocusWindows();
			end
		end
		


	--Click the plant window, to refresh seeds, in case you used your last seed. Prevents fails (can't find onion seed) on 2nd or higher passes.
	srClickMouseNoMove(xyPlantFlax[0], xyPlantFlax[1]+15, 0); 



		lsSleep(2500); -- Wait for last flax bed to disappear before accidentally clicking on it!
		statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Walking...");







		if went_to_seeds == 0 then	
			-- Walk back
			for x=1, x_pos do
				srClickMouseNoMove(xyCenter[0] + walk_px_x*-1, xyCenter[1], 0);
				lsSleep(walk_time);
			end
			for x=1, -y_pos do
				srClickMouseNoMove(xyCenter[0], xyCenter[1] + walk_px_y, 0);
				lsSleep(walk_time);
			end
		end
		
		if went_to_seeds and not loop_count == num_loops then
			error 'Some of the plants went to seeds, stopping loop'
		end
	end
	
	lsPlaySound("Complete.wav");
end
