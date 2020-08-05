pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
 p={x=60,y=80,speed=1.5}
 bullets={}
 enemies={}
 explosions={}
 create_stars()
end

function _update60()
 if (btn(➡️)) p.x+=p.speed
 if (btn(⬅️)) p.x-=p.speed
 if (btn(⬇️)) p.y+=p.speed
 if (btn(⬆️)) p.y-=p.speed
 if (btnp(❎)) shoot()
 update_bullets()
 update_stars()
 update_enemies()
 update_explosions()
 
 if #enemies==0 then
 	spawn_enemies(ceil(rnd(7)))
 end
end

function _draw()
 cls()
 --etoiles
 for s in all(stars) do
 	pset(s.x,s.y,s.col)
 end
 --vaisseau
 spr(1,p.x,p.y)
 --ennemis
 for e in all(enemies) do
 	spr(3,e.x,e.y)
 end
 --balles
 for b in all(bullets) do
 	spr(2,b.x,b.y)
 end
 --explosions
 draw_explosions()
end
-->8
--bullets

function shoot()
 local new_bullet={
  x=p.x,
  y=p.y,
  speed=4
 }
 add(bullets, new_bullet)
 sfx(0)
end

function update_bullets()
	for b in all(bullets) do
		b.y-=b.speed
		if (b.y<-8) del(bullets,b)
	end
end
-->8
--stars

function create_stars()
	stars={}
	for i=1,20 do
		local new_star={
		 x=rnd(128),
		 y=rnd(128),
		 col=1,
		 speed=1+rnd(0.5)
	 }
	 add(stars, new_star)
	end
	for i=1,8 do
		local new_star={
		 x=rnd(128),
		 y=rnd(128),
		 col=6,
		 speed=3+rnd(1)
	 }
	 add(stars, new_star)
	end
end

function update_stars()
	for s in all(stars) do
		s.y+=s.speed
		if s.y>128 then
			s.y=0
			s.x=rnd(128)
		end
	end
end
-->8
--enemies

function spawn_enemies(amount)
	gap=(128-8*amount)/(amount+1)
	for i=1,amount do
		add(enemies,{
		 x=gap*i + 8*(i-1),
		 y=-24,
		 life=4
		})
	end
end

function update_enemies()
 for enemy in all(enemies) do
  enemy.y += 0.3
  if enemy.y > 130 then
   del(enemies,enemy)
  end
  --collision
  for b in all(bullets) do
  	if collision(enemy,b) then
  		create_explosion(b.x+4,b.y+3)
  		del(bullets,b)
  		enemy.life-=1
  		if enemy.life==0 then
  			del(enemies,enemy)
				end
			end
  end
 end
end
-->8
--tools

function collision(a,b)
	return not (a.x > b.x+8
	            or a.y > b.y+8
	            or a.x+8 < b.x
	            or a.y+8 < b.y)
end
-->8
--explosions

function create_explosion(x,y)
	add(explosions,{
	 x = x,
	 y = y,
	 timer = 0
	})
	sfx(1)
end

function update_explosions()
	for boom in all(explosions) do
		boom.timer += 1
		if boom.timer == 13 then
			del(explosions, boom)
		end
	end
end

function draw_explosions()
	for boom in all(explosions) do
		circ(boom.x, boom.y,
		 boom.timer/3, 8+boom.timer%3)
	end
end
__gfx__
000000000060060000a00a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000060060000a00a000bb00bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070006dc7d600090090000b33b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700006dccd600000000003bbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000d66dd66d00900900038bb830000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700d666666d00000000003bb300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050dd0500000000002033020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000e00e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002d5503055032550325502e55029540235401b530145200e5200b510085100651000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000200002562026630266302662023610206101a61014610006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
