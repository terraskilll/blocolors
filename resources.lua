-- loads multiple used resources

---------------------------------------------------------------

version = 0.5

f_font16 = love.graphics.newFont("res/8-bit-pusab.ttf", 16)
f_font8  = love.graphics.newFont("res/8-bit-pusab.ttf", 8)

love.graphics.setFont(f_font16)

---------------------------------------------------------------

i_title         = love.graphics.newImage("res/title.png")

i_blockmid      = love.graphics.newImage("res/middle.png")
i_blockp        = love.graphics.newImage("res/bpp.png")
i_floor         = love.graphics.newImage("res/floor.png")
i_floormini     = love.graphics.newImage("res/floormini.png")
i_exitfloor     = love.graphics.newImage("res/exitfloor.png")
i_exitfloormini = love.graphics.newImage("res/exitfloormini.png")
i_glow1         = love.graphics.newImage("res/glow1.png")
i_help          = love.graphics.newImage("res/help.png")
i_start         = love.graphics.newImage("res/mstart.png")
i_tbg           = love.graphics.newImage("res/tbg.png")

i_completed   = love.graphics.newImage("res/completed.png")
i_failed      = love.graphics.newImage("res/failed.png")
i_howto       = love.graphics.newImage("res/howto.png")
i_greensquare = love.graphics.newImage("res/greensquare.png")

i_pretry     = love.graphics.newImage("res/pretry.png")
i_pnext      = love.graphics.newImage("res/pnext.png")
i_pconfirm   = love.graphics.newImage("res/pconfirm.png")
i_pexitlevel = love.graphics.newImage("res/mexitlevel.png")

i_mjogar = love.graphics.newImage("res/mjogar.png")
i_msair  = love.graphics.newImage("res/msair.png")
i_meditor= love.graphics.newImage("res/meditor.png")
i_mhowto = love.graphics.newImage("res/mhowto.png")
i_mpause = love.graphics.newImage("res/mpause.png")
i_mexec  = love.graphics.newImage("res/mexec.png")
i_msave  = love.graphics.newImage("res/msave.png")
i_mopen  = love.graphics.newImage("res/mopen.png")
i_mnew   = love.graphics.newImage("res/mnew.png")
i_mexit  = love.graphics.newImage("res/mexit.png")
i_mnext  = love.graphics.newImage("res/mnext.png")
i_mprev  = love.graphics.newImage("res/mprev.png")

i_mplus   = love.graphics.newImage("res/mplus.png")
i_mminus  = love.graphics.newImage("res/mminus.png")

i_mbup    = love.graphics.newImage("res/mbup.png")
i_mbdown  = love.graphics.newImage("res/mbdown.png")
i_mbleft  = love.graphics.newImage("res/mbleft.png")
i_mbright = love.graphics.newImage("res/mbright.png")

i_mlevel    = love.graphics.newImage("res/mlevel.png")
i_mduration = love.graphics.newImage("res/mduration.png")

i_lwidth  = love.graphics.newImage("res/mwid.png")
i_lheight = love.graphics.newImage("res/mhei.png")

i_endflag   = love.graphics.newImage("res/endflag.png")
i_startflag = love.graphics.newImage("res/startflag.png")

---------------------------------------------------------------

c_colors = {
	blue    = 1,
	green   = 2,
	yellow  = 3,
	orange  = 4,
	red     = 5,
	purple  = 6
}

e_colors = {
	{200, 200, 200},
	{125, 177, 275},
	{167, 231, 167},
	{255, 238, 169},
	{255, 177, 125},
	{255, 145, 145},
	{218, 167, 231},
	{255, 255, 255},
	{255, 255, 255},
	{255, 255, 255},
	{255, 255, 255},
	{210, 210, 210},
}

---------------------------------------------------------------