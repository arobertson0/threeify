//
// based on PerspectiveCamera from Three.js
//
// Authors:
// * @bhouston
//

import { Matrix4 } from "../../math/Matrix4";
import { Camera } from "./Camera";

export class PerspectiveCamera extends Camera {
  verticalFov: number;
  zoom: number;
  near: number;
  far: number;

  constructor(verticalFov: number, near: number, far: number, zoom = 1.0) {
    super();

    this.verticalFov = verticalFov;
    this.near = near;
    this.far = far;
    this.zoom = zoom;
  }

  getProjection(viewAspectRatio = 1.0): Matrix4 {
    const height = (2.0 * this.near * Math.tan((this.verticalFov * Math.PI) / 180.0)) / this.zoom;
    const width = height * this.pixelAspectRatio * viewAspectRatio;

    const left = -width * 0.5;
    const right = left + width;

    const top = -height * 0.5;
    const bottom = -top + height;

    return new Matrix4().makePerspectiveProjection(left, right, top, bottom, this.near, this.far);
  }
}
