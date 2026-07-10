#version 460 core
#include <flutter/runtime_effect.glsl>

// ElevenLabs-style fluid orb: domain-warped noise "stirs" the palette so the
// colours fold and curl into each other like ink in water.

uniform vec2 uSize;
uniform float uTime;
uniform float uIntensity;
uniform vec3 uDominantColor;
uniform vec3 uVibrantColor;

out vec4 fragColor;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
             mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
             u.y);
}

float fbm(vec2 p) {
  float v = 0.0;
  float a = 0.5;
  for (int i = 0; i < 4; i++) {
    v += a * noise(p);
    p = p * 2.0 + vec2(13.7, 7.3);
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  vec2 p = uv * 2.0 - 1.0;
  float r = length(p);
  if (r > 1.0) {
    fragColor = vec4(0.0);
    return;
  }

  // Baseline flow speed (talking deepens the stir via amp below).
  float t = uTime * 0.16;
  float amp = 1.0 + 0.6 * uIntensity;

  // Gentle swirl: rotate coordinates more near the centre, so the field is
  // constantly being "stirred".
  float swirl = (1.0 - r) * 0.9 * sin(t * 1.7);
  float cs = cos(swirl);
  float sn = sin(swirl);
  vec2 sp = vec2(p.x * cs - p.y * sn, p.x * sn + p.y * cs);

  // Domain warp: offset the noise lookup by more noise → liquid folding.
  vec2 q = vec2(fbm(sp * 1.4 + vec2(t, -t * 1.3)),
                fbm(sp * 1.4 + vec2(-t * 0.7, t)));
  vec2 w = sp + amp * 1.1 * (q - 0.5);

  float n1 = fbm(w * 1.7 + vec2(t * 1.5, 0.0));
  float n2 = fbm(w * 2.2 + vec2(0.0, -t));
  float n3 = fbm(w * 1.1 + vec2(-t * 0.6, t * 0.4));

  // Palette: derived from the same dominant/vibrant cover-art colours used by
  // the program detail mesh background, so the orb belongs to that show/event.
  vec3 c1 = uDominantColor;
  vec3 c2 = mix(uDominantColor, uVibrantColor, 0.45);
  vec3 c3 = uVibrantColor;
  vec3 c4 = mix(uVibrantColor, vec3(1.0), 0.22);
  vec3 c5 = mix(uDominantColor, vec3(1.0), 0.16);

  vec3 col = mix(c1, c2, smoothstep(0.25, 0.75, n1));
  col = mix(col, c3, smoothstep(0.35, 0.85, n2));
  col = mix(col, c4, smoothstep(0.40, 0.90, n3));
  col = mix(col, c5, smoothstep(0.55, 0.95, q.x));

  // Rippling rim: smooth waves travel around the edge while voice is coming
  // in (recording) or going out (playback); silent = clean circle. `dir` is
  // seamless around the rim (no atan seam).
  vec2 dir = r > 0.0001 ? p / r : vec2(1.0, 0.0);
  float w1 = fbm(dir * 2.6 + vec2(t * 2.6, -t * 2.0));
  float ripple = uIntensity * (0.10 * (w1 - 0.5));
  float edge = min(0.975 + ripple, 0.995);
  float mask = smoothstep(edge, edge - 0.02, r);
  fragColor = vec4(col, 1.0) * mask;
}
