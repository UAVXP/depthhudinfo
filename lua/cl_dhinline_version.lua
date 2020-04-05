////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Version                                    //
////////////////////////////////////////////////

local MY_VERSION = "2.05"
local SVN_VERSION = nil
local DOWNLOAD_LINK = nil

function dhinline.GetVersionData()
	return MY_VERSION, SVN_VERSION, DOWNLOAD_LINK
end

function dhinline.GetVersion( contents , size )
	//Taken from RabidToaster Achievements mod.
	local split = string.Explode( "\n", contents )
	local version = tonumber( split[ 1 ] or "" )

	if ( !version ) then
		SVN_VERSION = -1
		return
	end

	SVN_VERSION = version

	if ( split[ 2 ] ) then
		DOWNLOAD_LINK = split[ 2 ]
	end

	//print( MY_VERSION , SVN_VERSION , DOWNLOAD_LINK )
end
--http.Get( "http://depthhudinfo.googlecode.com/svn/trunk/data/depthhud_inline.txt", "", dhinline.GetVersion )
