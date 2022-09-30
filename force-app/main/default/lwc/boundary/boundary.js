// boundary.js
import { LightningElement } from "lwc";
export default class Boundary extends LightningElement {
  error;
  errorCallback(error) {
    this.error = error;
  }
}
