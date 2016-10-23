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

#pragma once

namespace Intrinsic
{
namespace Core
{
namespace GameStates
{
namespace EditingMode
{
enum Enum
{
  kDefault,
  kSelection,
  kTranslation,
  kRotation,
  kScale
};
}

namespace CameraMode
{
enum Enum
{
  kFreeFlight,
  kOrbit
};
}

// <-

struct Editing
{
  static void init();

  static void activate();
  static void deativate();

  static void update(float p_DeltaT);

  static void updatePerInstanceData();
  static void findVisibleEditingDrawCalls(Dod::RefArray& p_DrawCalls);

  // <-

  static Entity::EntityRef _currentlySelectedEntity;
  static EditingMode::Enum _editingMode;
  static float _gridSize;
  static float _gizmoSize;
  static float _cameraSpeed;
};
}
}
}
