import { LightningElement, track, api, wire } from "lwc";
import { subscribe, onError } from "lightning/empApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadStyle } from "lightning/platformResourceLoader";
import CUSTOMCSS from "@salesforce/resourceUrl/Multiline_Toast_Message";
import getSensorsRecords from "@salesforce/apex/SensorsController.getSensorsRecords";
import getSensorsEventsRecords from "@salesforce/apex/SensorEvenstController.getSensorsEventsRecords";
import { refreshApex } from "@salesforce/apex";
import { reduceErrors } from "c/ldsUtils";
export default class AppWrapper extends LightningElement {
  @track selectedSensor;
  @api channelName = "/event/Sensor_Tracking_Event__e";
  @track preSelectedRow = [];
  @track events;
  @track sensors;
  subscription = {};
  isCssLoaded = false;
  showSensors;
  showSensorEvents;
  hideSensorSpinner;
  hideEventSpinner;
  sensorName;
  maxVectorLength;
  _wiredData;
  _wiredDataEvents;

  connectedCallback() {
    try {
      //register error listener
      this.registerErrorListener();
      //subcribe to channel
      this.handleSubscribe();
    } catch (error) {
      console.error(reduceErrors(error));
      this.ShowToastEvent(error.name(), error.message(), "error", "pester");
    }
  }

  renderedCallback() {
    //override styles in toast message to show text in multiple lines
    if (this.isCssLoaded) return;
    this.isCssLoaded = true;
    loadStyle(this, CUSTOMCSS)
      .then(() => {
        console.log("override styles loaded succesfully");
      })
      .catch((error) => {
        console.error(reduceErrors(error));
        this.ShowToastEvent(error.name(), error.message(), "error", "pester");
      });
  }
  //get sensors from database 
  @wire(getSensorsRecords)
  getSensors(result) {
    this._wiredData = result;
    if (result.data) {
      this.sensors = this.prepareSensorsData(result.data);
      this.hideEventSpinner = true;
      if (result.data.length) {
        this.hideSensorSpinner = true;
        //setup preselect
        if (!this.showSensors) {
          this.showSensors = true;
          let my_ids = [];
          my_ids.push(result.data[0].Id);
          this.preSelectedRow = my_ids;
          this.selectedSensor = result.data[0];
          //setup selected row when delete selected sensor
        } else if (
          !result.data.find((sensor) => sensor.Id === this.selectedSensor.Id)
        ) {
          let my_ids = [];
          my_ids.push(result.data[0].Id);
          this.preSelectedRow = my_ids;
        }
        //hide sensors if we dont have any sensors in database
      } else {
        this.showSensors = false;
        this.hideSensorSpinner = true;
      }
    } else if (result.error) {
      console.error(reduceErrors(result.error));
      this.ShowToastEvent(
        result.error.name(),
        result.error.message(),
        "error",
        "pester"
      );
    }
  }
  //sensor Events
  @wire(getSensorsEventsRecords, { recordId: "$selectedSensor.Id" })
  getSensorsEvents(result) {
    this._wiredDataEvents = result;
    if (result.data) {
      if (result.data.length) {
        this.sensorName = result.data[0].Sensor__r.Name;
        this.maxVectorLength = result.data[0].Sensor__r.Max_Vectors_Length__c;
        this.sendEvents(result.data);
        this.showSensorEvents = true;
      } else {
        this.showSensorEvents = false;
      }
    } else if (result.error) {
      console.error(reduceErrors(result.error));
      this.ShowToastEvent(
        result.error.name(),
        result.error.message(),
        "error",
        "pester"
      );
    }
  }
  //prepare custom view of sensors within data-table
  prepareSensorsData(sensors) {
    return sensors.map((elem) => {
      return {
        ...elem,
        ownerName: elem.Owner.Name,
        ownerURL: "/lightning/r/User/" + elem.OwnerId + "/view",
        sensorURL: "/lightning/r/Sensor__c/" + elem.Id + "/view"
      };
    });
  }
  //select sensor handler
  async handleSelectedSensor(event) {
    this.selectedSensor = event.detail;
    await refreshApex(this._wiredData);
    await refreshApex(this._wiredDataEvents);
  }
  //refresh sensor events when it's updated inline.
  handleUpdatedEvent() {
    refreshApex(this._wiredDataEvents);
  }
  //send events in sensorsEvents element
  sendEvents(events) {
    const elem = this.template.querySelector("c-sensors-events");
    elem.enterEventsToDataTable(events);
  }

  //subscribe to paltform events
  handleSubscribe() {
    // Callback invoked whenever a new event message is received
    const messageCallback = (response) => {
      let obj = JSON.parse(JSON.stringify(response));
      let objData = obj.data.payload;
      this.showToast(
        objData.message__c,
        objData.Sensors_names__c,
        "success",
        "pester"
      );
      this.refreshSensors();
      this.refreshSensorEvents();
    };
    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(this.channelName, -1, messageCallback).then((response) => {
      this.subscription = response;
    });
  }
  //show toast message to user
  showToast = (title, message, variant, mode) => {
    const evt = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant,
      mode: mode
    });
    this.dispatchEvent(evt);
  };

  refreshSensorEvents = () => {
    refreshApex(this._wiredDataEvents);
  };
  refreshSensors = () => {
    refreshApex(this._wiredData);
  };

  registerErrorListener() {
    // Invoke onError empApi method
    onError((error) => {
      console.error(reduceErrors(error));
      // Error contains the server-side error
      this.ShowToastEvent(error.name(), error.message(), "error", "pester");
    });
  }
}