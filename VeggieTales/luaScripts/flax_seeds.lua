
-- This script has not yet been updated to use the new UI utilties
-- See flax.lua instead

-- Edit these first 3 to adjust how much is planted in a pass and how many passes
-- May need to adjust walk_time in flax_common.inc if you move too slowly to keep up
-- grids tested up to 7x7, can probably do more
grid_w = 5;
grid_h = 5;

harvest_seeds_time = 1300;
rip_out_time = 100;
rip_out_when_done = 1;

loadfile("luaScripts/flax_common.inc")();
loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

-- Harvest seeds
function doit()
	--num_loops = promptNumber("How many " .. grid_w .. "x" .. grid_h .. " passes ?", 5);
	promptFlaxNumbers(false);
	askForWindow("Make sure the plant flax window is pinned and you are in F8F8 cam zoomed in.  You may need to F12 at low resolutions or hide your chat window (if it starts planting and fails to move downward, it probably clicked on your chat window).  Will plant grid NE of current location.\n \n'Plant all crops where you stand' must be ON.  'Right click pins/unpins a menu' must be ON.  'Right click opens Menu as Pinned' must be OFF.");
	initGlobals();
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
	
	for outer_loop=1, num_loops do
	
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
				lsPrintln('doing ' .. x .. ',' .. y);
				
				statusScreen("Planting...");

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
				
				-- Pin
				lsPrintln('pin ' .. (xyFlaxMenu[0]+5) .. ',' .. xyFlaxMenu[1]);
				srClickMouseNoMove(xyFlaxMenu[0]+5, xyFlaxMenu[1]+0, 1);
				-- lsSleep(delay_time);
				
				-- Check for window size
				checkWindowSize(xyFlaxMenu[0], xyFlaxMenu[1]);
				
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
			if (lsShiftHeld() and lsControlHeld()) then
				error 'broke out of loop from Shift+Ctrl';
			end
		end
		
		for loop_count=1, seeds_per_pass do
			
			loop_label = "(" .. outer_loop .. "/" .. num_loops .. ", " .. loop_count .. "/" .. seeds_per_pass .. ")";
			statusScreen(loop_label .. " Refocusing");

			refocusWindows();
		
			-- And harvest
			for y=1, grid_h do
				for x=1, grid_w do 

					local pp = pinnedPos(x, y);
					local rp = refreshPosDown(x, y);
					while 1 do
						statusScreen(loop_label .. " Harvesting " .. x .. ", " .. y);
						srClickMouseNoMove(rp[0], rp[1], 0);
						lsSleep(screen_refresh_time);
						srReadScreen();
						local seeds = srFindImageInRange(imgSeeds, pp[0], pp[1] - 50, 160, 100);
						if seeds then
							srClickMouseNoMove(seeds[0] + 5, seeds[1], 0);
							lsSleep(harvest_seeds_time);
							break;
						end
						checkBreak();
					end
				end
			end
		end

		statusScreen("Refocusing");
		-- Bring windows to front
		refocusWindows();
		
		-- and clean up!
		for y=1, grid_h do
			for x=1, grid_w do 
				local rp = refreshPosDown(x, y);
				if (rip_out_when_done) then
					local pp = pinnedPos(x, y);
					local rp = refreshPosDown(x, y);
					while 1 do
						statusScreen(loop_label .. " Ripping out " .. x .. ", " .. y);
						-- srClickMouseNoMove(rp[0], rp[1], 0);
						lsSleep(screen_refresh_time);
						srReadScreen();
						local util_menu = srFindImageInRange("Utility.png", pp[0], pp[1] - 50, 160, 100);
						if util_menu then
							srClickMouseNoMove(util_menu[0] + 5, util_menu[1], 0);
							while 1 do
								lsSleep(screen_refresh_time);
								srReadScreen();
								local rip_out = srFindImage("RipOut.png");
								if rip_out then
									srClickMouseNoMove(rip_out[0] + 5, rip_out[1], 0);
									lsSleep(refocus_click_time);
									srClickMouseNoMove(rp[0], rp[1], 1); -- unpin
									lsSleep(rip_out_time);
									break;
								end
								checkBreak();
							end
							break;
						end
						checkBreak();
					end
				else
					srClickMouseNoMove(rp[0], rp[1], 1); -- unpin
					lsSleep(refocus_click_time);
				end
				checkBreak();
			end




		end
		


	--Click the plant window, to refresh seeds, in case you used your last seed. Prevents fails (can't find onion seed) on 2nd or higher passes.
	srClickMouseNoMove(xyPlantFlax[0], xyPlantFlax[1]+15, 0); 


		if rip_out_when_done then
			-- wait for beds to disappear
			lsSleep(1500);
			
	



		statusScreen(loop_label .. " Walking back");
			-- move back!
			srClickMouseNoMove(xyCenter[0] + walk_px_x*0, xyCenter[1] + walk_px_y*1, 0);
			lsSleep(walk_time);
			if (grid_w > 3) then
				srClickMouseNoMove(xyCenter[0] + walk_px_x*-1, xyCenter[1] + walk_px_y*0, 0);
				lsSleep(walk_time);
				srClickMouseNoMove(xyCenter[0] + walk_px_x*0, xyCenter[1] + walk_px_y*1, 0);
				lsSleep(walk_time);
			end
		end
	end

	lsPlaySound("Complete.wav");
end
