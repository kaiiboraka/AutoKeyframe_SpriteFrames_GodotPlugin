## <img width="48" height="48" alt="AutoKey_AnimatedSpriteFrames" src="addons/AutoKey_SpriteFrames/icon.svg" /> Auto-Keyframe `AnimatedSprite2D`'s `SpriteFrames` 

#### *A QOL Plugin for Godot 4.2+*

This Godot editor plugin is designed to streamline the process of animating an `AnimatedSprite2D` node with an `AnimationPlayer`. It reduces the tedious manual work of keyframing each frame of a sprite animation down to a single button-press.


## How to Use

### Installation

1. Place the `AutoKey_SpriteFrames` folder inside your project's `addons` directory.
2. Enable the plugin in `Project > Project Settings > Plugins`.

The final file structure should look like this:
```
res://addons/AutoKey_SpriteFrames/
├── AutoKey_SpriteFrames.gd
├── inspector_plugin.gd
├── plugin.cfg
├── license.md
└── README.md
```

### Usage

<img alt="Custom Button screenshot" src="Button_screenshot.png" />

1.  Select an `AnimatedSprite2D` node in the scene tree. 
	- In the Inspector, you will see a new button at the top: **"Auto-Key SpriteFrames Animation"**.
2.  Ensure it has a sibling `AnimationPlayer` node.
3.  Assign a `SpriteFrames` resource to your `AnimatedSprite2D`.
4.  Select the animation you want to auto-key in the `Animation` property below `Sprite Frames`.
5.  Click the button.


## What It Does

When the button is clicked, the plugin will:

1.   Find the sibling `AnimationPlayer`.
2.   Get the current animation name from the `AnimatedSprite2D` (e.g., "walk").
3.   Create a new `Animation` resource in the `AnimationPlayer` with that name, or find an existing one.
4.   **Automatically generate two tracks:**
		i.   `AnimatedSprite2D:animation`: Sets the current animation name at time `0.0`.
		ii.   `AnimatedSprite2D:frame`: Creates a keyframe for every single frame of the animation in the `SpriteFrames` resource. The timing of these keyframes is based on the FPS (step) set in the `AnimationPlayer`'s animation timeline.
		*   **WARNING**: This will clear all existing frames of the above-mentioned tracks.
5.   Set the total length of the animation (in frames) to match the sprite animation's duration.

This allows you to instantly create a perfectly timed `AnimationPlayer` animation from your `SpriteFrames` with a single click.


## Why

I was getting really fed up with the tedium of finding the AnimatedSprite2D, clicking on the Animation tab, creating new animation, key "animation", click yes to the dialog, and then key every single frame (however long it is) by carpal-tunneling myself to tears going back and forth between clicking the little up-arrow on the frame, and the key next to it, over and over and over.

This does all of those things in ONE button press. 

All you need to do is go to the AnimatedSprite2D, assign a SpriteFrames, select an animation, and click the button once for each animation. EZ-PZ.


### About / License

By Kaiiboraka. Made in Godot 4.5.beta3.mono. Other Godot versions untested.

Licensed under CC0. See `license.md`. I don't care what you do with it, go nuts. Credit me if you like.
