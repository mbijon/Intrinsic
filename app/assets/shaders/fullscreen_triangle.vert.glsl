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

out gl_PerVertex
{
  vec4 gl_Position;
};

layout (location = 0) out vec2 outUV0;

void main()
{
  outUV0 = vec2(float(gl_VertexIndex / 2) * 2.0, float(gl_VertexIndex % 2) * 2.0);
  gl_Position = vec4(float(gl_VertexIndex / 2) * 4.0 - 1.0, float(gl_VertexIndex % 2) * 4.0 - 1.0, 0.0, 1.0);
}
