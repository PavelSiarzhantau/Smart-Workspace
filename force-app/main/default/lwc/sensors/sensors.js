import { LightningElement, api } from "lwc";
// import getSensorsRecords from "@salesforce/apex/SensorsController.getSensorsRecords";
import FIELD_NAME from "@salesforce/schema/Sensor__c.Name";
const columns = [
  {
    label: "Sensor Name",
    fieldName: "sensorURL",
    type: "url",
    typeAttributes: {
      label: {
        fieldName: FIELD_NAME.fieldApiName
      },
      target: "_blank"
    }
  },
  {
    label: "Owner Name",
    fieldName: "ownerURL",
    type: "url",
    typeAttributes: {
      label: {
        fieldName: "ownerName"
      },
      target: "_blank"
    }
  }
];

export default class Sensors extends LightningElement {
  columns = columns;
  @api preselect = [];
  @api showSensors;
  @api hideSensorSpinner = false;
  @api sensors;

  //when sensor is selected function fired.
  getSelectedRows(event) {
    const selectedRows = event.detail.selectedRows[0];
    const selectedEvent = new CustomEvent("selected", { detail: selectedRows });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
  }
}
