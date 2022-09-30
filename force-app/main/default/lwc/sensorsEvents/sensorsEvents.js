import { LightningElement, api, track } from "lwc";
import FIELD_NAME from "@salesforce/schema/Sensor_Event__c.Name";
import FIELD_X from "@salesforce/schema/Sensor_Event__c.x__c";
import FIELD_Y from "@salesforce/schema/Sensor_Event__c.y__c";
import FIELD_Z from "@salesforce/schema/Sensor_Event__c.z__c";
import FIELD_MODULUS_VECTOR_LENGTH from "@salesforce/schema/Sensor_Event__c.Modulus_Vector_Length__c";
import FIELD_SENSOR_NAME from "@salesforce/schema/Sensor_Event__c.Sensor__r.Name";
import FIELD_PREVIOUS_SENSOR_EVENT from "@salesforce/schema/Sensor_Event__c.Sensor_Event__r.Name";
import { updateRecord } from "lightning/uiRecordApi";
import { reduceErrors } from "c/ldsUtils";
const columns = [
  {
    label: "Sensor Event Name",
    fieldName: "eventURL",
    initialWidth: 170,
    type: "url",
    typeAttributes: {
      label: {
        fieldName: FIELD_NAME.fieldApiName
      },
      target: "_blank"
    }
  },
  {
    label: "x",
    fieldName: FIELD_X.fieldApiName,
    initialWidth: 70,
    editable: true
  },
  {
    label: "y",
    fieldName: FIELD_Y.fieldApiName,
    initialWidth: 70,
    editable: true
  },
  {
    label: "z",
    fieldName: FIELD_Z.fieldApiName,
    initialWidth: 70,
    editable: true
  },
  {
    label: "Modulus Vector length",
    fieldName: FIELD_MODULUS_VECTOR_LENGTH.fieldApiName,
    initialWidth: 190
  },
  {
    label: "Sensor Name",
    fieldName: "sensorURL",
    initialWidth: 150,
    type: "url",
    typeAttributes: {
      label: {
        fieldName: FIELD_SENSOR_NAME.fieldApiName
      },
      target: "_blank"
    }
  },
  {
    label: "Previous Event",
    fieldName: "previousEventURL",
    type: "url",
    typeAttributes: {
      label: {
        fieldName: FIELD_PREVIOUS_SENSOR_EVENT.fieldApiName
      },
      target: "_blank"
    }
  }
];

export default class SensorsEvents extends LightningElement {
  columns = columns;
  @api selectedSensor;
  @api showSensorEvents;
  @api hideEventSpinner = false;
  @api events;
  @api sensorName;
  @api maxVectorLength;
  @track inlineErrors;

  prepareSensorsEventsData(data) {
    return data.map((record) => {
      let finalObj = {
        ...record,
        eventURL: "/lightning/r/Sensor_Event__c/" + record.Id + "/view",
        sensorURL: "/lightning/r/Sensor__c/" + record.Sensor__c + "/view",
        [FIELD_SENSOR_NAME.fieldApiName]: record.Sensor__r.Name
      };
      if (Object.prototype.hasOwnProperty.call(record, "Sensor_Event__r")) {
        return {
          ...finalObj,
          previousEventURL:
            "/lightning/r/Sensor_Event__c/" + record.Sensor_Event__c + "/view",
          [FIELD_SENSOR_NAME.fieldApiName]: record.Sensor__r.Name,
          [FIELD_PREVIOUS_SENSOR_EVENT.fieldApiName]:
            record.Sensor_Event__r.Name
        };
      }
      return finalObj;
    });
  }
  async handleSave(event) {
    // Convert data-table draft values into record objects
    const rec = event.detail.draftValues;
    this.inlineErrors = {};
    let rows = {};
    rec.forEach((e) => {
      let { Id, ...obj } = e;
      let preparedObject = { [e.Id]: obj };

      let errorObject = {
        title: "We found errors.",
        messages: "Enter a valid number.",
        fieldNames: []
      };
      for (let prop in preparedObject[e.Id]) {
        if (!/^[0-9.]+$/.test(preparedObject[e.Id][prop])) {
          errorObject.fieldNames.push(prop);
        }
      }
      if (errorObject.fieldNames.length) {
        Object.assign(rows, { [e.Id]: errorObject });
      }
    });
    if (Object.keys(rows).length !== 0) {
      this.inlineErrors = {
        rows: rows,
        table: {
          title: "Your entry cannot be saved. Fix the errors and try again.",
          messages: ["Coordinate must be number"]
        }
      };
    } else {
      const records = event.detail.draftValues.slice().map((draftValue) => {
        const fields = Object.assign({}, draftValue);
        return { fields };
      });
      // console.log(records);
      // Clear all data-table draft values
      this.template.querySelector("lightning-datatable").draftValues = [];
      try {
        // Update all records in parallel thanks to the UI API
        const recordUpdatePromises = records.map((record) =>
          updateRecord(record)
        );
        await Promise.all(recordUpdatePromises);
        let updateEvent = new CustomEvent("updated");
        await this.dispatchEvent(updateEvent);
      } catch (error) {
        console.error(reduceErrors(error));
      }
    }
  }
}
