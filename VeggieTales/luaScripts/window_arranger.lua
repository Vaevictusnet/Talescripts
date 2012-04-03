--
--
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

local window_w = 410;
local window_h = 312;
local dropdown_cur_value = 1;
local choice = "Brick Racks";

local scale = 0.6;
local z = 0.0; -- Only matters if there is overlapping elements on screen


x0 = 10;
y0 = 50;
y0_2 = 14;
y0_2_threshold = window_w * 2; -- if x > this, use y0_2 instead, set large to ignore



dropdown_values = {"Brick Rack", "Carpentry Shop", "Kettle", "Kiln", "Paper Press", "Pottery Wheel", "Rock Saw", "Thistle Custom", "Thistle New"};





function GetLayout()


-- Add new sections here

if (dropdown_cur_value == 1) then
choice = "Brick Racks";
	-- brick racks
	dx = 170;
	dy = 115;
	little_dx = 0;
	num_high = 7;


elseif (dropdown_cur_value == 2) then
choice = "Carpentry Shop";
	-- carpentry shop
	dx = 280;
	dy = 205;
	little_dx = 0;
	num_high = 4;



elseif (dropdown_cur_value == 3) then
choice = "Kettles";
	-- kettles
	dx = 165;
	dy = 275;
	little_dx = 0;
	num_high = 3;


elseif (dropdown_cur_value == 4) then
choice = "Kilns";
	-- Kilns
	dx = 285;
	dy = 180;
	little_dx = 0;
	num_high = 4;


elseif (dropdown_cur_value == 5) then
choice = "Paper Press";
	-- paper presses
	dx = 388;
	dy = 100;
	little_dx = 0;
	num_high = 8;

elseif (dropdown_cur_value == 6) then
choice = "Pottery Wheel";
	-- pottery wheels
	dx = 190;
	dy = 150;
	little_dx = 0;
	num_high = 7;



elseif (dropdown_cur_value == 7) then
choice = "Rock Saw";
	-- rock saws
	dx = 137;
	dy = 125;
	little_dx = 0;
	num_high = 8;
	window_w = 340;


elseif (dropdown_cur_value == 8) then
choice = "Thistle Custom";
	-- thistle_custom
	dx = 413; -- when wrapping
	dy = 190;
	little_dx = 0; -- for every window
	num_high = 5;


elseif (dropdown_cur_value == 9) then
choice = "Thistle New";
	-- thistle_new
	dx = 413; -- when wrapping
	dy = 24;
	little_dx = 8; -- for every window
	num_high = 33;

else

	-- setting permissions
	dx = 413+55; -- when wrapping
	dy = 205;
	little_dx = 0; -- for every window
	num_high = 5;
	y0 = 15;
	y0_2_threshold = 100000;



end

end




function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

function waitForChange(timeout)
	local c=0;
	local startTime = lsGetTimer();
	while srReadPixel(setWaitSpot_x, setWaitSpot_y) == setWaitSpot_px do
		lsSleep(1);
		c = c+1;
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
		if timeout and (lsGetTimer() - startTime > timeout) then
			break;
		end
	end
	lsPrintln('Waited ' .. c .. 'ms for pixel to change.');
end

function drag(x0, y0, x1, y1)
	srSetMousePos(x0, y0);
	setWaitSpot(x1, y1);
	srMouseDown(x0, y0, 0);
	-- lsSleep(15);
	srSetMousePos(x1, y1);
	-- lsSleep(50);
	waitForChange();
	srMouseUp(x0, y0, 0);
	-- lsSleep(50);
end

function dragWaitSource(x0, y0, x1, y1)
	setWaitSpot(x0, y0);
	srMouseDown(x0, y0, 0);
	srSetMousePos(x1, y1);
	waitForChange(1500);
	srMouseUp(x0, y0, 0);
end



function refocusThistles()
	x=x0;
	y=y0;
	yy=1;
	for i=1,num_windows do
		srReadScreen();
		srClickMouseNoMove(x + 50, y + 310);
		y = y + dy;
		yy = yy + 1;
		x = x + little_dx;
		if (yy == num_high+1) then
			yy = 1;
			if (x > y0_2_threshold) then
				y = y0_2;
			else
				y = y0;
			end
			x = x + dx;
		end
		statusScreen("Focusing ..");
		lsSleep(100);
	end
	error 'done';
end


function doit()

while not lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") do



lsPrintWrapped(10, 10, z, lsScreenX - 20, scale, scale, 0xFFFFFFff, "This will arrange your windows according to the defined layouts. Choose layout to arrange:");

--This shrinks down the letter size in pulldown menu. But gets reset by askForWindow below...
lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);

dropdown_cur_value = lsDropdown("ArrangerDropDown", 20, 60, z, 310, dropdown_cur_value, dropdown_values);
		lsDoFrame();
		checkBreak();
end


GetLayout();


	askForWindow("Pin any number of " .. choice .. " windows. Will be arranged according to settings in window_arranger.lua. Press Shift to continue.");

	



	xyScreenSize = srGetWindowSize();
	
	-- refocusThistles();
	
	destx = xyScreenSize[0] - window_w;
	desty = xyScreenSize[1] - window_h;
	srSetMousePos(x0, y0);
	lsSleep(200);
		
	while true do
		srReadScreen();
		local pos = srFindImageInRange("This.png", 0, 0, xyScreenSize[0] - window_w, xyScreenSize[1]);
		if not pos then
			break;
		end
		dragWaitSource(pos[0], pos[1], destx, desty);
		checkBreak();
		lsSleep(100);
	end
	
	x=x0;
	y=y0;
	yy=1;
	while true do
		srReadScreen();
		local pos = srFindImageInRange("This.png", xyScreenSize[0] - window_w - 50, xyScreenSize[1] - window_h - 50, window_w + 50, window_h + 50);
		if not pos then
			error 'Moved all windows';
		end
		drag(pos[0], pos[1], x, y);
		y = y + dy;
		yy = yy + 1;
		x = x + little_dx;
		if (yy == num_high+1) then
			yy = 1;
			if (x > y0_2_threshold) then
				y = y0_2;
			else
				y = y0;
			end
			x = x + dx;
		end
		checkBreak();
	end
end