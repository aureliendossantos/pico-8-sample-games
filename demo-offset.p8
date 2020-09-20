pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--jeu d'aventure
--fairedesjeux.fr

function _init()
	create_player()
	init_msg()
end

function _update()
 if #messages==0 then
	 player_movement()
	end
	update_camera()
	update_msg()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	draw_ui()
	draw_msg()
end
-->8
--map

function draw_map()
	map(0,0,0,0,128,64)
end

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

function update_camera()
 local camx=flr(p.x/16)*16
 local camy=flr(p.y/16)*16
 camera(camx*8,camy*8)
end

function next_tile(x,y)
	local sprite=mget(x,y)
	mset(x,y,sprite+1)
end

function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
	sfx(1)
end

function open_door(x,y)
	next_tile(x,y)
	p.keys-=1
	sfx(2)
end
-->8
--player

function create_player()
	p={
	 x=7,y=4,
	 ox=0,oy=0,
	 start_ox=0,start_oy=0,
	 anim_t=0,
	 sprite=16,
	 keys=0
	}
end

function player_movement()
 newx=p.x
 newy=p.y
 if p.anim_t==0 then
  newox=0
  newoy=0
		if btn(⬅️) then
		 newx-=1
		 newox=8
		 p.flip=true
		elseif btn(➡️) then
		 newx+=1
		 newox=-8
		 p.flip=false
		elseif btn(⬆️) then
		 newy-=1
		 newoy=8
		elseif btn(⬇️) then
		 newy+=1
		 newoy=-8
		end
	end
	
	interact(newx,newy)
	
	if (newx!=p.x or newy!=p.y) and
	not check_flag(0,newx,newy) then
		p.x=mid(0,newx,127)
		p.y=mid(0,newy,63)
		p.start_ox=newox
		p.start_oy=newoy
		p.anim_t=1
	else
	 sfx(0)
	end
	
	--animation
	p.anim_t=max(p.anim_t-0.125,0)
	p.ox=p.start_ox*p.anim_t
	p.oy=p.start_oy*p.anim_t

end

function interact(x,y)
	if check_flag(1,x,y) then
		pick_up_key(x,y)
	elseif check_flag(2,x,y)
	and p.keys>0 then
		open_door(x,y)
	end
	--messages
	if x==4 and y==2 then
		create_msg("panneau","bienvenue dans mon jeu\nd'aventure.")
	end
	if x==8 and y==12 then
		create_msg("alyssa","je n'ai aucune idee de ce qui\nse cache dans ce temple...","fais attention a toi !")
	end
end

function draw_player()
 palt(12,true)
 palt(0,false)
 spr(16,p.x*8,p.y*8)
 palt(0,true)
	spr(17,p.x*8+p.ox,p.y*8+p.oy)
	palt()
end
-->8
--ui

function draw_ui()
 camera()
 rectfill(0,0,47,27,6)
 rectfill(0,0,46,26,1)
 print("p.x:"..p.x.."\np.y:"..p.y.."\noffset x:"..p.ox.."\noffset y:"..p.oy,2,2,7)
end

function print_outline(text,x,y)
	print(text,x-1,y,0)
	print(text,x+1,y,0)
	print(text,x,y-1,0)
	print(text,x,y+1,0)
	print(text,x,y,7)
end
-->8
--messages

function init_msg()
 messages={}
end

function create_msg(name,...)
	msg_title=name
	messages={...}
end

function update_msg()
	if btnp(❎) then
		deli(messages,1)
	end
end

function draw_msg()
 if messages[1] then
  local y=100
  if p.y%16>=9 then
  	y=10
  end
  --titre
  rectfill(7,y,11+#msg_title*4,y+7,2)
  print(msg_title,10,y+2,9)
  --message
  rectfill(3,y+8,124,y+24,4)
  rect(3,y+8,124,y+24,2)
	 print(messages[1],6,y+11,15)
	end
end
__gfx__
000000003333333333333333333333333333333333bbbb3311111111444444444ffffff4dddddddd1111d1110000000000000000000000000000000000000000
000000003333333333a3333333333333333333b33bbaabb3111111114444444444444444dddddddd111111110000000000000000000000000000000000000000
00700700333333333a9a33333333733333333b333bbbab1311111111cccccccc4ffffff4dddddddd1d1111d10000000000000000000000000000000000000000
000770003333333333a333a3333797333bb33b333bbbb31311111111111111114f444f44dddddddd111111110000000000000000000000000000000000000000
000770003333333333333a9a3333733333bb3333313b331311111111111111114ffffff4dddddddd111d11110000000000000000000000000000000000000000
0070070033333333333333a333733333333b33333311113311111111111111114444f444dddddddd111111110000000000000000000000000000000000000000
00000000333333333333333337973333333333333332233311111111111111114ffffff4ddddddddd1111d110000000000000000000000000000000000000000
000000003333333333333333337333333333333333144233111111111111111144444444dddddddd111111110000000000000000000000000000000000000000
c00000cc07777700dddddddddddddddd333333333444443300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000c77777770dddddddddddddddd3999999344ffff4300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000c77777770dddddadddddddddd3444444344f1f14300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000c77777770daaaadaddddddddd3422424344ffff4300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000c777777704a444a44444444443444444333cccc3300000000000000000000000000000000000000000000000000000000000000000000000000000000
c00000cc0777770044444444444444443323323333dd7d3300000000000000000000000000000000000000000000000000000000000000000000000000000000
c00000cc07777700d222222dd222222d334334333cccccc300000000000000000000000000000000000000000000000000000000000000000000000000000000
c00cc0cc07700700dddddddddddddddd333333333363363300000000000000000000000000000000000000000000000000000000000000000000000000000000
cc0ccccc000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0a0000c000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0aaaa00000000033333a3333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0a000a0000000003aaaa3a333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc0ccc0c000000003a333a3333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001444444114400001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004405050444520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009405050495520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009444444495420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004444441444420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009444446494420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009424244494200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004224242442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000
__gff__
0000000000010101000001000000000000000200010100000000000000000000000002000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
05050505050505050505050505050505050505010a0a0a0a0a05050606060505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05050501010101010505050505050505010101050a0912090a05010606050505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05050101140101010101050505050101010201010a0909090a01050606050505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05010101010101010101010505050101040101010a0909090a01030606010505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05050101010101010102010101040101010103010a0a090a0a01010606010505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0501010101010101010101030101010101010101010101010101010606010105010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0505050103010101010101010401070707010101010101010101070606010405010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0505050101010101010101010707060606070707010101070707060606010105010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0507070707070707070708070606060606060606070707060606060601010505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0706060606060606060608060606010101010606060606060101010101010105010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
060606060606060606010101010101010101010101010101010a0a0a0a0a0505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
060601010101010101010101010101010101010a0a0a0a0a0a0a0909090a0505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
050101010104010115010101040101010401010a090909090a0a0909090a0105010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
010501030101010101010101010101010101050a090909090a0a0909090a0105010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
050501010201010101010101010101010103050a090a0a090909090a0a0a0505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
050505010101010101010101010101010101010a090a0a0a0a0a0a0a01050505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
050505010101010101010101010101010101010a090a0a0a0a0a010505050105010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
050501010101010101010102010101010101040a09090909090a050505050501010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000
050105010101010101010401010501010105010a0a0a0909090a050505050505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000
01050101010101030105010105010101010101010a0a0909090a010105050501010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05010401010101010505012201010401010101010a090909090a010405050505010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0501010101010a0a0a0a0a0a0a0a0a01010a0a0a0a090909090a010101050105010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505010101010a090909090909090a0a0a0a090909090909090a0a0a0a0a0a01010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a320a0a0a09090909090909320909090909090909090909090a09090a01010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a09090909090a090909090909090a0a0a0a090909090909090a090a09090a05010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a09090909090a090909090909090a01010a0a0a0a090a0a0a0a090a0a090a05010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a09090909090a0a090a0a0a0a0a0a01050505010a0909090909090909090a05010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a09090909090909090a010101010105050505050a0909090909090909090a05010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a010101010505010505050a0a0a0a0a0a0a0a0a0a0a05010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050101010101010101010505050505050505050501010101010101050505010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505010101010105050505050105010505050505050505050505010505010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050501050505050105050505050105050505050505010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000c02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001e5501e5501e5501e55023500285001e5501e5501e5501e5502b5502b5502b5502b5502b5502b55000500005000050000500005000050000500005000050000500005000050000500005000050000500
000a00000d63023630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
