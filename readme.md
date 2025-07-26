# Auto Keyframe SpriteFrames Plugin


## Functionality Overview

This Godot editor plugin is designed to streamline the process of animating an `AnimatedSprite2D` node with an `AnimationPlayer`. It eliminates the tedious manual work of keyframing each frame of a sprite animation.


## How to Use

1.  Select an `AnimatedSprite2D` node in the scene tree. 
		In the Inspector, you will see a new button at the top: **"Auto Keyframe All Frames"**.
2.  Ensure it has a sibling `AnimationPlayer` node.
3.  Assign a `SpriteFrames` resource to your `AnimatedSprite2D`.
4.  Select the animation you want to auto-key in the `Animation` property below `Sprite Frames`.
5.  Click the button.


## What It Does

When the button is clicked, the plugin will:

*   Find the sibling `AnimationPlayer`.
*   Get the current animation name from the `AnimatedSprite2D` (e.g., "walk").
*   Create a new `Animation` resource in the `AnimationPlayer` with that name, or find an existing one.
*   **Automatically generate two tracks:**
	1.   `AnimatedSprite2D:animation`: Sets the current animation name at time `0.0`.
	2.   `AnimatedSprite2D:frame`: Creates a keyframe for every single frame of the animation in the `SpriteFrames` resource. The timing of these keyframes is based on the FPS (step) set in the `AnimationPlayer`'s animation timeline.
*   WARNING: This will clear all existing frames of the above-mentioned tracks.
*   Set the total length of the animation (in frames) to match the sprite animation's duration.

This allows you to instantly create a perfectly timed `AnimationPlayer` animation from your `SpriteFrames` with a single click.


## Why

I was getting really fed up with the tedium of finding the AnimatedSprite2D, clicking on the Animation tab, creating new animation, key "animation", click yes to the dialog, and then key every single frame (however long it is) by carpal-tunneling myself to tears going back and forth between clicking the little up-arrow on the frame, and the key next to it, over and over and over.

This does all of those things in ONE button press. 

All you need to do is go to the AnimatedSprite2D, assign a SpriteFrames, select an animation, and click the button once for each animation. EZ-PZ.


## About

By Kaiiboraka. Made in Godot 4.5.beta3.mono. Other Godot versions untested.
