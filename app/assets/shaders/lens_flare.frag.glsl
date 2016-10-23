// Intrinsic
// Copyright (c) 2016 Benjamin Glatzel
//
// This program is free software : you can redistribute it and / or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
#extension GL_GOOGLE_include_directive : enable

#include "lib_math.glsl"

layout (binding = 0) uniform PerInstance
{
  float _dummy;
} uboPerInstance;

layout (binding = 1) uniform sampler2D brightnessTex;
layout (binding = 2) uniform sampler2D lensFlareTex;

layout (location = 0) in vec2 inUV0;
layout (location = 0) out vec4 outColor;

vec3 chromaDistort(in sampler2D tex, in vec2 texcoord, in vec2 direction, in vec3 distortion) 
{
  return vec3(
     textureLod(tex, texcoord + direction * distortion.r, 0.0).r,
     textureLod(tex, texcoord + direction * distortion.g, 0.0).g,
     textureLod(tex, texcoord + direction * distortion.b, 0.0).b
  );
}

void main()
{
  const vec2 uv0 = -inUV0 + vec2(1.0);
  const vec2 texelSize = 1.0 / vec2(textureSize(brightnessTex, 0));

  const float ghostDisp = 0.1;
  const uint numGhosts = 8;
  const float haloWidth = 0.25;
  const float distortionFactor = 2.0;
  const float brightnessBias = 8.0;
  const float brightnessMax = 2.0;

  const vec2 ghostDir = (vec2(0.5) - uv0) * ghostDisp;
  const vec3 distortion = vec3(-texelSize.x * distortionFactor, 0.0, texelSize.x * distortionFactor);
  const vec2 direction = normalize(ghostDir);

  vec3 result = vec3(0.0);
  for (int i=0; i<numGhosts; ++i)
  { 
    const vec2 offset = fract(uv0 + ghostDir * float(i));

    float weight = length(vec2(0.5) - offset) / length(vec2(0.5));
    weight = pow(1.0 - weight, 8.0);

    result += weight * min(max(chromaDistort(brightnessTex, offset, direction, distortion) - brightnessBias, 0.0), brightnessMax);
  }

  // Halo
  vec2 haloVec = normalize(ghostDir) * haloWidth;
  float weight = length(vec2(0.5) - fract(uv0 + ghostDir)) / length(vec2(0.5));
  weight = pow(1.0 - weight, 4.0);
  result += min(max(chromaDistort(brightnessTex, uv0 + haloVec, direction, distortion) - brightnessBias, 0.0), brightnessMax) * weight;

  const vec3 tint = vec3(1.0, 1.0, 1.0);

  result *= tint * textureLod(lensFlareTex, vec2(length(vec2(0.5) - uv0) / length(vec2(0.5)), 0.0), 0.0).rgb;
  outColor.rgba = vec4(result, 1.0);
}
