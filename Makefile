bubbles.love: main.lua console.lua sound.lua conf.lua $(wildcard res/*) | dist
	zip dist/$@ $<

dist:
	mkdir dist

clean:
	rm -rf dist
