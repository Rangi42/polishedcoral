Route10_MapScriptHeader:
	db 5 ; scene scripts
	scene_script Route10Trigger0
	scene_script Route10Trigger1
	scene_script Route10Trigger2
	scene_script Route10Trigger3
	scene_script Route10Trigger4

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, Route10Random

	db 2 ; warp events
	warp_def 35, 13, 3, FLICKER_PASS_2F
	warp_def 47,  7, 4, FLICKER_PASS_2F

	db 44 ; coord events
	xy_trigger 1, 30, 19, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1, 31, 20, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1, 32, 19, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1, 33, 20, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1, 34, 21, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1, 35, 20, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 31, 28, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 32, 29, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 33, 30, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 34, 31, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 36, 32, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 37, 33, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 38, 34, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 39, 33, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 40, 34, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 41, 33, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 42, 32, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 43, 33, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 30, 44, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 16, 47, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 26, 33, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 32, 37, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 36, 27, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 32, 24, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 21, 39, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 15, 42, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 14, 33, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 3, 27, 50, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  3, 10, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  4, 11, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  5, 14, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  4, 15, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  5, 16, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  4, 17, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  5, 18, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1,  4, 19, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 13, 20, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 14, 21, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 13, 22, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 12, 23, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1, 22, 55, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 1, 23, 55, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 22, 55, 0, Route10StartSnowstorm, 0, 0
	xy_trigger 2, 23, 55, 0, Route10StartSnowstorm, 0, 0

	db 0 ; bg events

	db 0 ; object events

Route10Trigger0:
	end
	
Route10Trigger1:
	end
	
Route10Trigger2:
	end
	
Route10Trigger3:
	end
	
Route10Trigger4:
	callasm Route10SfxAsm
	end
	
Route10Random:
	checkevent EVENT_SNOWSTORM_HAPPENING
	iftrue .endcallback
	callasm Route10RandomAsm
.endcallback
	return
	
Route10SfxAsm:
	farcall CheckSFX
	ret c
	ld de, SFX_SNOWSTORM
	farcall PlaySFX
	ret
	
Route10StartSnowstorm:
	setevent EVENT_SNOWSTORM_HAPPENING
	loadvar wTimeOfDayPalFlags, $40 | 1
	playsound SFX_SNOWSTORM_INTRO
	dotrigger $4
	end
	
Route10RandomAsm:
	call Random
	cp $5f ; 33 percent
	ret c
	call Random
	cp $3f ; 25 percent
	jr c, Route10SetScene1Asm
	call Random
	cp $3f ; 25 percent
	jr c, Route10SetScene2Asm
	jr Route10SetScene3Asm
	
Route10SetScene1Asm:
	ld b, BANK(Route10SetScene1Script)
	ld de, Route10SetScene1Script
	jr Route10SetSceneFinishAsm
	
Route10SetScene2Asm:
	ld b, BANK(Route10SetScene2Script)
	ld de, Route10SetScene2Script
	jr Route10SetSceneFinishAsm
	
Route10SetScene3Asm:
	ld b, BANK(Route10SetScene3Script)
	ld de, Route10SetScene3Script
	
Route10SetSceneFinishAsm:
	push de
	ld hl, wScriptStackSize
	ld e, [hl]
	inc [hl]
	ld d, $0
	ld hl, wScriptStack
	add hl, de
	add hl, de
	add hl, de
	pop de
	ld a, [wScriptBank]
	ld [hli], a
	ld a, [wScriptPos]
	ld [hli], a
	ld a, [wScriptPos + 1]
	ld [hl], a
	ld a, b
	ld [wScriptBank], a
	ld a, e
	ld [wScriptPos], a
	ld a, d
	ld [wScriptPos + 1], a
	ret
	
Route10SetScene1Script:
	dotrigger $1
	end
	
Route10SetScene2Script:
	dotrigger $2
	end
	
Route10SetScene3Script:
	dotrigger $3
	end
