# Real-time-Gesture-Tracking-in-Whac-A-Mole
How to play?
1. Run code/Game.m to start playing.
2. Keep your fist in the bounding box for 2 seconds to start tracking.
3. Move your fist in front of the camera and the visual fist will move accordingly..
4. Open your hand and make a fist again to catch the rat.
5. When tracking fails, keep your fist in the bounding box for 2 seconds to start again.

Some tips:
1. Keep the background pure for convenience of tracking.
2. Don't move too fast, LKT cannot work when two bounding boxes do not overlap.
3. If the template does not work well, generate your own template by get_template.m.
